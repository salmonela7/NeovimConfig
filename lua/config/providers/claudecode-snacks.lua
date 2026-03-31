--- Custom snacks terminal provider for claudecode.nvim.
--- Same as upstream but never enters insert mode automatically (coder/claudecode.nvim#145).

local M = {}

local terminal = nil

local function get_snacks()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks and snacks.terminal then
    return snacks
  end
  return nil
end

local function is_available()
  return get_snacks() ~= nil
end

local function normalize_focus(focus)
  if focus == nil then
    return true
  end
  return focus
end

local function setup_terminal_events(term_instance, config)
  local logger = require("claudecode.logger")

  if config.auto_close then
    term_instance:on("TermClose", function()
      if vim.v.event.status ~= 0 then
        logger.error("terminal", "Claude exited with code " .. vim.v.event.status .. ".\nCheck for any errors.")
      end
      terminal = nil
      vim.schedule(function()
        term_instance:close({ buf = true })
        vim.cmd.checktime()
      end)
    end, { buf = true })
  end

  term_instance:on("BufWipeout", function()
    logger.debug("terminal", "Terminal buffer wiped")
    terminal = nil
  end, { buf = true })
end

local function build_opts(config, env_table)
  return {
    env = env_table,
    cwd = config.cwd,
    start_insert = false,
    auto_insert = false,
    auto_close = false,
    win = vim.tbl_deep_extend("force", {
      position = config.split_side,
      width = config.split_width_percentage,
      height = 0,
      relative = "editor",
      keys = {
        claude_new_line = {
          "<S-CR>",
          function()
            vim.api.nvim_feedkeys("\\", "t", true)
            vim.defer_fn(function()
              vim.api.nvim_feedkeys("\r", "t", true)
            end, 10)
          end,
          mode = "t",
          desc = "New line",
        },
      },
    }, config.snacks_win_opts or {}),
  }
end

function M.setup() end

function M.open(cmd_string, env_table, config, focus)
  if not is_available() then
    vim.notify("Snacks.nvim terminal provider selected but Snacks.terminal not available.", vim.log.levels.ERROR)
    return
  end

  focus = normalize_focus(focus)

  if terminal and terminal:buf_valid() then
    if not terminal.win or not vim.api.nvim_win_is_valid(terminal.win) then
      terminal:toggle()
      if focus then
        terminal:focus()
      end
    else
      if focus then
        terminal:focus()
      end
    end
    return
  end

  local opts = build_opts(config, env_table)
  local term_instance = get_snacks().terminal.open(cmd_string, opts)
  if term_instance and term_instance:buf_valid() then
    setup_terminal_events(term_instance, config)
    terminal = term_instance
  else
    terminal = nil
    vim.notify("Failed to open Claude terminal using Snacks.", vim.log.levels.ERROR)
  end
end

function M.close()
  if not is_available() then
    return
  end
  if terminal and terminal:buf_valid() then
    terminal:close()
  end
end

function M.simple_toggle(cmd_string, env_table, config)
  if not is_available() then
    vim.notify("Snacks.nvim terminal provider selected but Snacks.terminal not available.", vim.log.levels.ERROR)
    return
  end

  if terminal and terminal:buf_valid() and terminal:win_valid() then
    terminal:toggle()
  elseif terminal and terminal:buf_valid() and not terminal:win_valid() then
    terminal:toggle()
  else
    M.open(cmd_string, env_table, config)
  end
end

function M.focus_toggle(cmd_string, env_table, config)
  if not is_available() then
    vim.notify("Snacks.nvim terminal provider selected but Snacks.terminal not available.", vim.log.levels.ERROR)
    return
  end

  if terminal and terminal:buf_valid() and not terminal:win_valid() then
    terminal:toggle()
  elseif terminal and terminal:buf_valid() and terminal:win_valid() then
    local claude_win = terminal.win
    if claude_win == vim.api.nvim_get_current_win() then
      terminal:toggle()
    else
      vim.api.nvim_set_current_win(claude_win)
    end
  else
    M.open(cmd_string, env_table, config)
  end
end

function M.toggle(cmd_string, env_table, config)
  M.simple_toggle(cmd_string, env_table, config)
end

function M.get_active_bufnr()
  if terminal and terminal:buf_valid() and terminal.buf then
    if vim.api.nvim_buf_is_valid(terminal.buf) then
      return terminal.buf
    end
  end
  return nil
end

function M.is_available()
  return is_available()
end

function M._get_terminal_for_test()
  return terminal
end

return M
