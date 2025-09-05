return {
  {
    'stevearc/oil.nvim',
    opts = {
      -- cleanup_delay_ms = false,
      win_options = {
        wrap = true,
        signcolumn = "yes:2",
      },
      keymaps = {
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["q"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return name == ".."
        end,
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "refractalize/oil-git-status.nvim",

    dependencies = {
      "stevearc/oil.nvim",
    },

    config = true,
  },
}
