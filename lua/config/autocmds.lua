local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "FocusLost" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    command = "silent! wa",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
    callback = function()
        vim.lsp.codelens.refresh({ bufnr = 0 })
    end,
    group = vim.api.nvim_create_augroup("lspAutoCmd", { clear = true }),
})

local augroup = vim.api.nvim_create_augroup
local SalmonelaGroup = augroup("Salmonela", {})

autocmd("LspAttach", {
    group = SalmonelaGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, {})

        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        vim.keymap.set("n", "<leader>gu", function()
            vim.lsp.buf.references({ includeDeclaration = false })
        end, {})
        vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set("n", "[d", function()
            vim.diagnostic.goto_next()
        end, opts)
        vim.keymap.set("n", "]d", function()
            vim.diagnostic.goto_prev()
        end, opts)
        vim.keymap.set("n", "<leader>vws", function()
            vim.lsp.buf.workspace_symbol()
        end, opts)

        vim.keymap.set({ "n", "v", "i" }, "<C-LeftMouse>", function()
            local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true)
            vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
            vim.schedule(function()
                vim.lsp.buf.definition()
            end)
        end, {})
    end,
})
