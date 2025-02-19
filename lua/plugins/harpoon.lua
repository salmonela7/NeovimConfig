return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<A-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<A-1>", ":lua require('harpoon'):list():select(1)<CR>zz")
			vim.keymap.set("n", "<A-2>", ":lua require('harpoon'):list():select(2)<CR>zz")
			vim.keymap.set("n", "<A-3>", ":lua require('harpoon'):list():select(3)<CR>zz")
			vim.keymap.set("n", "<A-4>", ":lua require('harpoon'):list():select(4)<CR>zz")
			vim.keymap.set("n", "<A-5>", ":lua require('harpoon'):list():select(5)<CR>zz")

			vim.keymap.set("n", "<A-u>", ":lua require('harpoon'):list():prev<CR>zz")
			vim.keymap.set("n", "<A-i>", ":lua require('harpoon'):list():next<CR>zz")
		end,
	},
}
