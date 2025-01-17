return {
    {
        "tpope/vim-fugitive",
    },
    {
        "sindrets/diffview.nvim",
        config = function()
        end
    },
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>")
		end,
	},
}
