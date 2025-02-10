return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
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
				-- output = { open_on_run = false },
				output_panel = { open = "vsplit" },
				adapters = {
					require("neotest-go"),
				},
			})
			vim.keymap.set("n", "<leader>tf", function()
				neotest.run.run(vim.fn.expand("%:h"))
			end)
			vim.keymap.set("n", "<leader>lt", function()
				neotest.run.run_last()
			end)
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true })
			end)
			vim.keymap.set("n", "<leader>tO", function()
				neotest.output_panel.toggle()
			end)
			vim.keymap.set("n", "<leader>tt", function()
				neotest.run.run()
			end)
			vim.keymap.set("n", "<leader>dt", function()
				neotest.run.run({ strategy = "dap" })
			end)
			vim.keymap.set("n", "<leader>dt", function()
				neotest.run.run(vim.fn.getcwd())
			end)

			vim.keymap.set("n", "t<CR>", neotest.run.run)
			vim.keymap.set("n", "[t", function()
				neotest.jump.prev({ status = "failed" })
			end)
			vim.keymap.set("n", "]t", function()
				neotest.jump.next({ status = "failed" })
			end)

			-- vim.keymap.set("n", "<leader>tf", ":lua neotest.run.run(vim.fn.expand('%'))<CR>")
		end,
	},
}
