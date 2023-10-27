return {
  {
    'ggandor/leap.nvim',
    lazy = false,
    config = function()
      require('leap').setup({
        highlight_unlabeled_phase_one_targets = true
      })
      require('leap').add_default_mappings()

      -- fix duplicate cursor bug
      vim.api.nvim_create_autocmd(
        "User",
        {
          callback = function()
            vim.cmd.hi("Cursor", "blend=100")
            vim.opt.guicursor:append { "a:Cursor/lCursor" }
          end,
          pattern = "LeapEnter"
        }
      )
      vim.api.nvim_create_autocmd(
        "User",
        {
          callback = function()
            vim.cmd.hi("Cursor", "blend=0")
            vim.opt.guicursor:remove { "a:Cursor/lCursor" }
          end,
          pattern = "LeapLeave"
        }
      )
    end
  },

  {
    'ggandor/flit.nvim',
    opts = { labeled_modes = 'v' },
  },

  {
    'ggandor/leap-ast.nvim',
    config = function()
      vim.keymap.set(
        { 'n', 'x', 'o' },
        '<leader>n',
        function() require'leap-ast'.leap() end,
        { desc = "Leap to AST [n]ode" }
      )
    end,
  },

  {
    'ggandor/leap-spooky.nvim',
    opts = {

    }
  },
  -- {
  --   'ggandor/lightspeed.nvim',
  --   config = function()
  --     require('lightspeed').setup({})
  --     local colors = require('catppuccin.palettes').get_palette()
  --     vim.api.nvim_set_hl(0, 'LightspeedShortcut', { bg = colors.peach, fg = 'black', bold = true, nocombine = true })
  --     vim.api.nvim_set_hl(0, 'LightspeedLabel', { bg = colors.peach, fg = 'black', bold = true, nocombine = true })
  --     vim.api.nvim_set_hl(0, 'LightspeedGreyWash', {})
  --   end
  -- },

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
}
