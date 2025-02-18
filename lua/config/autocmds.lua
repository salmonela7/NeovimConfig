local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd({ "FocusLost" }, {
	command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	command = "silent! wa",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "CursorHold" }, {
	callback = function()
		vim.lsp.codelens.refresh({ bufnr = 0 })
	end,
	group = vim.api.nvim_create_augroup("lspAutoCmd", { clear = true }),
})

local augroup = vim.api.nvim_create_augroup
local SalmonelaGroup = augroup("Salmonela", {})

local function goToDefinitionAndCenterHandler(err, result, ctx, config)
	local handler = require("vim.lsp.handlers")["textDocument/definition"]

	if err ~= nil then
		print("Error occurred on " .. ctx.method .. "...")
		return
	end

	if result == nil then
		print(ctx.method .. " yielded no results...")
		return
	end

	local res, error = handler(err, result, ctx, config)

	local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("zz", true, true, true)
	vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)

	return res, error
end

local function goToReferencesAndCenterHandler(err, result, ctx, config)
	local handler = require("vim.lsp.handlers")["textDocument/references"]
	if err ~= nil then
		print("Error occurred on " .. ctx.method .. "...")
		return
	end

	if result == nil then
		print(ctx.method .. " yielded no results...")
		return
	end

	local res, error = handler(err, result, ctx, config)

	if #result == 1 then
		local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("zz", true, true, true)
		vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
	end

	return res, error
end

local function goToImplementationsAndCenterHandler(err, result, ctx, config)
	local handler = require("vim.lsp.handlers")["textDocument/implementation"]
	if err ~= nil then
		print("Error occurred on " .. ctx.method .. "...")
		return
	end

	if result == nil then
		print(ctx.method .. " yielded no results...")
		return
	end

	local res, error = handler(err, result, ctx, config)

	if #result == 1 then
		local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("zz", true, true, true)
		vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
	end

	return res, error
end

autocmd("LspAttach", {
	group = SalmonelaGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, {})
		vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, {})

		-- vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
		vim.keymap.set("n", "<leader>gd", function()
			local util = require("vim.lsp.util")
			local params = util.make_position_params()

			vim.lsp.buf_request(0, "textDocument/definition", params, goToDefinitionAndCenterHandler)
		end, {})

		vim.keymap.set("n", "<leader>gu", function()
			local util = require("vim.lsp.util")
			local params = util.make_position_params()
			params.context = { includeDeclaration = false }

			vim.lsp.buf_request(0, "textDocument/references", params, goToReferencesAndCenterHandler)
		end, {})

		vim.keymap.set("n", "<leader>gi", function()
			local util = require("vim.lsp.util")
			local params = util.make_position_params()

			vim.lsp.buf_request(0, "textDocument/implementation", params, goToImplementationsAndCenterHandler)
		end, {})

		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_next()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_prev()
		end, opts)

		vim.keymap.set({ "n", "v", "i" }, "<C-LeftMouse>", function()
			local keymap_with_termcodes_replaced = vim.api.nvim_replace_termcodes("<LeftMouse>", true, true, true)
			vim.api.nvim_feedkeys(keymap_with_termcodes_replaced, "a", true)
			vim.schedule(function()
				vim.lsp.buf.definition()
			end)
		end, {})
	end,
})
