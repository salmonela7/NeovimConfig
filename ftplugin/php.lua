vim.keymap.set("n", "<leader>ti", function()
    vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

    require("telescope.config").set_defaults({
        file_ignore_patterns = vim.g.telescope_ignore_enabled and { "%Test.php", "%.worktrees/" } or { "%.worktrees/" },
    })
end, { noremap = true, desc = "Toggle telescope ignore patterns" })
