local colors = require('catppuccin.palettes').get_palette('mocha')
local custom_catppuccin = require('lualine.themes.catppuccin')
-- custom_catppuccin.normal.c.bg = colors.base
custom_catppuccin.insert.c = { fg = colors.green, bg = colors.mantle }
custom_catppuccin.visual.c = { fg = colors.mauve, bg = colors.mantle }

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

local git_dirty_color = function()
  local filename = vim.fn.expand('%:p')
  local ignored = vim.fn.system("git check-ignore --quiet "..filename.." && echo -n 'ignored'")
  if ignored == 'ignored' then
    return { fg = colors.surface2 }
  end
  local resp = vim.fn.system('git diff --quiet '..filename.." && echo -n 'clean' || echo -n 'dirty'")
  if resp == 'clean' then
    return { fg = colors.green }
  else
    return { fg = colors.peach }
  end
end

local harpoon = function()
  local status = require('harpoon.mark').status()
  if status == '' then
    return ''
  end
  -- strip leading M from response
  status = string.sub(status, 2)
  return ' '..status
end

local lsp = function()
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return ''
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return '󰧑 '
      end
    end
    return ''
  end

local treesitter = function()
  if not require('nvim-treesitter').statusline() then
    return ''
  end
  return '󰹩'
end

local treesitter_color = function()
  if not require('nvim-treesitter').statusline() then
    return { fg = colors.surface2 }
  end
  return { fg = colors.green }
end

local lsp_color = function()
  local clients = vim.lsp.get_active_clients()
  -- confirm that the client is attached to the current buffer and supports the current filetype
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return { fg = colors.mauve }
    end
  end
  return { fg = colors.surface2 }
end

local lsp_and_treesitter = function()
  if not require('nvim-treesitter').statusline() then
    return lsp()
  end
  return '󰹩 '..lsp()
end

local jenkins_filename = function()
  -- job name is parent of file
  local job_name = vim.fn.expand('%:p:h:t')
  -- filename is 1234.log (build number)
  local build_number = vim.fn.expand('%:t:r')
  return job_name ..' #'.. build_number
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

local noice_macro = {
  function()
    local mode = require("noice").api.statusline.mode.get()
    -- if mode starts with recording
    if string.find(mode, 'recording') then
      return string.gsub(mode, 'recording @', '󰑋 ')
    end
    return mode
  end,
  cond = require("noice").api.statusline.mode.has,
  color = { fg = colors.red, gui = 'bold' },
}

local copilot = {
  'copilot',
  symbols = {
    status = {
      icons = {
        enabled = " ",
        sleep = " ",   -- auto-trigger disabled
        disabled = " ",
        warning = " ",
        unknown = " "
      },
      hl = {
        enabled = colors.sky,
        disabled = colors.surface2,
        sleep = colors.pink,
        warning = colors.yellow,
        unknown = colors.surface2,
      },
    },
  },
  show_colors = true,
  padding = { left = 1, right = 0 },
}
return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    -- dependencies = { 'noice' },
    opts = {
      options = {
        icons_enabled = true,
        theme = custom_catppuccin,
        -- component_separators = '│',
        component_separators = '',
        section_separators = '',
        -- section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          -- 'mode',
          -- separator = { left = '' },
          -- padding = {
          --   right = 2,
          --   left = 1
          -- },
        },
        lualine_b = {
        },
        lualine_c = {
          noice_macro,
          {
            harpoon,
            color = { fg = colors.flamingo, gui = 'italic' },
          },
          {
            'filename',
            symbols = {
              readonly = '󰷪 ',
              modified = '󰷬 ',
            },
            path = 1,
          },
          -- 'diff',
          -- {
          --   function() return '' end,
          --   color = git_dirty_color,
          -- },
          {
            'diagnostics',
            sections = { 'error', 'warn' },
            symbols = { error = 'E', warn = 'W' },
          }
        },
        lualine_x = {
          -- {
          --   require("noice").api.status.command.get,
          --   cond = require("noice").api.status.command.has,
          --   color = { fg = "#ff9e64" },
          -- },
          -- searchinfo,

          copilot,
          {
            function() return '󰹩' end,
            color = treesitter_color,
            separator = { right = '' },
            padding = { left = 1, right = 1 },
          },
          {
            function() return '󰧑 ' end,
            color = lsp_color,
            padding = { left = 0, right = 1 },
          },
          {
            'filetype',
            colored = true,
            -- icon_only = true,
            padding = { left = 1, right = 1 },
          },
          indent,
        },
        lualine_y = {
          {
            'datetime',
            style = '%H:%M',
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
        'man',
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
            lualine_a = { function() return "Jenkins Log" end },
            lualine_b = { jenkins_filename },
            lualine_c = {},
            lualine_x = {},
            lualine_y = { 'location' },
            lualine_z = { 'progress' },
          },
          filetypes = { 'jenkins_log' }
        },
        {
          sections = {
            lualine_a = {},
            lualine_b = {},
          },
          filetypes = { 'oil' }
        },
        {
          sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
          },
          filetypes = { 'alpha' }
        },
      },
    },
  },
}
