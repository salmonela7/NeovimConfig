return {
	{
		"tpope/vim-fugitive",
		config = function()
			local fugitive_win = nil
			local FOCUS_DELAY_MS = 50

			local function is_git_buffer(buf)
				if not vim.api.nvim_buf_is_valid(buf) then
					return false
				end
				local ft = vim.bo[buf].filetype
				return ft == "fugitive" or ft == "git"
			end

			local function return_to_fugitive()
				if fugitive_win and vim.api.nvim_win_is_valid(fugitive_win) then
					vim.api.nvim_set_current_win(fugitive_win)
				end
			end

			local function execute_fugitive_command(motion, command)
				if motion then
					vim.cmd("normal! " .. motion)
				end
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(command, true, false, true), "m", false)
				vim.defer_fn(return_to_fugitive, FOCUS_DELAY_MS)
			end

			local function has_fugitive_buffer()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if is_git_buffer(buf) then
						return true
					end
				end
				return false
			end

			local function close_fugitive_windows()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if is_git_buffer(vim.api.nvim_win_get_buf(win)) then
						vim.api.nvim_win_close(win, false)
					end
				end
				vim.cmd("diffoff!")
			end

			local function close_fugitive_with_cleanup()
				vim.api.nvim_set_current_win(fugitive_win)

				vim.cmd("windo diffoff")

				vim.defer_fn(function()
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w><C-o>", true, false, true), "m", false)
				end, FOCUS_DELAY_MS)

				vim.defer_fn(function()
					if vim.api.nvim_win_is_valid(fugitive_win) then
						vim.api.nvim_win_close(fugitive_win, false)
					end
				end, 500)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "fugitive",
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "dn", function()
						execute_fugitive_command("j", "dv")
					end, vim.tbl_extend("force", opts, { desc = "Fugitive: diff next" }))

					vim.keymap.set("n", "dp", function()
						execute_fugitive_command("k", "dv")
					end, vim.tbl_extend("force", opts, { desc = "Fugitive: diff previous" }))
				end,
			})

			vim.keymap.set("n", "<leader>gg", function()
				if has_fugitive_buffer() then
					if fugitive_win and vim.api.nvim_win_is_valid(fugitive_win) then
						close_fugitive_with_cleanup()
					else
						close_fugitive_windows()
					end
				else
					local width = math.floor(vim.o.columns * 0.15)
					vim.cmd("topleft vertical Git")
					vim.cmd("vertical resize " .. width)

					fugitive_win = vim.api.nvim_get_current_win()
				end
			end, { desc = "Toggle git status" })

			vim.keymap.set("n", "<leader>gb", return_to_fugitive, { desc = "Return to git status" })
			vim.keymap.set("n", "<leader>nb", ":G stash | G checkout master | G pull | G checkout -b ")
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
