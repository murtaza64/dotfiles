vim.o.title = true

vim.api.nvim_create_autocmd({"VimEnter","BufModifiedSet", "BufEnter", "BufWinEnter"}, {
  callback = function(ev)
    -- print(string.format('event fired: %s', vim.inspect(ev)))
    local title
    if ev.file == "" then
      title = "nvim"
    else
      title = vim.fn.expand("%:t")
    end
    if vim.api.nvim_buf_get_option(ev.buf, 'modified') then
      title = title .. ' 󰷬 '
    end
    vim.o.titlestring = title
  end
})
