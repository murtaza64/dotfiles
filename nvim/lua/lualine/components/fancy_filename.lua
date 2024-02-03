local highlight = require('lualine.highlight')

local M = require('lualine.component'):extend()
local colors = require("catppuccin.palettes").get_palette()


function M:init(options)
  M.super.init(self, options)
  self.colors = {
    dir = highlight.create_component_highlight_group(
      { fg = colors.overlay1, gui = 'italic' },
      'filename_dir',
      self.options
    ),
    file = highlight.create_component_highlight_group(
      {},
      'filename_file',
      self.options
    ),
    modified = highlight.create_component_highlight_group(
      { fg = colors.peach },
      'filename_modified',
      self.options
    ),
  }
end

local truncate_path = function(fname, max_length)
    if #fname > max_length then
        fname = vim.fn.pathshorten(fname, 3)
        if #fname > max_length then
            fname = '...' .. string.sub(fname, - (max_length-3))
        end
    end
    return fname
end

function M:update_status()
  local gray = highlight.component_format_highlight(self.colors.dir)
  local normal = highlight.component_format_highlight(self.colors.file)
  local modified = highlight.component_format_highlight(self.colors.modified)
  local dirname = vim.fn.expand("%:.:h")
  local basename = vim.fn.expand("%:t")
  local dirname = truncate_path(dirname, 40)
  local out = gray .. dirname .. '/'
  out = out .. normal .. basename
  if vim.bo.readonly then
    out = out .. gray .. ' 󰷪 '
  end
  if vim.bo.modified then
    out = out .. modified .. ' 󰷬 '
  end
  return out
end

return M
