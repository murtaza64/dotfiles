-- See `:help vim.o`

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- see inactive_cursorline.lua
-- vim.o.cursorline = true
-- vim.wo.colorcolumn = '80'

vim.o.splitright = true

vim.o.hlsearch = true

vim.opt.listchars = {
  space = '⋅',
  trail = '⋅',
  tab = '» ',
}

-- treat hyphens as part of words
vim.opt.iskeyword:append('-')

-- Don't show default search progress
-- vim.o.shortmess = vim.o.shortmess .. 'S'

vim.o.showmode = false

vim.o.laststatus = 3

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- save more oldfiles
vim.opt.shada = "!,'1000,<50,s10,h"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
local tmux = os.getenv("TMUX")
if tmux and tmux ~= "" then
  vim.g.clipboard = {
    name = 'TmuxClipboard',
    copy = {
      ["+"] = {'tmux-copy'},
      ["*"] = {'tmux-copy'},
    },
    paste = {
      ["+"] = {'tmux', 'save-buffer', '-'},
      ["*"] = {'tmux', 'save-buffer', '-'},
    },
    cache_enabled = 1,
  }
end
-- if os.getenv('WSL_DISTRO_NAME') ~= "" then
--   vim.g.clipboard = {
--     name = 'WslClipboard',
--     copy = {
--       ["+"] = {'clip.exe'},
--       ["*"] = {'clip.exe'},
--     },
--     paste = {
--       ["+"] = {'powershell.exe', '-c', '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
--       ["*"] = {'powershell.exe', '-c', '[Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'},
--     },
--     cache_enabled = 1,
--   }
-- end
local distro_name = os.getenv('WSL_DISTRO_NAME')
if distro_name and distro_name ~= "" then
  vim.g.clipboard = {
    name = 'WslClipboard',
    copy = {
      ["+"] = {'win32yank.exe', '-i', '--crlf'},
      ["*"] = {'win32yank.exe', '-i', '--crlf'},
    },
    paste = {
      ["+"] = {'win32yank.exe', '-o', '--lf'},
      ["*"] = {'win32yank.exe', '-o', '--lf'},
    },
    cache_enabled = 0,
  }
end
-- vim.o.clipboard = 'unnamedplus'
