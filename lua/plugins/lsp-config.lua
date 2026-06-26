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

local function roslyn_handlers()
    return {
        ["workspace/projectInitializationComplete"] = function(_, _, ctx)
            vim.notify("Roslyn project initialization complete", vim.log.levels.INFO, { title = "roslyn_ls" })
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            refresh_diagnostics(client)
            return vim.NIL
        end,
        ["workspace/_roslyn_projectNeedsRestore"] = function(_, result, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))

            ---@diagnostic disable-next-line: param-type-mismatch
            client:request("workspace/_roslyn_restore", result, function(err, response)
                if err then
                    vim.notify(err.message, vim.log.levels.ERROR, { title = "roslyn_ls" })
                end
                if response then
                    for _, v in ipairs(response) do
                        vim.notify(v.message, vim.log.levels.INFO, { title = "roslyn_ls" })
                    end
                end
            end)

            return vim.NIL
        end,
        ["razor/provideDynamicFileInfo"] = function(_, _, _)
            vim.notify(
                "Razor is not supported.\nPlease use https://github.com/tris203/rzls.nvim",
                vim.log.levels.WARN,
                { title = "roslyn_ls" }
            )
            return vim.NIL
        end,
    }
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
            handlers = roslyn_handlers(),
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
            })

            vim.lsp.config("gopls", {
                capabilities = capabilities,
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

            vim.lsp.config("intelephense", {
                capabilities = capabilities,
            })

            vim.lsp.config("phpactor", {
                capabilities = capabilities,
                init_options = {
                    ["language_server_phpstan.enabled"] = false,
                    ["language_server_psalm.enabled"] = false,
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    if not client then
                        return
                    end

                    if client.name == "intelephense" then
                        client.server_capabilities.implementationProvider = false
                    end

                    if client.name == "phpactor" then
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

                        client.server_capabilities.implementationProvider = true
                        client.server_capabilities.codeActionProvider = true
                        client.server_capabilities.codeLensProvider = true
                        client.server_capabilities.typeDefinitionProvider = true
                        client.server_capabilities.renameProvider = true
                    end
                end,
            })

            vim.lsp.config("jsonls", {
                capabilities = capabilities,
            })

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
            })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("intelephense")
            vim.lsp.enable("phpactor")
            vim.lsp.enable("jsonls")
            vim.lsp.enable("rust_analyzer")
        end,
    },
}
