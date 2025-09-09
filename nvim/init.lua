-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazyconfig')
require('pywalcolors')

require('delta')
require('highlight_hex_colors')

require('options')
require('keybindings')

require('title')
require('inactive_cursorline')
require('oil_winbar')
require('autocmds')
require('github_link')
require('claude')
require('git_urls')

vim.filetype.add({
  pattern = { ['.*pipeline'] = 'jenkins' },
  extension = {
    fastfile = 'ruby',
    xsh = 'xsh',
  },
})
-- run noneckpain after a 1 sec delay
if not os.getenv('MURTAZA_NVIM_NO_NNP') then
  -- local timer = vim.uv.new_timer()
  -- timer:start(100, 0, vim.schedule_wrap(function()
  --   vim.cmd('NoNeckPain')
  -- end))
else
  -- shell command editor support
  vim.keymap.set('n', '<cr><cr>', function()
    vim.fn.system('touch /tmp/nvim_exec_next_zsh_command')
    vim.cmd('wq')
  end)
end
local checktime_timer = vim.loop.new_timer()
checktime_timer:start(0, 1000, vim.schedule_wrap(function()
  vim.cmd('checktime')
end))
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
