return {
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("Lspformatting", {})
            -- local range_formatting = function()
            -- 	local start_row, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
            -- 	local end_row, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
            -- 	vim.lsp.buf.format({
            -- 		range = {
            -- 			["start"] = { start_row, 0 },
            -- 			["end"] = { end_row, 0 },
            -- 		},
            -- 		async = true,
            -- 	})
            -- end

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.goimports_reviser,
                    null_ls.builtins.formatting.golines,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({
                            group = augroup,
                            buffer = bufnr,
                        })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
            vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, {})
        end,
    },
}
