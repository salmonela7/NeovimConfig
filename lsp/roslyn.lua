-- Roslyn diagnostics need two workarounds on top of Neovim's pull model:
--
-- 1. Neovim only re-pulls a buffer's diagnostics when that buffer itself
--    changes. Editing file A never refreshes file B, so cross-file errors
--    stay stale. After an edit settles, re-pull every other attached buffer
--    and re-request code lenses (reference counts) everywhere.
--
-- 2. Neovim's default workspace/diagnostic/refresh handler only runs a
--    workspace pull for servers that support it, and workspace results are
--    ignored for open buffers. Re-pull document diagnostics too, or open
--    buffers keep stale diagnostics until the next edit.

local cross_refresh_timer = assert(vim.uv.new_timer())
local function refresh_other_buffers(edited_buf)
    cross_refresh_timer:start(
        500,
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
            vim.lsp.codelens.on_refresh(nil, nil, { client_id = client.id })
        end)
    )
end

return {
    on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
            group = vim.api.nvim_create_augroup("roslyn_cross_refresh_" .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
                refresh_other_buffers(bufnr)
            end,
        })
    end,
    handlers = {
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
}
