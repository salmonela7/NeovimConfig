vim.keymap.set("t", "kj", "<c-\\><c-n>")

local terminalState = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local commandExTerminalState = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if opts.buf ~= nil and vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "rounded",
	}

	-- Create the floating window
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local function resume_or_create_terminal()
	terminalState.floating = create_floating_window({ buf = terminalState.floating.buf })
	if vim.bo[terminalState.floating.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end
end

local function create_new_terminal(args)
	commandExTerminalState.floating = create_floating_window({})
	if vim.bo[commandExTerminalState.floating.buf].buftype ~= "terminal" then
		vim.cmd("terminal " .. args["args"])
	end
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(terminalState.floating.win) then
		resume_or_create_terminal()
	else
		vim.api.nvim_win_hide(terminalState.floating.win)
	end
end

local execute_in_terminal = function(opts)
	if not vim.api.nvim_win_is_valid(commandExTerminalState.floating.win) then
		create_new_terminal(opts)
	else
		vim.api.nvim_win_hide(commandExTerminalState.floating.win)
	end
end

-- Example usage:
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, { desc = "Opens floating terminal" })
vim.api.nvim_create_user_command(
	"Floatexecute",
	execute_in_terminal,
	{ desc = "Executes a command in floating terminal", nargs = "*" }
)
