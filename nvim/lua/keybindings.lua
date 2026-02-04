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

vim.keymap.set('i', 'jk', '<Esc>', { silent = true })

vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Enter selects highlighted item in command mode wildmenu
vim.keymap.set('c', '<CR>', "wildmenumode()? '<C-y>' : '<CR>'", { expr = true, silent = true })

-- CR clears search highlighting
-- vim.keymap.set('n', '<CR>', ":noh<CR><CR>", { silent = true })

vim.keymap.set('n', '<leader>o', function()
  -- Only use preview mode if not in a split
  local win_count = #vim.api.nvim_tabpage_list_wins(0)
  local oil_config = {}
  
  if win_count == 1 then
    oil_config.preview = {vertical=true}
  end
  
  require('oil').open(nil, oil_config)
end, { desc = 'Open [o]il' })

vim.keymap.set('n', '<leader>gg', '<cmd>:Neogit<cr>', { silent=true, desc = 'Open [n]eogit' })
vim.keymap.set("n", "<leader>uc", ":UnsavedChanges<CR>", { silent=true, desc = 'Show unsaved changes' })
vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<CR>", { silent=true, desc = 'Toggle [U]ndo [T]ree' })
vim.keymap.set("n", "<leader>nnp", ":NoNeckPain<CR>", { silent=true, desc = 'Toggle [N]o [N]eck [P]ain' })

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

-- / in visual mode searches selected text
vim.keymap.set('v', '/', '"sy/<C-R>s', { desc = 'Search selected text' })

-- keep indented text selected
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- vscode-style move line/selection
vim.keymap.set('v', '<m-j>', 'djPg.=gv', { desc = 'Move selection down', remap = true })
vim.keymap.set('v', '<m-k>', 'dkPg.=gv', { desc = 'Move selection up', remap = true })
vim.keymap.set('n', '<m-j>', 'ddp==', { desc = 'Move line down', remap = true })
vim.keymap.set('n', '<m-k>', 'ddkP==', { desc = 'Move line up', remap = true })

-- open URLs under cursor
vim.keymap.set("n", "gx", function()
  local file = vim.fn.expand('<cfile>')
  local cmd = vim.fn.has('linux') == 1 and vim.fn.executable('xdg-open') == 1 and 'xdg-open' or 'open'
  vim.fn.system(cmd .. ' ' .. vim.fn.shellescape(file))
end)

-- Esc clears search highlighting in normal mode
vim.keymap.set('n', '<C-C>', function() vim.cmd('noh') end)
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
vim.keymap.set('n', '[l', '<cmd>lprev<cr>', { desc = 'Go to previous loclist item' })
vim.keymap.set('n', ']l', '<cmd>lnext<cr>', { desc = 'Go to next loclist item' })
vim.keymap.set('n', '[t', '<cmd>tabprev<cr>', { desc = 'Go to previous tab' })
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Go to next tab' })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({count=-1, float=true}) end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({count=1, float=true}) end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
