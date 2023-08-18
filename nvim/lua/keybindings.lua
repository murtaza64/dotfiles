-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Enter selects highlighted item in command mode wildmenu
vim.keymap.set('c', '<CR>', "wildmenumode()? '<C-y>' : '<CR>'", { expr = true, silent = true})

-- CR clears search highlighting
-- vim.keymap.set('n', '<CR>', ":noh<CR><CR>", { silent = true })

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

vim.keymap.set('n', '<leader>t', require('nvim-tree.api').tree.toggle, { desc = 'Toggle nvim-[t]ree' })

-- Paste from system
vim.keymap.set('n', '<leader>p', '"*p', { desc = '"*p' })
vim.keymap.set('n', '<leader>P', '"*P', { desc = '"*P' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
