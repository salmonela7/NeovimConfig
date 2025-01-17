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
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = "^1.0.0",
            },
        },
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = {
                        find_command = {
                            "fd",
                            "--type",
                            "f",
                            "--no-ignore-vcs",
                            "--color=never",
                            "--hidden",
                            "--follow",
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("v", "<C-p>", builtin.find_files, {})

            vim.keymap.set(
                "n",
                "<leader>fg",
                ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
                {}
            )
            vim.keymap.set(
                "v",
                "<leader>fg",
                ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
                {}
            )
            vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
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
                            ["<leader>s"] = actions.file_vsplit,
                            ["<leader>S"] = actions.file_split,
                            ["<esc>"] = actions.close,
                            ["<C-p>"] = actions.close,
                        },
                        n = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<leader>s"] = actions.file_vsplit,
                            ["<leader>S"] = actions.file_split,
                            ["<esc>"] = actions.close,
                            ["<C-p>"] = actions.close,
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
