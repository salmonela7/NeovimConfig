return {
	{
	    "folke/trouble.nvim",
	    config = function()
	        require("trouble").setup({})

	        vim.keymap.set("n", "<leader>tw", "<cmd>Trouble diagnostics toggle<cr>")

	        vim.keymap.set("n", "[x", function()
	            require("trouble").next({ skip_groups = true, jump = true })
	        end)

	        vim.keymap.set("n", "]x", function()
	            require("trouble").previous({ skip_groups = true, jump = true })
	        end)
	    end,
	},
}
