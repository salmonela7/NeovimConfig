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
