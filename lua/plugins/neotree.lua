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
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(arg)
                        vim.cmd([[setlocal relativenumber]])
                    end,
                },
            },
            filesystem = {
                follow_current_file = {
                    enabled = true,
                },
                filtered_items = {
                    visible = true,
                },
            },
            window = {
                mappings = {
                    ["<leader>S"] = "open_split",
                    ["<leader>s"] = "open_vsplit",
                    ["/"] = "noop"
                },
                auto_expand_width = true,
            },
            default_component_configs = {
                git_status = {
                    symbols = {
                        added = "✚",
                        deleted = "✖",
                        modified = "",
                        renamed = "󰁕",
                        untracked = "",
                        ignored = "",
                        unstaged = "",
                        staged = "",
                        conflict = "",
                    },
                    align = "right",
                },
                file_size = {
                    enabled = false,
                    required_width = 64,
                },
                type = {
                    enabled = false,
                    required_width = 110,
                },
                last_modified = {
                    enabled = false,
                    required_width = 88,
                },
                created = {
                    enabled = false,
                    required_width = 120,
                },
                symlink_target = {
                    enabled = false,
                },
            },
        },
    },
}
