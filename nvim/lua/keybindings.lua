-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ctrl-backspace to kill word
vim.keymap.set({ 'i', 'c' }, '<C-H>', '<C-W>')

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Enter selects highlighted item in command mode wildmenu
vim.keymap.set('c', '<CR>', "wildmenumode()? '<C-y>' : '<CR>'", { expr = true, silent = true })

-- CR clears search highlighting
-- vim.keymap.set('n', '<CR>', ":noh<CR><CR>", { silent = true })

vim.keymap.set('n', '<leader>t', require('nvim-tree.api').tree.toggle, { desc = 'Toggle nvim-[t]ree' })

-- Paste from system
vim.keymap.set('n', '<leader>p', '"*p', { desc = '"*p' })
vim.keymap.set('n', '<leader>P', '"*P', { desc = '"*P' })

-- Select pasted test
vim.keymap.set('n', 'gp', "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true })
-- doesn't seem to work with visual block mode properly
-- https://vim.fandom.com/wiki/Selecting_your_pasted_text

-- Esc clears search highlighting in normal mode
vim.keymap.set('n', '<Esc>', function()
  if vim.v.hlsearch ~= 0 then
   vim.cmd("noh")
  else
    local keys = vim.api.nvim_replace_termcodes('<Esc>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  end
end)

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
