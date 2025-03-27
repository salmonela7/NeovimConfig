vim.keymap.set("n", "<leader>at", function()
	vim.cmd("silent! wa")
	vim.cmd("Floatexecute go test -p 1 ./...")
end)
