-- Roslyn computes document diagnostics on request, and Neovim only re-pulls
-- a buffer when that buffer itself changes. Editing file A never refreshes
-- file B, so cross-file errors stay stale. After an edit settles, re-pull
-- every other attached C# buffer.
local roslyn_cross_refresh_timer = assert(vim.uv.new_timer())
local function roslyn_refresh_other_buffers(edited_buf)
    roslyn_cross_refresh_timer:start(
        2000,
        0,
        vim.schedule_wrap(function()
            local client = vim.lsp.get_clients({ name = "roslyn", bufnr = edited_buf })[1]
            if not client then
                return
            end
            for bufnr in pairs(client.attached_buffers) do
                if bufnr ~= edited_buf and vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.lsp.diagnostic._refresh(bufnr, client.id)
                end
            end
        end)
    )
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
                handlers = {
                    -- Neovim's default on_refresh only runs a workspace pull for
                    -- servers that support it, and workspace results are ignored
                    -- for open buffers. Re-pull document diagnostics too, or open
                    -- buffers keep stale diagnostics until the next edit.
                    ["workspace/diagnostic/refresh"] = function(err, result, ctx)
                        local client = vim.lsp.get_client_by_id(ctx.client_id)
                        if client then
                            for bufnr in pairs(client.attached_buffers) do
                                if vim.api.nvim_buf_is_loaded(bufnr) then
                                    vim.lsp.diagnostic._refresh(bufnr, ctx.client_id)
                                end
                            end
                        end
                        return vim.lsp.diagnostic.on_refresh(err, result, ctx)
                    end,
                },
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
                -- Large projects blow node's default heap and intelephense
                -- dies with OOM mid-session, taking gd with it
                cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" },
                -- nvim-lspconfig puts .git first, which roots the server at the
                -- repo root and pulls .worktrees/ into the index
                root_markers = { "composer.json", ".git" },
                settings = {
                    intelephense = {
                        files = {
                            -- defaults plus .worktrees; setting this replaces the
                            -- server's default exclude list
                            exclude = {
                                "**/.git/**",
                                "**/.svn/**",
                                "**/.hg/**",
                                "**/CVS/**",
                                "**/.DS_Store/**",
                                "**/node_modules/**",
                                "**/bower_components/**",
                                "**/vendor/**/{Tests,tests}/**",
                                "**/.history/**",
                                "**/vendor/**/vendor/**",
                                "**/.worktrees/**",
                            },
                        },
                    },
                },
            })

            vim.lsp.config("phpactor", {
                capabilities = capabilities,
                root_markers = { "composer.json", ".phpactor.json", ".phpactor.yml", ".git" },
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

                    if client.name == "roslyn" then
                        vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
                            group = vim.api.nvim_create_augroup("roslyn_cross_refresh_" .. ev.buf, { clear = true }),
                            buffer = ev.buf,
                            callback = function()
                                roslyn_refresh_other_buffers(ev.buf)
                            end,
                        })
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
