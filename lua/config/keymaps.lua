vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>")

vim.api.nvim_set_keymap("i", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("v", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("c", "kj", "<C-C>", {})

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set({ "n", "v", "i" }, "<leader>tn", ":tabnew<CR>")
vim.keymap.set({ "n", "v", "i" }, "<leader>tq", ":tabclose<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-k>", ":tabn<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-j>", ":tabp<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-ScrollWheelUp>", "<C-i>")
vim.keymap.set({ "n", "v", "i" }, "<A-ScrollWheelDown>", "<C-o>")
vim.keymap.set({ "n", "v", "i" }, "<A-l>", "<C-i>")
vim.keymap.set({ "n", "v", "i" }, "<A-h>", "<C-o>")

vim.keymap.set("n", "<F2>", vim.diagnostic.goto_next)

vim.keymap.set("n", "<A-]>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<A-[>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<A-'>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<A-;>", "<cmd>vertical resize -2<cr>")

vim.keymap.set("n", "<A-/>", ":noh <cr>")

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
