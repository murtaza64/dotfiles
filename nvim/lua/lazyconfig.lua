-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  'kmonad/kmonad-vim',

  -- dot repeat plugin commands
  'tpope/vim-repeat',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {'akinsho/git-conflict.nvim', version = "*", config=true},
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = true
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
      vim.keymap.set({"n", "v", "s"}, "<C-M-h>", ":<C-U>TmuxNavigateLeft<cr>", { silent = true })
      vim.keymap.set({"n", "v", "s"}, "<C-M-j>", ":<C-U>TmuxNavigateDown<cr>", { silent = true })
      vim.keymap.set({"n", "v", "s"}, "<C-M-k>", ":<C-U>TmuxNavigateUp<cr>", { silent = true })
      vim.keymap.set({"n", "v", "s"}, "<C-M-l>", ":<C-U>TmuxNavigateRight<cr>", { silent = true })
    end,
  },

  -- Useful plugin to show you pending keybinds.
  {
    'folke/which-key.nvim',
    opts = {
      operators = {
        ys = "Surround"
      },
    },
  },

  {
    'stevearc/oil.nvim',
    opts = {
      cleanup_delay_ms = false,
      win_options = {
        wrap = true
      }
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  { import = 'lazy_plugin_specs.colors' },
  -- noice is too buggy/heavy
  -- { import = 'lazy_plugin_specs.noice' },
  { import = 'lazy_plugin_specs.aesthetics' },
  { import = 'lazy_plugin_specs.editing' },
  { import = 'lazy_plugin_specs.lsp' },
  { import = 'lazy_plugin_specs.lualine' },
  { import = 'lazy_plugin_specs.motion' },
  { import = 'lazy_plugin_specs.nvim-tree' },
  { import = 'lazy_plugin_specs.nvim-treesitter' },
  { import = 'lazy_plugin_specs.telescope' },
}, {})
