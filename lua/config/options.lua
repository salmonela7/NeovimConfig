local utils = require("config.utils")

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.background = "dark"
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff = 10
vim.opt.incsearch = true
vim.opt.splitright = true
vim.o.autoread = true

if utils.IS_WINDOWS then
    vim.opt.shell = "powershell /nologo"
    vim.opt.shellcmdflag = "-command"
    vim.opt.shellquote = ""
    vim.opt.shellxquote = ""
end

-- vim.cmd("colorscheme gruvbox-material")
vim.cmd("colorscheme moonfly")

vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#ea6962" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#d8a657" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#7daea3" })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#a9b665" })
vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#10fa07" })

vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#bf0b02" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#d8a657" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#7daea3" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#a9b665" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { fg = "#10fa07" })

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, fg = "#ea6962" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = "#d8a657" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = "#7daea3" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = "#a9b665" })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineOk", { undercurl = true, sp = "#10fa07" })

vim.api.nvim_set_hl(0, "Visual", { fg = "#282828", bg = "#FF77FF" })

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#51B3EC", bold = true })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#FB508F", bold = true })

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    severity_sort = true,
    update_in_insert = true,
})

vim.cmd('set shada="NONE"')
