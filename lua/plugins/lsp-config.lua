return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "csharp_ls", "gopls", "jsonls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local on_attach = function(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			end

			util = require("lspconfig/util")

			local bin_path = os.getenv("USERPROFILE") .. "/AppData/Local/nvim-data/mason/bin/"

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. "lua-language-server.cmd" },
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { bin_path .. "gopls.cmd" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			lspconfig.csharp_ls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. "csharp-ls.cmd" },
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. "vscode-json-language-server.cmd" },
			})

			local telescope_ignore_patterns = {
				"%_test.go",
			}

			vim.keymap.set("n", "<leader>ti", function()
				vim.g.telescope_ignore_enabled = not vim.g.telescope_ignore_enabled

				require("telescope.config").set_defaults({
					file_ignore_patterns = vim.g.telescope_ignore_enabled and telescope_ignore_patterns or {},
				})
			end, { noremap = true, desc = "Toggle telescope ignore patterns" })

			vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
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
	},
}
