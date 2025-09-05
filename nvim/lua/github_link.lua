local function get_github_link(args)
    args = args or { line1 = vim.fn.line('.'), line2 = vim.fn.line('.'), range = 0 }
    local filename = vim.fn.expand('%:p')
    filename = vim.trim(vim.fn.system('git ls-files --full-name -- "' .. filename .. '"'))
    -- if in visual mode get range of lines
    local linepart
    local start = args.line1
    local finish = args.line2
    if start ~= finish then
        linepart = '#L' .. start .. '-L' .. finish
    else
        linepart = '#L' .. start
    end
    local remote = vim.trim(vim.fn.system('git remote get-url origin'))
    -- convert remote to https
    if remote:find('git@') == 1 then
        remote = remote:gsub('git@github.com:', 'https://github.com/')
        remote = remote:gsub('%.git', '')
    end
    -- print(filename, line)
    -- make sure file is tracked
    if filename == '' then
        return nil, 'File is untracked'
    end

    -- check if file is present on origin/master
    vim.fn.system('git show "origin/master:' .. filename .. '"')
    local ret = vim.v.shell_error
    local file_on_master = ret == 0
 
    -- check if current file matches origin/master
    vim.fn.system('git diff --exit-code origin/master -- ' .. filename)
    ret = vim.v.shell_error
    local same_as_master = ret == 0

    -- make sure file is committed
    vim.fn.system('git diff --exit-code -- ' .. filename)
    ret = vim.v.shell_error
    vim.fn.system('git diff --staged --exit-code -- ' .. filename)
    ret = ret + vim.v.shell_error
    local committed = ret == 0

    -- check if current commit is pushed to origin
    local branch = vim.trim(vim.fn.system('git branch -r --contains HEAD'))
    local pushed = branch ~= ''

    if file_on_master and same_as_master then
        local url = remote .. '/blob/master/' .. filename .. linepart
        return url
    end

    if file_on_master and not same_as_master then
        -- For non-interactive use, default to master branch
        local url = remote .. '/blob/master/' .. filename .. linepart
        return url, 'File differs from master'
    end

    if committed and pushed then
        local commit = vim.fn.system('git rev-parse HEAD')
        commit = commit:gsub('%s*$', '')
        local url = remote .. '/blob/' .. commit .. '/' .. filename .. linepart
        return url
    end

    if file_on_master then
        -- skip line number if file is not committed
        local url = remote .. '/blob/master/' .. filename .. linepart
        return url, 'File has uncommitted or unpushed changes, check line number'
    end
    
    return nil, 'File is uncommitted or unpushed and doesn\'t exist on master'
end

local function github_link(args)
    local url, warning = get_github_link(args)
    
    if not url then
        vim.notify(warning, vim.log.levels.ERROR)
        return
    end
    
    if warning then
        if warning:match('differs from master') then
            vim.ui.select({'Use master branch','Use current commit'}, {prompt='File differs from master; choose URL:'}, function(choice)
                if choice == 'Use master branch' then
                    vim.notify("copied " .. url)
                    vim.fn.setreg('+', url)
                else
                    local commit = vim.fn.system('git rev-parse HEAD')
                    commit = commit:gsub('%s*$', '')
                    local filename = vim.fn.expand('%:p')
                    filename = vim.trim(vim.fn.system('git ls-files --full-name -- "' .. filename .. '"'))
                    local start = args.line1
                    local finish = args.line2
                    local linepart = start ~= finish and ('#L' .. start .. '-L' .. finish) or ('#L' .. start)
                    local remote = vim.trim(vim.fn.system('git remote get-url origin'))
                    if remote:find('git@') == 1 then
                        remote = remote:gsub('git@github.com:', 'https://github.com/')
                        remote = remote:gsub('%.git', '')
                    end
                    local commit_url = remote .. '/blob/' .. commit .. '/' .. filename .. linepart
                    vim.notify("copied " .. commit_url)
                    vim.fn.setreg('+', commit_url)
                end
            end)
            return
        else
            vim.notify(warning, vim.log.levels.WARN)
        end
    end
    
    vim.notify("copied " .. url)
    vim.fn.setreg('+', url)
end
vim.api.nvim_create_user_command('GithubLink', github_link, { range = true } )
vim.keymap.set({ 'n', 'v' }, '<leader>gl', ':GithubLink<CR>', { noremap = true, silent = true })

-- Export for other modules
return {
    get_github_link = get_github_link
}
