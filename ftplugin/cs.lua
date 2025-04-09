vim.keymap.set("n", "<leader>at", function()
	vim.cmd("silent! wa")
	vim.cmd("Floatexecute dotnet test")
end)

vim.keymap.set("n", "<F4>", function()
	vim.cmd("silent! wa")
	vim.cmd("Floatexecute dotnet build")
end)
