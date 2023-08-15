local function unsaved_delta()

  if not vim.bo.modified then
    print("Buffer not modified")
    return
  end

  local initial_buffer = vim.fn.bufnr()
  local filename = vim.fn.expand("%")

  -- local bufname = "[unsaved delta] " .. filename
  -- local bufnr = require('utils').find_buffer_by_name(bufname)
  -- if bufnr == -1 then
  local bufnr = vim.api.nvim_create_buf(false, false)
  -- vim.api.nvim_buf_set_name(bufnr, bufname)
  -- end
  vim.cmd("vsplit")
  vim.wo.number = false
  vim.wo.relativenumber = false
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)

  vim.keymap.set('n', 'q', ':q<CR>', { buffer=bufnr })
  vim.keymap.set('n', 'i', '', { buffer=bufnr })
  vim.keymap.set('n', 'a', '', { buffer=bufnr })
  vim.keymap.set('n', 'A', '', { buffer=bufnr })
  vim.keymap.set('n', 'o', '', { buffer=bufnr })
  vim.keymap.set('n', 'O', '', { buffer=bufnr })
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'UnsavedChanges')
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)

  local chan_term = vim.api.nvim_open_term(bufnr, {})
  local chan_job = vim.fn.jobstart({'delta', '--true-color=always', '-n', filename, '-'}, {
    on_stdout = function(_, data)
      -- vim.api.nvim_buf_set_lines(59, -1, -1, false, data)
      for _, line in ipairs(data) do
        vim.api.nvim_chan_send(chan_term, line .. '\n\r')
      end
    end,
    on_exit = function(_, exit_code)
      if exit_code == 0 then
        vim.api.nvim_win_close(win, false)
        print("Buffer not actually modified")
      end
    end
  })
  local buflines = vim.api.nvim_buf_get_lines(initial_buffer, 0, -1, false)
  for _, line in ipairs(buflines) do
    vim.api.nvim_chan_send(chan_job, line .. '\n')
  end
  vim.fn.chanclose(chan_job, 'stdin')
end

vim.api.nvim_create_user_command("UnsavedChanges", unsaved_delta, {})
