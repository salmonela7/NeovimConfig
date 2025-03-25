return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				lazy = false,
				ensure_installed = {
					"lua",
					"go",
					"html",
					"http",
					"c_sharp",
				},
				indent = { enable = true },

				highlight = {
					enable = true,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				mode = "topline",
			})
		end,
	},
}
