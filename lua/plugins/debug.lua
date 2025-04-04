return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            local spinner = require("easy-dotnet.ui-modules.spinner").new()
            require("dap-go").setup({
                delve = {
                    detached = false,
                },
            })
            require("dapui").setup({
                layouts = {
                    {
                        elements = {
                            {
                                id = "repl",
                                size = 0.3,
                            },
                            {
                                id = "scopes",
                                size = 0.7,
                            },
                        },
                        position = "bottom",
                        size = 15,
                    },
                    {
                        elements = {
                            {
                                id = "stacks",
                                size = 0.6,
                            },
                            {
                                id = "breakpoints",
                                size = 0.2,
                            },
                            {
                                id = "console",
                                size = 0.2,
                            },
                        },
                        position = "left",
                        size = 25,
                    },
                },
            })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.after.launch.dapui_config = function()
                spinner:stop_spinner("Running")
            end
            dap.listeners.before.initialize.dapui_config = function()
                spinner:start_spinner("Building")
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
                spinner:stop_spinner("Terminated")
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
                spinner:stop_spinner("Exited")
            end

            vim.keymap.set("n", "<F5>", function()
                debug_dll = nil
                require("dap").continue()
            end)
            vim.keymap.set("n", "<F10>", function()
                require("dap").step_over()
            end)
            vim.keymap.set("n", "<F11>", function()
                require("dap").step_into()
            end)
            vim.keymap.set("n", "<F12>", function()
                require("dap").step_out()
            end)
            vim.keymap.set("n", "<leader>b", function()
                require("dap").toggle_breakpoint()
            end)
            vim.keymap.set("n", "<leader>dr", function()
                require("dap").repl.open()
            end)
            vim.keymap.set("n", "<leader>db", function()
                require("dapui").toggle()
            end)
            vim.keymap.set("n", "<leader>?", function()
                require("dapui").eval(nil, { enter = true })
            end)

            vim.fn.sign_define("DapBreakpoint", {
                text = "🔴", -- nerdfonts icon here
                texthl = "DapBreakpointSymbol",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })

            vim.fn.sign_define("DapStopped", {
                text = "", -- nerdfonts icon here
                texthl = "Visual",
                linehl = "Visual",
                numhl = "Visual",
            })

            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "🔴", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

            dap.adapters.coreclr = {
                type = "executable",
                command = "netcoredbg",
                args = { "--interpreter=vscode" },
            }

            local dotnet = require("easy-dotnet")
            local debug_dll = nil

            local function ensure_dll()
                if debug_dll ~= nil then
                    return debug_dll
                end
                local dll = dotnet.get_debug_dll()
                debug_dll = dll
                return dll
            end

            local function rebuild_project(co, path)
                spinner:start_spinner("Building")
                vim.fn.jobstart(string.format("dotnet build %s", path), {
                    on_exit = function(_, return_code)
                        if return_code == 0 then
                            spinner:stop_spinner("Built successfully")
                        else
                            spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
                            error("Build failed")
                        end
                        coroutine.resume(co)
                    end,
                })
                coroutine.yield()
            end

            dap.configurations.cs = {
                {
                    type = "coreclr",
                    name = "launch - netcoredbg",
                    request = "launch",
                    env = function()
                        local dll = ensure_dll()
                        local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
                        return vars or nil
                    end,
                    program = function()
                        local dll = ensure_dll()
                        local co = coroutine.running()
                        rebuild_project(co, dll.project_path)
                        return dll.relative_dll_path
                    end,
                    cwd = function()
                        local dll = ensure_dll()
                        return dll.relative_project_path
                    end,
                },
            }

            dap.configurations.go = {}
        end,
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end,
    },
}
