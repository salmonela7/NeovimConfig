return {
	{
		"mistweaverco/kulala.nvim",
		opts = {},
		config = function()
			vim.keymap.set("n", "<leader>hs", ":e " .. os.getenv("USERPROFILE") .. "/scratchpad.http<CR>")
			vim.keymap.set("n", "<leader>hr", "<cmd>lua require('kulala').run()<cr>")
			vim.keymap.set("n", "<leader>ht", "<cmd>lua require('kulala').toggle_view()<cr>")
		end,
	},
}
