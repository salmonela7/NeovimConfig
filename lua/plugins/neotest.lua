return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			{
				"fredrikaverpil/neotest-golang",
				dependencies = {
					"uga-rosa/utf8.nvim",
				},
			},
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)

			local neotest = require("neotest")
			neotest.setup({
				discovery = {
					enabled = false,
				},
				output_panel = { open = "vsplit" },
				adapters = {
					require("neotest-golang")({
						sanitize_output = true,
						go_test_args = {},
						runner = "gotestsum",
					}),
				},
				status = { virtual_text = true },
				output = { open_on_run = true },
				quickfix = {
					open = function()
						vim.cmd("Trouble quickfix")
					end,
					enabled = true,
				},
			})

			vim.keymap.set("n", "<leader>tf", function()
				vim.cmd("silent! wa")
				neotest.run.run(vim.fn.expand("%"))
			end)

			vim.keymap.set("n", "<leader>tl", function()
				vim.cmd("silent! wa")
				neotest.run.run_last()
			end)

			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end)

			vim.keymap.set("n", "<leader>tO", function()
				neotest.output_panel.toggle()
			end)

			vim.keymap.set("n", "<leader>tt", function()
				vim.cmd("silent! wa")
				neotest.run.run()
			end)

			vim.keymap.set("n", "<leader>dt", function()
				vim.cmd("silent! wa")
				neotest.run.run({ strategy = "dap" })
			end)

			vim.keymap.set("n", "<leader>dl", function()
				vim.cmd("silent! wa")
				neotest.run.run_last({ strategy = "dap" })
			end)

			vim.keymap.set("n", "<leader>at", function()
				vim.cmd("silent! wa")
				neotest.run.run(vim.fn.getcwd())
			end)

			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end)

			vim.keymap.set("n", "[t", function()
				neotest.jump.prev({ status = "failed" })
			end)

			vim.keymap.set("n", "]t", function()
				neotest.jump.next({ status = "failed" })
			end)
		end,
	},
}
