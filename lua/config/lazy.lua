-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

vim.g.background = "dark"
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 400
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.statuscolumn = "%s %l %r"
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.scrolloff = 10
vim.opt.incsearch = true

-- vim.keymap.set("n", "<C-n>", "<Cmd>Neotree focus<CR>")
vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>")

keymap = vim.api.nvim_set_keymap
keymap("i", "kj", "<Esc>", {})
keymap("v", "kj", "<Esc>", {})
keymap("c", "kj", "<C-C>", {})

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<A-k>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<A-j>", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<A-l>", "<C-i>")
vim.keymap.set("n", "<A-h>", "<C-o>")

vim.keymap.set("n", "<F2>", vim.diagnostic.goto_next)

vim.keymap.set("n", "<A-]>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<A-[>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<A-'>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<A-;>", "<cmd>vertical resize -2<cr>")

vim.keymap.set("n", "<leader>gg", function()
	if next(require("diffview.lib").views) == nil then
		vim.cmd("DiffviewOpen")
	else
		vim.cmd("DiffviewClose")
	end
end)

vim.keymap.set("n", "<leader>gh", function()
	if next(require("diffview.lib").views) == nil then
		vim.cmd("DiffviewFileHistory")
	else
		vim.cmd("DiffviewClose")
	end
end)

vim.api.nvim_create_autocmd({ "FocusLost" }, {
	command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "BufLeave" }, {
	command = "silent! wa",
})

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	command = "silent! wa",
})

require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		{ import = "themes" },
	},
	change_detection = { enabled = false },

	-- automatically check for plugin updates
	checker = { enabled = false },
})

-- Setup lazy.nvim
vim.cmd("colorscheme gruvbox-material")
vim.cmd('set shada="NONE"')
