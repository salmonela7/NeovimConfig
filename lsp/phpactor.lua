-- phpactor runs alongside intelephense; disable everything intelephense
-- already provides and keep only what phpactor does better
return {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    root_markers = { "composer.json", ".phpactor.json", ".phpactor.yml", ".git" },
    init_options = {
        ["language_server_phpstan.enabled"] = false,
        ["language_server_psalm.enabled"] = false,
    },
    on_attach = function(client)
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
    end,
}
