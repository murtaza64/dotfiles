local colors = require('catppuccin.palettes').get_palette()
vim.api.nvim_set_hl(0, "OilIcon", {
  -- bg = colors.pink,
  -- fg = '#5f6107',
  bg = colors.crust,
  fg = colors.surface2,
  bold = true,
})
vim.api.nvim_set_hl(0, "OilDirName", {
  bg = colors.surface0,
  fg = colors.blue,
  bold = true,
})
vim.api.nvim_create_autocmd({'BufWinEnter', 'BufModifiedSet'}, {
  pattern = 'oil://*',
  callback = function(ev)
    local dir = vim.fn.expand('%')
    dir = dir:gsub('oil://', '')
    local ft = vim.api.nvim_buf_get_option(ev.buf, 'filetype')
    local winbar = '%#OilIcon# oil %#OilDirName#  ' .. dir
    local modified = vim.api.nvim_buf_get_option(ev.buf, 'modified')

    vim.wo.winbar = winbar
    if modified then
      vim.wo.winbar = winbar .. ' 󰷬 '
    end
  end
})

-- vim.api.nvim_create_autocmd({"BufWinLeave"}, {
--   callback = function()
--   end
-- })
