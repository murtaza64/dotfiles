vim.api.nvim_create_autocmd({"WinLeave"}, {
  callback = function(ev)
    vim.wo.cursorline = false
  end
})

vim.api.nvim_create_autocmd({"WinEnter", "VimEnter"}, {
  callback = function(ev)
    vim.wo.cursorline = true
  end
})
