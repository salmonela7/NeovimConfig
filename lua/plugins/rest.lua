return {
	{
		"rest-nvim/rest.nvim",
		config = function()
			vim.keymap.set("n", "<leader>hs", ":e " .. os.getenv("USERPROFILE") .. "/scratchpad.http<CR>")
			vim.keymap.set("n", "<leader>hr", "<cmd>Rest run<cr>")
		end,
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					table.insert(opts.ensure_installed, "http")
				end,
			},
			{
				"j-hui/fidget.nvim",
			},
		},
	},
}
