return {
  {
    'catppuccin/nvim',
    priority = 1000,
    opts = {
      flavour = 'mocha',
      transparent_background = true,
      dim_inactive = {
        -- enabled = true,
        percentage = 0.2,
      },
      color_overrides = {
        -- mocha = {
        --   text = "#d0d0d0",
        --   subtext1 = "#b9b9b9",
        --   subtext0 = "#a0a0a0",
        --   overlay2 = "#8c8c8c",
        --   overlay1 = "#727272",
        --   overlay0 = "#5a5a5a",
        --   surface2 = "#404040",
        --   surface1 = "#272727",
        --   surface0 = "#1a1a1a",
        --   base = "#131313",
        --   mantle = "#0c0c0c",
        --   crust = "#040404",
        -- }
      },
      custom_highlights = function(colors)
        return {
          VerticalSplit = { fg = colors.surface1 },
          WinSeparator = { fg = colors.surface1 },
          NormalFloat = { link = 'Normal' },
          FloatTitle = { link = 'Normal' },
          CursorLine = { bg = colors.surface0 },
          CursorColumn = { bg = colors.surface0 },
          LineNr = { fg = colors.surface2 },
          -- NormalNC = { bg = colors.surface0 },
          -- lualine_c_normal = { bg = colors.surface0 },
          -- DiagnosticUnderlineError = { undercurl = true, sp = '#421B26' },
          -- DiagnosticUnderlineWarn = { bg = '#423a1b' },
          LspSignatureHint = { bg = colors.surface1, fg = colors.peach },
          NoiceCmdline = { bg = colors.base },
          GitSignsChange = { fg = colors.peach },
          AlphaButtonLabel = { fg = colors.pink, bold = true },
          AlphaButtonSides = { fg = colors.surface2 },
          AlphaHeader = { fg = colors.lavender },
          AlphaDivider = { fg = colors.yellow },
          MsgArea = { link = 'Normal' },
          BentoNormalCustom = { bg = colors.base },
          CodeDiffLineInsert = { bg = "#1a2b1a" },  -- very dark green
          CodeDiffLineDelete = { bg = "#2b1a1a" },  -- very dark red
          CodeDiffCharInsert = { bg = "#264a26" },  -- muted green
          CodeDiffCharDelete = { bg = "#4a2626" },  -- muted red
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
            errors = { "undercurl" }, -- change these to undercurl when supported
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
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
