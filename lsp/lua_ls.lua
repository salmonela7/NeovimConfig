return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim", "it", "describe", "before_each", "after_each" },
            },
        },
    },
}
