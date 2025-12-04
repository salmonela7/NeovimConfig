local group = vim.api.nvim_create_augroup("lspconfig.roslyn_ls", { clear = true })

---@param client vim.lsp.Client
local function refresh_diagnostics(client)
	for buf, _ in pairs(vim.lsp.get_client_by_id(client.id).attached_buffers) do
		if vim.api.nvim_buf_is_loaded(buf) then
			client:request(
				vim.lsp.protocol.Methods.textDocument_diagnostic,
				{ textDocument = vim.lsp.util.make_text_document_params(buf) },
                nil,
				buf
			)
		end
	end
end

return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				PATH = "prepend",
				ensure_installed = { "csharpier", "netcoredbg" },
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls" },
				automatic_enable = false,
			})
		end,
	},
	{
		"Decodetalkers/csharpls-extended-lsp.nvim",
	},
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			filewatching = "roslyn",
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local on_attach = function(_, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
			end

			local util = require("lspconfig/util")
			local osresolve = require("config.utils")

			local bin_path = ""
			if osresolve.IS_LINUX or osresolve.IS_MAC then
				bin_path = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/"
			else
				bin_path = os.getenv("USERPROFILE") .. "/AppData/Local/nvim-data/mason/bin/"
			end

			local function prepareCmds(name)
				if osresolve.IS_WINDOWS then
					return name .. ".cmd"
				else
					return name
				end
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				cmd = { bin_path .. prepareCmds("lua-language-server") },
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim", "it", "describe", "before_each", "after_each" },
						},
					},
				},
			})
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				cmd = { bin_path .. prepareCmds("gopls") },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = false,
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})
			vim.lsp.config("roslyn", {
				on_attach = function(client, bufnr)
					-- avoid duplicate autocmds for same buffer
					if vim.api.nvim_get_autocmds({ buffer = bufnr, group = group })[1] then
						return
					end

					vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
						group = group,
						buffer = bufnr,
						callback = function()
							refresh_diagnostics(client)
						end,
						desc = "roslyn_ls: refresh diagnostics",
					})
				end,
				capabilities = {
					-- HACK: Doesn't show any diagnostics if we do not set this to true
					textDocument = {
						diagnostic = {
							dynamicRegistration = true,
						},
					},
				},
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "fullSolution",
						dotnet_compiler_diagnostics_scope = "fullSolution",
					},
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|symbol_search"] = {
						dotnet_search_reference_assemblies = true,
					},
					["csharp|completion"] = {
						dotnet_show_name_completion_suggestions = true,
						dotnet_show_completion_items_from_unimported_namespaces = true,
						dotnet_provide_regex_completions = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
				},
			})
			lspconfig.intelephense.setup({
				capabilities = capabilities,
				cmd = { "intelephense", "--stdio" },
				filetypes = { "php" },
				root_dir = util.root_pattern("composer.json", ".git"),
			})
			lspconfig.phpactor.setup({
				capabilities = capabilities,
				cmd = { "phpactor", "language-server" },
				filetypes = { "php" },
				root_dir = util.root_pattern("composer.json", ".git"),
				init_options = {
					["language_server_phpstan.enabled"] = false,
					["language_server_psalm.enabled"] = false,
				},
				on_attach = function(client, bufnr)
					client.server_capabilities.hoverProvider = false
					client.server_capabilities.completionProvider = false
					client.server_capabilities.signatureHelpProvider = false
					client.server_capabilities.definitionProvider = false
					client.server_capabilities.referencesProvider = false
					client.server_capabilities.documentHighlightProvider = false
					client.server_capabilities.documentSymbolProvider = false
					client.server_capabilities.workspaceSymbolProvider = false
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
					client.server_capabilities.documentOnTypeFormattingProvider = false
					client.server_capabilities.documentLinkProvider = false
					client.server_capabilities.colorProvider = false
					client.server_capabilities.foldingRangeProvider = false
					client.server_capabilities.executeCommandProvider = false
					client.server_capabilities.semanticTokensProvider = false

					client.server_capabilities.codeActionProvider = true
					client.server_capabilities.codeLensProvider = true
					client.server_capabilities.typeDefinitionProvider = true
					client.server_capabilities.renameProvider = true
					client.server_capabilities.implementationProvider = true

					on_attach(client, bufnr)
				end,
			})
			lspconfig.jsonls.setup({
				capabilities = capabilities,
				-- cmd = { bin_path .. prepareCmds("vscode-json-language-server") },
			})
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				cmd = { bin_path .. prepareCmds("rust-analyzer") },
			})
		end,
	},
}
