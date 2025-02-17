vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.g.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.statuscolumn = "%s %l %r"
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff = 10
vim.opt.incsearch = true
vim.opt.shell = "powershell /nologo"

vim.cmd("colorscheme gruvbox-material")
vim.cmd('set shada="NONE"')
