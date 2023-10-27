vim.api.nvim_create_autocmd("BufReadPost", {
    command = 'silent! normal! g`"'
})
