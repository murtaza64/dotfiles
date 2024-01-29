return {
  {
    'ggandor/leap.nvim',
    lazy = false,
    config = function()
      require('leap').setup({
        highlight_unlabeled_phase_one_targets = true
      })
      require('leap').add_default_mappings()
      -- require('leap').add_repeat_mappings(';', ',', {
      --   -- False by default. If set to true, the keys will work like the
      --   -- native semicolon/comma, i.e., forward/backward is understood in
      --   -- relation to the last motion.
      --   relative_directions = true,
      --   -- By default, all modes are included.
      --   modes = {'n', 'x', 'o'},
      -- })

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
        '<leader>l',
        function() require'leap-ast'.leap() end,
        { desc = "[L]eap to AST node" }
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
  {
    'ThePrimeagen/harpoon',
    config = function(opts) 
      -- require('harpoon').setup(opts)
      vim.keymap.set('n', '<leader>h', require("harpoon.ui").toggle_quick_menu, { silent = true, desc = "Toggle [H]arpoon" })
      vim.keymap.set('n', ']h', require("harpoon.ui").nav_next, { silent = true, desc = "Next [H]arpoon" })
      vim.keymap.set('n', '[h', require("harpoon.ui").nav_prev, { silent = true, desc = "Previous [H]arpoon" })
      vim.keymap.set('n', 'mh', require("harpoon.mark").add_file, { silent = true, desc = "[M]ark [H]arpoon" })
      vim.keymap.set('n', '<leader>1', function() require("harpoon.ui").nav_file(1) end, { silent = true, desc = "Harpoon 1" })
      vim.keymap.set('n', '<leader>2', function() require("harpoon.ui").nav_file(2) end, { silent = true, desc = "Harpoon 2" })
      vim.keymap.set('n', '<leader>3', function() require("harpoon.ui").nav_file(3) end, { silent = true, desc = "Harpoon 3" })
      vim.keymap.set('n', '<leader>4', function() require("harpoon.ui").nav_file(4) end, { silent = true, desc = "Harpoon 4" })
      vim.keymap.set('n', '<leader>5', function() require("harpoon.ui").nav_file(5) end, { silent = true, desc = "Harpoon 5" })
      vim.keymap.set('n', '<leader>6', function() require("harpoon.ui").nav_file(6) end, { silent = true, desc = "Harpoon 6" })
      vim.keymap.set('n', '<leader>7', function() require("harpoon.ui").nav_file(7) end, { silent = true, desc = "Harpoon 7" })
      vim.keymap.set('n', '<leader>8', function() require("harpoon.ui").nav_file(8) end, { silent = true, desc = "Harpoon 8" })
      vim.keymap.set('n', '<leader>9', function() require("harpoon.ui").nav_file(9) end, { silent = true, desc = "Harpoon 9" })
    end
  },
}
