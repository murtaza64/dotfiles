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
  'tpope/vim-repeat',

  -- {
  --   'ggandor/leap.nvim',
  --   lazy = false,
  --   config = function()
  --     require('leap').setup({
  --       highlight_unlabeled_phase_one_targets = true
  --     })
  --     require('leap').add_default_mappings()
  --   end
  -- },

  {
    'ggandor/lightspeed.nvim',
    config = function()
      require('lightspeed').setup({})
      local colors = require('catppuccin.palettes').get_palette()
      vim.api.nvim_set_hl(0, 'LightspeedShortcut', { bg = colors.yellow, fg = 'black', bold = true, nocombine = true })
      vim.api.nvim_set_hl(0, 'LightspeedLabel', { bg = colors.yellow, fg = 'black', bold = true, nocombine = true })
      vim.api.nvim_set_hl(0, 'LightspeedGreyWash', {})
    end
  },

  -- {
  --   'phaazon/hop.nvim',
  --   config = function()
  --     require('hop').setup({
  --       create_hl_autocmd = false,
  --     })
  --     vim.keymap.set('n', 's', '<cmd>HopChar2<cr>', { silent = true })
  --     vim.api.nvim_set_hl(0, 'HopUnmatched', {})
  --     vim.api.nvim_set_hl(0, 'HopNextKey', { bg = 'yellow', fg = 'black', bold = true, nocombine = true })
  --   end
  -- },
  --
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

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
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      -- char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "gs",
          visual_line = "gS"
        }
      })
    end
  },


  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  { import = 'lazy_plugin_specs.colors' },
  -- noice is too buggy/heavy
  -- { import = 'lazy_plugin_specs.noice' },
  { import = 'lazy_plugin_specs.lsp' },
  { import = 'lazy_plugin_specs.lualine' },
  { import = 'lazy_plugin_specs.nvim-tree' },
  { import = 'lazy_plugin_specs.nvim-treesitter' },
  { import = 'lazy_plugin_specs.telescope' },
}, {})
