local ensure_installed = {
	"lua",
	"go",
	"html",
	"http",
	"c_sharp",
	"rust",
	"markdown",
	"markdown_inline",
}

return {
	{
		"neovim-treesitter/nvim-treesitter",
		dependencies = { "neovim-treesitter/treesitter-parser-registry" },
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(ensure_installed)

			-- The main branch no longer enables features itself; start
			-- highlighting and indentation for any buffer with a parser.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter-features", {}),
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						-- Only use treesitter indentation when the language has an
						-- indent query; otherwise keep the builtin indent script
						-- (e.g. c_sharp has no indents.scm in this fork).
						local lang = vim.treesitter.language.get_lang(ev.match)
						if lang and vim.treesitter.query.get(lang, "indents") then
							vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
						end
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				mode = "topline",
				max_lines = 3,
			})
		end,
	},
}
