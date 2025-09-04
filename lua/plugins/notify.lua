return {
	{
		"rcarriga/nvim-notify",
		config = function()
			local notify = require("notify")

			require("notify").setup({
				background_colour = "#000000",
			})

			vim.notify = notify
		end,
	},
}
