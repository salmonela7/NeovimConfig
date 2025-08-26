local M = {}
local OS = vim.loop.os_uname().sysname

M.IS_LINUX = OS == 'Linux'
M.IS_MAC = vim.fn.has('macunix')
M.IS_WINDOWS = OS:find 'Windows' and true or false

return M
