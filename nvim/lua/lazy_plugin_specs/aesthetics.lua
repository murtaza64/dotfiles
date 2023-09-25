return {
  {
    'shortcuts/no-neck-pain.nvim',

    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      -- char = '┊',
      -- char = '▏',
      -- context_char = '▏',
      show_trailing_blankline_indent = false,
      context_start_priority = 1,
      show_current_context = true,
    },
    init = function()
      vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg = require('catppuccin.palettes').get_palette('mocha').overlay0})
      vim.api.nvim_set_hl(0, 'IndentBlanklineChar', { fg = require('catppuccin.palettes').get_palette('mocha').surface1})
    end
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
}
