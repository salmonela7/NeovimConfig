return {
	{
		"ramojus/mellifluous.nvim",
		config = function()
			require("mellifluous").setup({
				styles = { -- see :h attr-list for options. set {} for NONE, { option = true } for option
					main_keywords = { bold = true },
				},
			})
		end,
	},
}
