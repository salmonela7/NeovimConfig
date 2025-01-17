vim.api.nvim_create_autocmd({ "FocusLost" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    command = "silent! wa",
})
