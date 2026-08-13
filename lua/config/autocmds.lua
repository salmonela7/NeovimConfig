vim.api.nvim_create_user_command("DiffOrig", "vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis", {})

local diff_orig_buf = nil
vim.keymap.set("n", "<leader>do", function()
	if diff_orig_buf and vim.api.nvim_buf_is_valid(diff_orig_buf) then
		vim.api.nvim_buf_delete(diff_orig_buf, { force = true })
		vim.cmd("diffoff")
		diff_orig_buf = nil
	else
		vim.cmd("DiffOrig")
		vim.cmd("wincmd p")
		diff_orig_buf = vim.api.nvim_get_current_buf()
		vim.cmd("wincmd p")
	end
end, { desc = "Toggle DiffOrig" })

local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
        vim.lsp.buf.format({ async = false })
    end,
})

local augroup = vim.api.nvim_create_augroup
local SalmonelaGroup = augroup("Salmonela", {})

-- Center the view after direct LSP jumps (single-result telescope jumps go through here)
local lsp_show_document = vim.lsp.util.show_document
vim.lsp.util.show_document = function(location, offset_encoding, opts)
    local ok = lsp_show_document(location, offset_encoding, opts)
    if ok and (not opts or opts.focus ~= false) then
        vim.cmd("normal! zz")
    end
    return ok
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.enable(true, { bufnr = args.buf })
        end
    end,
})

autocmd("LspAttach", {
    group = SalmonelaGroup,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
        vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, {})

        vim.keymap.set("n", "<leader>gd", require("telescope.builtin").lsp_definitions, {})
        vim.keymap.set("n", "<leader>gu", require("telescope.builtin").lsp_references, {})
        vim.keymap.set("n", "<leader>gi", require("telescope.builtin").lsp_implementations, {})

        vim.keymap.set("n", "gsd", function()
            require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
        end, {})
        vim.keymap.set("n", "gsu", function()
            require("telescope.builtin").lsp_references({ jump_type = "vsplit" })
        end, {})
        vim.keymap.set("n", "gsi", function()
            require("telescope.builtin").lsp_implementations({ jump_type = "vsplit" })
        end, {})

        vim.keymap.set("n", "<leader>gci", require("telescope.builtin").lsp_incoming_calls, {})
        vim.keymap.set("n", "<leader>gco", require("telescope.builtin").lsp_outgoing_calls, {})

        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
        end, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        vim.keymap.set({ "n", "v", "i" }, "<MiddleMouse>", function()
            local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true)
            vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
            vim.schedule(function()
                require("telescope.builtin").lsp_definitions(lsp_picker_opts())
            end)
        end, {})
    end,
})
