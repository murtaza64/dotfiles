return {
  dir = vim.fn.stdpath('config') .. '/lua/python_repl',
  name = 'python-repl',
  config = function()
    require('python_repl').setup({
      keymap = '<leader>pr', -- Optional: set to nil to disable keymap
    })
  end,
  cmd = { 'PythonReplStart', 'PythonReplStop', 'PythonReplToggle', 'PythonReplProcessText', 'PythonReplProcessStdin', 'PythonReplTestLsp' },
}
