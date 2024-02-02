local delete_qf_item_under_cursor = function()
  local qf_list = vim.fn.getqflist()
  local current_line = vim.fn.line('.')
  local new_qf_list = {}
  for i, item in ipairs(qf_list) do
    if i ~= current_line then
      table.insert(new_qf_list, item)
    end
  end
  vim.fn.setqflist(new_qf_list, 'r')
  vim.cmd('copen')
  -- go to next line after deleted item
  -- navigate cursor to line current_line
  vim.api.nvim_win_set_cursor(0, { current_line, 0 })
end

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', 'dd', delete_qf_item_under_cursor, { buffer = bufnr, desc = "Delete quickfix item from list" })
