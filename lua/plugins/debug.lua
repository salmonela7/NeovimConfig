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
			-- require("dap.ext.vscode").load_launchjs(nil, {})

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

			dap.configurations.go = {
				{
					type = "go",
					name = "Debug (loan-service)",
					request = "launch",
					showLog = false,
					program = os.getenv("USERPROFILE")
						.. "/Documents/Projects/mfsu-sunday-service-loan/cmd/sunday-service-loan-server/main.go",
					dlvToolPath = vim.fn.exepath("dlv"),
				},
			}
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}
