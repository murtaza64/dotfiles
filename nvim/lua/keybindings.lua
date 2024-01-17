-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- ctrl-backspace to kill word
vim.keymap.set({ 'i', 'c' }, '<C-H>', '<C-W>')

vim.keymap.set('n', '<leader>q', '<cmd>:q<cr>', { desc = 'Quit window'})
vim.keymap.set('n', '<leader>w', '<cmd>:w<cr>', { desc = 'Write buffer'})

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
vim.keymap.set('n', '<leader>o', function()
  vim.cmd.Oil()
end, { desc = 'Open [o]il' })
vim.keymap.set('n', '<leader>n', '<cmd>:Neogit<cr>', { desc = 'Open [n]eogit' })

-- Paste from system
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"*p', { desc = '"*p', remap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"*P', { desc = '"*P', remap = true })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"*y', { desc = '"*y', remap = true })

vim.keymap.set('n', '<leader>ay', '<cmd>%y<cr>', { desc = 'yank whole buffer'})
vim.keymap.set('n', '<leader>a<leader>y', '<cmd>%y *<cr>', { desc = 'yank whole buffer into "*'})

-- Select pasted test
vim.keymap.set('n', 'g.', "'`[' . strpart(getregtype(), 0, 1) . '`]'", { expr = true , desc = 'Select last edit' })
-- doesn't seem to work with visual block mode properly
-- https://vim.fandom.com/wiki/Selecting_your_pasted_text

-- keep indented text selected
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- open URLs under cursor
vim.keymap.set("n", "gx", ":silent execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>")

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
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })


vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[c', '<cmd>cprev<cr>', { desc = 'Go to previous quickfix item' })
vim.keymap.set('n', ']c', '<cmd>cnext<cr>', { desc = 'Go to next quickfix item' })
vim.keymap.set('n', '[t', '<cmd>tabprev<cr>', { desc = 'Go to previous tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Go to next tab' })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
