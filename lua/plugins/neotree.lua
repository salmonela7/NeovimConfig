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
			filesystem = {
				follow_current_file = { enabled = true },
			},
			window = {
				mappings = {
					["<leader>S"] = "open_split",
					["<leader>s"] = "open_vsplit",
				},
			},
		},
	},
}
