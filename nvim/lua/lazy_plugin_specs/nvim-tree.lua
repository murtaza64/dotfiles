local opts = {
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true
  },
  modified = {
    -- enable = true
  },
  renderer = {
    icons = {
      glyphs = {
        git = {
          unstaged = '!',
          staged = '+',
          untracked = '?',
        }
      }
    }
  },
  on_attach = function(bufnr)
    print("attach")
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    -- vim.keymap.set('n', 's', function()
    --   local current_window = vim.fn.win_getid()
    --   require('leap').leap { target_windows = { current_window } }
    -- end, opts('Leap bidirectional'))
  end
}

return {
  {
    'nvim-tree/nvim-tree.lua',
    opts = opts,
  },
  'nvim-tree/nvim-web-devicons',
}
