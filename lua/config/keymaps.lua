vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>")

vim.api.nvim_set_keymap("i", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("v", "kj", "<Esc>", {})
vim.api.nvim_set_keymap("c", "kj", "<C-C>", {})

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>cn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>cp", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>rp", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set({ "n", "v" }, "<leader>tn", ":tabnew<CR>")
vim.keymap.set({ "n", "v" }, "<leader>tq", ":tabclose<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-k>", ":tabn<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-j>", ":tabp<CR>")
vim.keymap.set({ "n", "v", "i" }, "<A-ScrollWheelUp>", "<C-i>")
vim.keymap.set({ "n", "v", "i" }, "<A-ScrollWheelDown>", "<C-o>")
-- vim.keymap.set({ "n", "v", "i" }, "<A-l>", "<C-i>zz")
-- vim.keymap.set({ "n", "v", "i" }, "<A-h>", "<C-o>zz")
vim.keymap.set({ "n", "v", "i" }, "<C-i>", "<C-i>zz")
vim.keymap.set({ "n", "v", "i" }, "<C-o>", "<C-o>zz")
vim.keymap.set({ "n", "v", "i" }, "<X2Mouse>", "<C-i>zz")
vim.keymap.set({ "n", "v", "i" }, "<X1Mouse>", "<C-o>zz")

-- vim.keymap.set({ "n", "v", "i" }, "<X2Mouse>", function ()
--    print("Mouse forward")
-- end)
-- vim.keymap.set({ "n", "v", "i" }, "<X1Mouse>", function ()
--    print("Mouse back")
-- end)

vim.keymap.set("n", "<F2>", vim.diagnostic.goto_next)

vim.keymap.set("n", "<A-]>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<A-[>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<A-'>", "<cmd>vertical resize +8<cr>")
vim.keymap.set("n", "<A-;>", "<cmd>vertical resize -8<cr>")

vim.keymap.set("n", "<A-/>", ":noh <cr>")

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "G", "Gzz")
vim.keymap.set("n", "<leader>fjs", ":%!jq '.'<CR>")


vim.keymap.set({ "n", "v", "i" }, "<A-H>", "<C-W>R")
vim.keymap.set({ "n", "v", "i" }, "<A-L>", "<C-W>r")
-- vim.keymap.set("n", "<leader>gg", function()
-- 	vim.cmd("silent! wa")
-- 	vim.cmd("Floatexecutestate lazygit sourcecontrol")
-- end)

local job_id = 0
vim.keymap.set("n", "<leader>teo", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 15)

    job_id = vim.bo.channel
end)

vim.keymap.set("n", "<leader>tef", "<cmd>Floaterminal<cr>")

local current_command = ""
vim.keymap.set("n", "<leader>tes", function()
    current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<leader>ter", function()
    if current_command == "" then
        current_command = vim.fn.input("Command: ")
    end

    vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
