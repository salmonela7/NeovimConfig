return {
	"rmagatti/auto-session",
	lazy = false,

	---enables autocomplete for opts
	---@module "auto-session"
	---@type AutoSession.Config
	opts = {
		suppressed_dirs = { "~/" },
		close_filetypes_on_save = { "checkhealth", "snacks_terminal" },
	},
}
