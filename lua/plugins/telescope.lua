return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "v0.2.1",
		dependencies = {

			{
				"nvim-lua/plenary.nvim",
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
			},
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
		},
		config = function()
			local actions = require("telescope.actions")
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			local function getVisualSelection()
				vim.cmd('noau normal! "vy"')
				local text = vim.fn.getreg("v")
				vim.fn.setreg("v", {})

				text = string.gsub(text, "\n", "")
				if #text > 0 then
					return text
				else
					return ""
				end
			end

			-- Auto-select when single result, otherwise open picker in insert mode
			local function auto_select_single(picker)
				picker:clear_completion_callbacks()
				if picker.manager.linked_states.size == 1 then
					require("telescope.actions").select_default(picker.prompt_bufnr)
				else
					local keymap_with_termcodes_replaced =
						vim.api.nvim_replace_termcodes("i", true, true, true)
					vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
				end
			end

			telescope.setup({
				defaults = {
					layout_config = { width = 0.95 },
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<leader>s"] = actions.file_vsplit + actions.center,
							["<leader>S"] = actions.file_split + actions.center,
							["<esc>"] = actions.close,
							["kj"] = actions.close,
							["<C-p>"] = actions.close,
							["<CR>"] = actions.select_default + actions.center,
							["<ScrollWheelUp>"] = actions.move_selection_previous,
							["<ScrollWheelDown>"] = actions.move_selection_next,
						},
						n = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<leader>s"] = actions.file_vsplit + actions.center,
							["<leader>S"] = actions.file_split + actions.center,
							["<esc>"] = actions.close,
							["<C-p>"] = actions.close,
							["<CR>"] = actions.select_default + actions.center,
							["<ScrollWheelUp>"] = actions.move_selection_previous,
							["<ScrollWheelDown>"] = actions.move_selection_next,
						},
					},
				},
				pickers = {
					lsp_definitions = {
						fname_width = 100,
						initial_mode = "normal",
						on_complete = { auto_select_single },
					},
					lsp_references = {
						fname_width = 100,
						include_declaration = false,
						initial_mode = "normal",
						on_complete = { auto_select_single },
					},
					lsp_implementations = {
						fname_width = 100,
						include_declaration = false,
						initial_mode = "normal",
						on_complete = { auto_select_single },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})

			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			vim.keymap.set("v", "<C-p>", builtin.find_files, {})

			vim.keymap.set("v", "<leader>ff", function()
				local text = getVisualSelection()
				telescope.extensions.live_grep_args.live_grep_args({ default_text = text })
			end, {})
			vim.keymap.set("n", "<leader>fif", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>FIF", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>ff", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, {})
			vim.keymap.set("n", "<leader>bu", function()
				builtin.buffers({ sort_lastused = true })
			end)

			telescope.load_extension("ui-select")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("find_template")
		end,
	},
}
