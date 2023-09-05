-- https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
local function rgbToHsl(color)
  local r_hex = color:sub(2, 3)
  local g_hex = color:sub(4, 5)
  local b_hex = color:sub(6, 7)

  local r = tonumber(r_hex, 16)
  local g = tonumber(g_hex, 16)
  local b = tonumber(b_hex, 16)

  r, g, b = r / 255, g / 255, b / 255

  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0 -- achromatic
  else
    local d = max - min
    if l > 0.5 then s = d / (2 - max - min) else s = d / (max + min) end
    if max == r then
      h = (g - b) / d
      if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, l, a or 255
end

local function highlight_colors()
  local bufnr = vim.fn.bufnr()
  local winid = vim.api.nvim_get_current_win()
  local ns = vim.api.nvim_create_namespace("HighlightHex")
  -- print(winid)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  -- vim.api.nvim_win_set_hl_ns(winid, ns)
  for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local match = vim.regex('#[0-9a-fA-F]\\{6\\}'):match_str(line)
    if match then
      local color = line:sub(match+1, match+7)
      -- print(color, i, match, rgbToHsl(color))
      local _, _, brightness, _ = rgbToHsl(color)
      local hlgrp = ("HighlightHex.%s"):format(color:sub(2))
      if brightness > 0.5 then
        vim.api.nvim_set_hl(0, hlgrp, { bg = color, fg = require('catppuccin.palettes').get_palette('mocha').base})
      else
        vim.api.nvim_set_hl(0, hlgrp, { bg = color })
      end
      -- vim.highlight.range(bufnr, ns, hlgrp, { i, match }, { i, match+7 }, {})
      -- vim.api.nvim_buf_add_highlight(bufnr, ns, hlgrp, i-1, match, match+7)
      vim.api.nvim_buf_set_extmark(bufnr, ns, i-1, match, {
        end_col = match + 7,
        -- hl_group = hlgrp,
        virt_text = {
          { "  ", "Normal" },
          { "    ", hlgrp },
        }
      })
    end
    -- print(match)
  end
end
vim.api.nvim_create_user_command("HighlightHexColors", highlight_colors, {})

