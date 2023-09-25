return {
  {
    'catppuccin/nvim',
    priority = 1000,
    opts = {
      flavour = 'frappe',
      dim_inactive = {
        -- enabled = true,
        percentage = 0.2,
      },
      color_overrides = {
        -- mocha = {
        --   text = "#d0d0d0",
        --   subtext1 = "#b9b9b9",
        --   subtext0 = "#a0a0a0",
        --   overlay2 = "#909090",
        --   overlay1 = "#797979",
        --   overlay0 = "#606060",
        --   surface2 = "#494949",
        --   surface1 = "#313131",
        --   surface0 = "#252525",
        --   base = "#191919",
        --   mantle = "#131313",
        --   crust = "#090909",
        -- }
      },
      custom_highlights = function(colors)
        return {
          VerticalSplit = { fg = colors.surface1 },
          WinSeparator = { fg = colors.surface1 },
          MsgArea = { bg = colors.mantle },
          DiagnosticUnderlineError = { bg = '#421B26' },
          DiagnosticUnderlineWarn = { bg = '#423a1b' },
          LspSignatureHint = { bg = colors.surface1, fg = colors.peach },
        }
      end,
      integrations = {
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" }, -- change these to undercurl when supported
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        }
      },
    },
    config = function(_, opts)
      require('catppuccin').setup(opts)
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
