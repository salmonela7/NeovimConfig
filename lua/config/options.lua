local utils = require("config.utils")
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.g.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.o.statuscolumn = "%s %l %r"
vim.opt.nu = true
vim.opt.rnu = true
-- vim.opt.scrolloff = 10
vim.opt.scrolloff = 999
vim.opt.incsearch = true

if utils.IS_WINDOWS then
	vim.opt.shell = "powershell /nologo"
	vim.opt.shellcmdflag = "-command"
	vim.opt.shellquote = ""
	vim.opt.shellxquote = ""
end

vim.cmd("colorscheme gruvbox-material")

vim.cmd([[highlight DiagnosticVirtualTextError guifg=#ea6962]])
vim.cmd([[highlight DiagnosticVirtualTextWarn guifg=#d8a657]])
vim.cmd([[highlight DiagnosticVirtualTextInfo guifg=#7daea3]])
vim.cmd([[highlight DiagnosticVirtualTextHint guifg=#a9b665]])

vim.cmd('set shada="NONE"')
