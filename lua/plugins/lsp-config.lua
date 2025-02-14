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

            local on_attach = function(_, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end

            local util = require("lspconfig/util")

            local bin_path = os.getenv("USERPROFILE") .. "/AppData/Local/nvim-data/mason/bin/"

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                cmd = { bin_path .. "lua-language-server.cmd" },
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
                cmd = { bin_path .. "gopls.cmd" },
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
            lspconfig.csharp_ls.setup({
                capabilities = capabilities,
                cmd = { bin_path .. "csharp-ls.cmd" },
            })
            lspconfig.jsonls.setup({
                capabilities = capabilities,
                cmd = { bin_path .. "vscode-json-language-server.cmd" },
            })
        end,
    },
}
