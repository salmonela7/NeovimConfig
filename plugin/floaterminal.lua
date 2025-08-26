vim.keymap.set("t", "kj", "<c-\\><c-n>")

local states = {
	["main"] = {
		floating = {
			buf = -1,
			win = -1,
		},
	},
	["commandExState"] = {
		floating = {
			buf = -1,
			win = -1,
		},
	},
}

local function mysplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t = {}

	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end

	return t
end

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.98)
	local height = opts.height or math.floor(vim.o.lines * 0.98)

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
	states["main"].floating = create_floating_window({ buf = states["main"].floating.buf })
	if vim.bo[states["main"].floating.buf].buftype ~= "terminal" then
		vim.cmd.terminal()
	end
end

local function resume_or_create_terminal_and_execute(opts, stateName, command)
	states[stateName].floating = create_floating_window({ buf = states[stateName].floating.buf })
	if vim.bo[states[stateName].floating.buf].buftype ~= "terminal" then
		vim.cmd("terminal " .. command)
	end
end

local function execute_in_new_terminal(opts)
	states["commandExState"].floating = create_floating_window({})
	if vim.bo[states["commandExState"].floating.buf].buftype ~= "terminal" then
		vim.cmd("terminal " .. opts["args"])
	end
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(states["main"].floating.win) then
		resume_or_create_terminal()
	else
		vim.api.nvim_win_hide(states["main"].floating.win)
	end
end

local execute_in_terminal = function(opts)
	if not vim.api.nvim_win_is_valid(states["commandExState"].floating.win) then
		execute_in_new_terminal(opts)
	else
		vim.api.nvim_win_hide(states["commandExState"].floating.win)
	end
end

local execute_in_terminal_save_state = function(opts)
	local argsTable = mysplit(opts.args)
	local stateName = argsTable[2]
	if states[stateName] == nil then
		states[stateName] = {
			floating = {
				buf = -1,
				win = -1,
			},
		}
	end
	if not vim.api.nvim_win_is_valid(states[stateName].floating.win) then
		resume_or_create_terminal_and_execute(opts, stateName, argsTable[1])
	else
		vim.api.nvim_win_hide(states[stateName].floating.win)
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
vim.api.nvim_create_user_command(
	"Floatexecutestate",
	execute_in_terminal_save_state,
	{ desc = "Executes a command in floating terminal and saves state", nargs = "*" }
)
