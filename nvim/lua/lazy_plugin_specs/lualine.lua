local searchinfo = function()
  if vim.v.hlsearch == 0 then
    return ''
  end

  local result = vim.fn.searchcount { maxcount = 999, timeout = 500 }
  if next(result) == nil then
    return ''
  end

  local denominator = math.min(result.total, result.maxcount)
  return string.format('  %s [%d/%d]', vim.fn.getreg('/'), result.current, denominator)
end
local indent = function()
  local out = ''
  if vim.bo.expandtab then
    out = out..'󱁐 '
  else
    out = out..'󰌒 '
  end
  out = out..' sw='..vim.bo.shiftwidth
  if vim.bo.tabstop ~= 8 then
    out = out..' ts='..vim.bo.tabstop
  end
  if vim.bo.softtabstop > 0 then
    out = out..' sts='..vim.bo.softtabstop
  end
  return out
end
return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    -- dependencies = { 'noice' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'catppuccin',
        component_separators = '│',
        section_separators = '',
        -- section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            'mode',
            -- separator = { left = '' },
            -- padding = {
            --   right = 2,
            --   left = 1
            -- },
          },
        },
        lualine_b = {
          'diff',
          'diagnostics',
          {
            'filename',
            symbols = {
              readonly = '󰷪 ',
              modified = '󰷬 ',
            },
            path = 1,
          },
        },
        lualine_c = {
        },
        lualine_x = {
          -- {
          --   require("noice").api.status.command.get,
          --   cond = require("noice").api.status.command.has,
          -- },
          searchinfo,
        },
        lualine_y = {
          {
            indent,
            -- separator = { left = '', right = '' },
            -- padding = {
            --   left = 1,
            --   right = 1,
            -- },
          }
        },
        lualine_z = {
        },
      },
      inactive_sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        },
        lualine_x = {
        },
      },
      extensions = {
        'nvim-tree',
        {
          sections = {
            lualine_a = { function() return "Unsaved Changes" end },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          filetypes = { 'UnsavedChanges' }
        },
        {
          sections = {
            lualine_a = {'mode'},
            lualine_b = {},
          },
          filetypes = { 'oil' }
        },
      },
    },
  },
}
