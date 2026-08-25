-- Per-server configuration lives in ~/.config/nvim/lsp/<name>.lua,
-- merged automatically by vim.lsp.config.
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
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("intelephense")
            vim.lsp.enable("phpactor")
            vim.lsp.enable("jsonls")
            vim.lsp.enable("rust_analyzer")
        end,
    },
}
