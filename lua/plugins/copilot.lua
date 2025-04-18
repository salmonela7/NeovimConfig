return {
	{
		"github/copilot.vim",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		opts = {},
		config = function()
			require("CopilotChat").setup({
				mappings = {
					reset = {
						normal = "<C-r>",
						insert = "<C-r>",
					},
				},
			})
				vim.keymap.set("n", "<leader>co", function()
					require("CopilotChat").toggle()
				end, { desc = "Open Copilot Chat" })
		end,
	},
}
