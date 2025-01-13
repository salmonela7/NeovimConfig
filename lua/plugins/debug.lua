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
            require("dap-go").setup({})
            require("dapui").setup({})
            require("dap.ext.vscode").load_launchjs(nil, {})

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- dap.adapters.go = {
            -- 	type = "executable",
            -- 	command = "node",
            -- 	args = { os.getenv("USERPROFILE") .. "/dev/golang/vscode-go/extension/dist/debugAdapter.js" },
            -- }
            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug (loan-service)",
                    request = "launch",
                    showLog = false,
                    program = os.getenv("USERPROFILE") .. "/Documents/Projects/mfsu-sunday-service-loan",
                    dlvToolPath = vim.fn.exepath("dlv"),
                },
            }

            vim.keymap.set("n", "<F5>", function()
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
            vim.keymap.set("n", "<leader>B", function()
                require("dap").set_breakpoint()
            end)
            vim.keymap.set("n", "<leader>lp", function()
                require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
            end)
            vim.keymap.set("n", "<leader>dr", function()
                require("dap").repl.open()
            end)
            vim.keymap.set("n", "<leader>dl", function()
                require("dap").run_last()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dh", function()
                require("dap.ui.widgets").hover()
            end)
            vim.keymap.set({ "n", "v" }, "<leader>dp", function()
                require("dap.ui.widgets").preview()
            end)
            vim.keymap.set("n", "<leader>df", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.frames)
            end)
            vim.keymap.set("n", "<leader>ds", function()
                local widgets = require("dap.ui.widgets")
                widgets.centered_float(widgets.scopes)
            end)

            vim.fn.sign_define("DapBreakpoint", {
                text = "🔴", -- nerdfonts icon here
                texthl = "DapBreakpointSymbol",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })
            vim.fn.sign_define("DapStopped", {
                text = "🔴", -- nerdfonts icon here
                texthl = "DapStoppedSymbol",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint",
            })

            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "🔴", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
        end,
    },
}
