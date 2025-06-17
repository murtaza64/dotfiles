local function github_link(args)
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
        vim.notify('File is untracked', vim.log.levels.ERROR)
        return
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
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end

    if file_on_master and not same_as_master then
        vim.ui.select({'Use master branch','Use current commit'}, {prompt='File differs from master; choose URL:'}, function(choice)
            if choice == 'Use master branch' then
                local url = remote .. '/blob/master/' .. filename .. linepart
                vim.notify("copied " .. url)
                vim.fn.setreg('+', url)
            else
                local commit = vim.fn.system('git rev-parse HEAD')
                commit = commit:gsub('%s*$', '')
                local url = remote .. '/blob/' .. commit .. '/' .. filename .. linepart
                vim.notify("copied " .. url)
                vim.fn.setreg('+', url)
            end
        end)
        return
    end

    if committed and pushed then
        local commit = vim.fn.system('git rev-parse HEAD')
        commit = commit:gsub('%s*$', '')
        local url = remote .. '/blob/' .. commit .. '/' .. filename .. linepart
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end

    if file_on_master then
        -- skip line number if file is not committed
        vim.notify('File has uncommitted or unpushed changes, check line number', vim.log.levels.WARN)
        local url = remote .. '/blob/master/' .. filename .. linepart
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end
    
    vim.notify('File is uncommitted or unpushed and doesn\'t exist on master', vim.log.levels.ERROR)
end
vim.api.nvim_create_user_command('GithubLink', github_link, { range = true } )
vim.keymap.set({ 'n', 'v' }, '<leader>gl', ':GithubLink<CR>', { noremap = true, silent = true })
