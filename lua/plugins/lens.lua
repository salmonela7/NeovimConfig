return {
    -- {
    --     "VidocqH/lsp-lens.nvim",
    --     config = function()
    --         local SymbolKind = vim.lsp.protocol.SymbolKind

    --         require("lsp-lens").setup({
    --             enable = true,
    --             sections = {
    --                 git_authors = false,
    --                 definition = false,
    --                 implements = false,
    --                 references = function(count)
    --                     return count .. " usages"
    --                 end,
    --             },

    --             target_symbol_kinds = {
    --                 SymbolKind.Function,
    --                 SymbolKind.Method,
    --                 SymbolKind.Interface,
    --                 SymbolKind.Class,
    --                 SymbolKind.Struct,
    --                 -- SymbolKind.Property,
    --                 -- SymbolKind.Field,
    --                 SymbolKind.Enum,
    --                 SymbolKind.EnumMember,
    --                 SymbolKind.Constructor,
    --                 SymbolKind.Constant,
    --             },
    --         })
    --     end,
    -- },
    -- {
    --     "Wansmer/symbol-usage.nvim",
    --     event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
    --     config = function()
    --         local SymbolKind = vim.lsp.protocol.SymbolKind

    --         require("symbol-usage").setup({
    --             kinds = {
    --                 SymbolKind.Function,
    --                 SymbolKind.Method,
    --                 SymbolKind.Interface,
    --                 SymbolKind.Class,
    --                 SymbolKind.Struct,
    --                 SymbolKind.Property,
    --                 SymbolKind.Field,
    --                 SymbolKind.Enum,
    --                 SymbolKind.EnumMember,
    --                 SymbolKind.Constructor,
    --                 SymbolKind.Constant,
    --             },
    --             references = { enabled = true, include_declaration = false },
    --         })
    --     end,
    -- },

}
