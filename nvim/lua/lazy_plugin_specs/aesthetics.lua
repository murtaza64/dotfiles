return {

  {
    "shortcuts/no-neck-pain.nvim",
    opts = {
      -- debug = true,
      buffers = {
        wo = {
          fillchars = "eob: ",
        },
      },
    },
  },

  -- {
  --   "petertriho/nvim-scrollbar",
  --   config = function(opts)
  --     require("scrollbar").setup(opts)
  --     require("scrollbar.handlers.gitsigns").setup()
  --     require("scrollbar.handlers.search").setup({
  --       override_lens = function() end,
  --     })
  --   end,
  --   dependencies = {
  --     "lewis6991/gitsigns.nvim",
  --     "kevinhwang91/nvim-hlslens"
  --   },
  -- },
  -- "lewis6991/satellite.nvim",

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      -- char = '┊',
      indent = { char = '▏' },
      scope = { enabled = false },
    },
    init = function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = require('catppuccin.palettes').get_palette('mocha').surface1})
    end
  },

  -- highlight surrounding braces
  {
    "utilyre/sentiment.nvim",
    version = "*",
    event = "VeryLazy", -- keep for lazy loading
    opts = {
      -- config
    },
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },

  'xiyaowong/virtcolumn.nvim',
  {
    'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
    init = function()
      local rainbow_delimiters = require('rainbow-delimiters')
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          -- lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end
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
        -- vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      require'alpha'.setup(require'alpha-theme'.config)
    end
  },
  -- {
  --   "folke/trouble.nvim",
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   opts = { },
  -- }
  -- {
  --   'kevinhwang91/nvim-bqf',
  --   ft = 'qf'
  -- },
}
