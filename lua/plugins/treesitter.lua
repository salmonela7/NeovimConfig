return {
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

			-- highlight = {
			--     enable = true,
			--     additional_vim_regex_highlighting = { "http" },
			--     disable = function(_, buf)
			--         local max_filesize = 100 * 1024 -- 100 kb
			--         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			--         if ok and stats and stats.size > max_filesize then
			--             return true
			--         end
			--     end,
			-- },
		})
	end,
}
