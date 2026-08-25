return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
}
