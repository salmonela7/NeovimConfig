return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    -- Large projects blow node's default heap and intelephense
    -- dies with OOM mid-session, taking gd with it
    cmd_env = { NODE_OPTIONS = "--max-old-space-size=8192" },
    -- nvim-lspconfig puts .git first, which roots the server at the
    -- repo root and pulls .worktrees/ into the index
    root_markers = { "composer.json", ".git" },
    on_attach = function(client)
        client.server_capabilities.implementationProvider = false
    end,
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
}
