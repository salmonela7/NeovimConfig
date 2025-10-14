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
vim.opt.scrolloff = 10
-- vim.opt.scrolloff = 999
vim.opt.incsearch = true
vim.opt.splitright = true
vim.o.autoread = true

if utils.IS_WINDOWS then
    vim.opt.shell = "powershell /nologo"
    vim.opt.shellcmdflag = "-command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

vim.cmd("colorscheme gruvbox-material")

-- Apply immediately for first load
vim.cmd([[highlight DiagnosticError guifg=#ea6962]])
vim.cmd([[highlight DiagnosticWarn guifg=#d8a657]])
vim.cmd([[highlight DiagnosticInfo guifg=#7daea3]])
vim.cmd([[highlight DiagnosticHint guifg=#a9b665]])
vim.cmd([[highlight DiagnosticOk guifg=#10fa07]])

vim.cmd([[highlight DiagnosticUnderlineError gui=undercurl guifg=#ea6962]])
vim.cmd([[highlight DiagnosticUnderlineWarn gui=undercurl guisp=#d8a657]])
vim.cmd([[highlight DiagnosticUnderlineInfo gui=undercurl guisp=#7daea3]])
vim.cmd([[highlight DiagnosticUnderlineHint gui=undercurl guisp=#a9b665]])
vim.cmd([[highlight DiagnosticUnderlineOk gui=undercurl guisp=#10fa07]])

-- Line number color
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#51B3EC", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#FB508F", bold = true })

-- vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = false } })
vim.diagnostic.config({
    -- virtual_text = true,
    virtual_lines = { current_line = true },
    underline = true,
    severity_sort = true,
    update_in_insert = false,
})

vim.cmd('set shada="NONE"')
