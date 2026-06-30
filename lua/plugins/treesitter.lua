return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				lazy = false,
				auto_install = true,
				ensure_installed = {
					"lua",
					"go",
					"html",
					"http",
					"c_sharp",
					"rust",
					"markdown",
					"markdown_inline",
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
				max_lines = 3,
			})
		end,
	},
}
