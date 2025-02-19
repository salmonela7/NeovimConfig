local function display_codelens()
	vim.lsp.codelens.refresh({ bufnr = 0 })
	vim.lsp.codelens.run()
	local codelenses = vim.lsp.codelens.get(0)
	print(vim.inspect(codelenses))
	vim.lsp.codelens.display(codelenses, 0, 1)
end

vim.api.nvim_create_user_command("Codelens", display_codelens, {})

vim.keymap.set("n", "<leader>cl", function()
	local util = require("vim.lsp.util")
	local params = util.make_position_params()

	vim.lsp.buf_request(0, "textDocument/codeLens", params, vim.lsp.codelens.on_codelens)

	local codelenses = vim.lsp.codelens.get(0)
	print(vim.inspect(codelenses))
end, {})
