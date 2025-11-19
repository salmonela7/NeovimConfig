vim.cmd [[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.Inspect
  aunmenu PopUp.Select\ All
  aunmenu PopUp.Paste
  aunmenu PopUp.-1-
  aunmenu PopUp.-2-
  anoremenu PopUp.Go\ to\ references <cmd>Telescope lsp_references<CR>
  anoremenu PopUp.Go\ to\ implementations <cmd>Telescope lsp_implementations<CR>
  amenu PopUp.-1- <NOP>
  anoremenu PopUp.Back <C-o>zz
  anoremenu PopUp.Forward <C-i>zz
]]
