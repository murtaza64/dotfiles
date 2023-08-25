return {
  {
    'catppuccin/nvim',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      dim_inactive = {
        enabled = true,
        percentage = 0.5,
      },
      custom_highlights = function(colors)
        return {
          VerticalSplit = { fg = colors.surface1 },
          WinSeparator = { fg = colors.surface1 },
          MsgArea = { bg = colors.mantle },
          DiagnosticUnderlineError = { bg = '#32283a' },
          DiagnosticUnderlineWarn = { bg = '#33313a' },
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
