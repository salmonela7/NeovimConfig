return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gg", function()
				vim.cmd("topleft vertical Git")
				vim.defer_fn(function()
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local max_len = 0

					for _, line in ipairs(lines) do
						max_len = math.max(max_len, vim.fn.strdisplaywidth(line))
					end

					local width = math.min(math.max(max_len + 4, 40), 80)
					vim.cmd("vertical resize " .. width)
				end, 50)
			end, { desc = "Git status (vertical)" })
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
			vim.keymap.set("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>")
		end,
	},
}
