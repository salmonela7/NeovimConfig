vim.keymap.set("n", "<leader>at", function()
    vim.cmd("silent! wa")
    vim.cmd("Floatexecute dotnet test")
end)

vim.keymap.set("n", "<F4>", function()
    vim.cmd("silent! wa")
    vim.cmd("Floatexecute dotnet build")
end)

vim.keymap.set("n", "<leader>ti", function()
    vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

    require("telescope.config").set_defaults({
        file_ignore_patterns = vim.g.telescope_ignore_enabled and { "%_Should.cs", "%.worktrees/" } or { "%.worktrees/" },
    })
end, { noremap = true, desc = "Toggle telescope ignore patterns" })
