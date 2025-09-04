local function claude_link(args)
    local filename = vim.fn.expand('%:p')
    
    -- Get relative path from git root or current directory
    local git_root = vim.trim(vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'))
    local relative_path
    
    if vim.v.shell_error == 0 and git_root ~= '' then
        -- We're in a git repo, use path relative to git root
        relative_path = vim.fn.fnamemodify(filename, ':s?' .. git_root .. '/??')
    else
        -- Not in git repo, use relative path from current working directory
        relative_path = vim.fn.fnamemodify(filename, ':.')
    end
    
    -- Get line range
    local start = args.line1
    local finish = args.line2
    
    local claude_ref
    if start ~= finish then
        claude_ref = '@' .. relative_path .. ':' .. start .. '-' .. finish
    else
        claude_ref = '@' .. relative_path .. ':' .. start
    end
    
    vim.fn.setreg('+', claude_ref)
    vim.notify('Copied: ' .. claude_ref)
end

vim.api.nvim_create_user_command('ClaudeLink', claude_link, { range = true })
vim.keymap.set({ 'n', 'v' }, '<leader>cl', ':ClaudeLink<CR>', { noremap = true, silent = true })