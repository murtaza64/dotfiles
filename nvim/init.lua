if vim.g.shadowvim then
  -- require('shadowvim')
else
  -- disable netrw for nvim-tree
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1

  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  require('lazyconfig')

  -- vim.g.copilot_no_tab_map = true
  -- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

  require('delta')
  require('highlight_hex_colors')

  require('options')
  require('keybindings')

  -- Other snippets, autocommands
  require('title')
  require('inactive_cursorline')
  require('oil_winbar')
  require('autocmds')
  require('github_link')

  vim.filetype.add({
    pattern = { ['.*pipeline'] = 'jenkins' },
    extension = {
      fastfile = 'ruby',
      xsh = 'xsh',
    },
  })
  -- run noneckpain after a 1 sec delay
  if not os.getenv('MURTAZA_NVIM_NO_NNP') then
    local timer = vim.loop.new_timer()
    timer:start(100, 0, vim.schedule_wrap(function()
      vim.cmd('NoNeckPain')
    end))
  else
    vim.keymap.set('n', '<cr><cr>', function()
      vim.fn.system('touch /tmp/nvim_exec_next_zsh_command')
      vim.cmd('wq')
    end)
  end
  -- vim.cmd('hi Normal guibg=#131313')
  -- vim.cmd('hi EndOfBuffer guifg=#191919 guibg=#191919')
  -- vim.cmd('hi EndOfBuffer guifg=#131313')
  -- vim.cmd('hi LineNr guibg=#191919')
  -- vim.cmd('hi CursorLineNr guibg=#191919')
  -- vim.cmd('hi SignColumn guibg=#191919')
  -- vim.cmd('hi NormalNC guibg=#191919')
  -- vim.cmd('hi NormalFloat guibg=#252525')
  -- vim.cmd('hi lualine_c_normal guibg=#191919')
  -- vim.cmd('hi MsgArea guibg=#191919')
  -- vim.cmd('hi WinSeparator guibg=#191919')
  -- vim.cmd('hi TreesitterContext guibg=#191919')
  -- vim.cmd('hi TreesitterContextLineNumber guibg=#191919')
  -- vim.cmd('set foldcolumn=1')
  -- The line beneath this is called `modeline`. See `:help modeline`
  -- vim: ts=2 sts=2 sw=2 et
end
