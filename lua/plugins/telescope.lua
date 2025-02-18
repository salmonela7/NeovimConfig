return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {

            {
                "nvim-lua/plenary.nvim",
            },
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                version = "^1.0.0",
            },
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set(
                "n",
                "<C-p>",
                "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '--no-ignore-vcs' }})<cr>",
                {}
            )
            vim.keymap.set(
                "v",
                "<C-p>",
                "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git', '--no-ignore-vcs' }})<cr>",
                {}
            )

            function vim.getVisualSelection()
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

            local telescope_ignore_patterns = {
                "%_test.go",
            }

            vim.keymap.set("n", "<leader>ti", function()
                vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

                require("telescope.config").set_defaults({
                    file_ignore_patterns = vim.g.telescope_ignore_enabled and telescope_ignore_patterns or {},
                })
            end, { noremap = true, desc = "Toggle telescope ignore patterns" })

            vim.keymap.set("v", "<leader>ff", function()
                local text = vim.getVisualSelection()
                require("telescope").extensions.live_grep_args.live_grep_args({ default_text = text })
            end, {})

            vim.keymap.set("n", "<leader>ff", function()
                require("telescope").extensions.live_grep_args.live_grep_args()
            end, {})
            vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
            vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>fs", builtin.lsp_dynamic_workspace_symbols, {})

            require("telescope").load_extension("ui-select")
            require("telescope").load_extension("live_grep_args")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")

            telescope.load_extension("lsp_handlers")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<leader>s"] = actions.file_vsplit + actions.center,
                            ["<leader>S"] = actions.file_split + actions.center,
                            ["<esc>"] = actions.close,
                            ["<C-p>"] = actions.close,
                            ["<CR>"] = actions.select_default + actions.center,
                        },
                        n = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<leader>s"] = actions.file_vsplit + actions.center,
                            ["<leader>S"] = actions.file_split + actions.center,
                            ["<esc>"] = actions.close,
                            ["<C-p>"] = actions.close,
                            ["<CR>"] = actions.select_default + actions.center,
                        },
                    },
                },
                extensions = {
                    lsp_handlers = {
                        implementation = {
                            telescope = require("telescope.themes").get_dropdown({}),
                        },
                        definition = {
                            telescope = require("telescope.themes").get_dropdown({}),
                        },
                        typeDefinition = {
                            telescope = require("telescope.themes").get_dropdown({}),
                        },
                        references = {
                            telescope = require("telescope.themes").get_dropdown({}),
                        },
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })

            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "gbrlsnchs/telescope-lsp-handlers.nvim",
        config = function() end,
    },
}
