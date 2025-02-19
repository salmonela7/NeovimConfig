return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			window = {
				mappings = {
					["<leader>S"] = "open_split",
					["<leader>s"] = "open_vsplit",
				},
			},
		},
	},
}
