return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			cs = { "csharpier" },
			go = { "gofumpt", "goimports-reviser", "golines" }
		},
	},
	config = function()
		vim.keymap.set({ "n", "v" }, "<leader>fd", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end)
	end,
}
