return {

  'xiyaowong/virtcolumn.nvim',

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

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      -- char = '┊',
      indent = {
        char = '▏',
        highlight = { "Whitespace" },
      },
      scope = { enabled = false },
    },
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
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▁' },
        topdelete = { text = '▔' },
        changedelete = { text = '▎' },
        sign_priority = 10,
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[g', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Next [G]it Hunk' })
        vim.keymap.set('n', ']g', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Previous [G]it Hunk' })
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
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = { "CodeDiff" },
    opts = {
      -- keep it close to your current git navigation
      keymaps = {
        view = {
          quit = "q",
          next_hunk = "]g",
          prev_hunk = "[g",
        },
      },
      diff = {
        disable_inlay_hints = true,
        original_position = "left",
      },
      explorer = {
        position = "left",
        width = 45,
        view_mode = "list",
        initial_focus = "explorer",
      },
      history = {
        position = "bottom",
        height = 15,
        initial_focus = "history",
        view_mode = "list",
      },
      highlights = {
        line_insert = "DiffAdd",
        line_delete = "DiffDelete",
        char_brightness = nil, -- let it auto-tune for catppuccin + background
      },
    },
    init = function()
      -- complements your existing <leader>gg (neogit)
      vim.keymap.set("n", "<leader>gd", "<cmd>CodeDiff<cr>", { desc = "CodeDiff" })
      vim.keymap.set("n", "<leader>gD", "<cmd>CodeDiff file HEAD<cr>", { desc = "CodeDiff (file vs HEAD)" })
    end,
  },
}
