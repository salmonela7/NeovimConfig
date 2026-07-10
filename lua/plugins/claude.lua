return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
        env = {
            -- Force the classic renderer so the conversation stays in terminal
            -- scrollback and is scrollable in normal mode.
            CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN = "1",
        },
        terminal = {
            provider = "snacks",
            auto_insert = false,
        },
    },
    keys = {
        { "<leader>cc", "<cmd>ClaudeCode<cr>",            mode = { "n", "i" },         desc = "Toggle Claude" },
        { "<leader>cc", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
        { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
        {
            "<leader>cf",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
    },
}
