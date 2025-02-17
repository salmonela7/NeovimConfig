return {
	{
		"VidocqH/lsp-lens.nvim",
		config = function()
			local SymbolKind = vim.lsp.protocol.SymbolKind

			require("lsp-lens").setup({
				enable = true,
				sections = {
					git_authors = false,
					definition = false,
					implements = false,
					references = function(count)
						return count .. " usages"
					end,
				},

				target_symbol_kinds = {
					SymbolKind.Function,
					SymbolKind.Method,
					SymbolKind.Interface,
					SymbolKind.Class,
					SymbolKind.Struct,
				},
			})
		end,
	},
}
