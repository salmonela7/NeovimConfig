vim.keymap.set("n", "<leader>at", function()
	vim.cmd("silent! wa")
	vim.cmd("Floatexecute dotnet test")
end)
