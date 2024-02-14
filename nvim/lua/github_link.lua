local function github_link()
    local filename = vim.fn.expand('%:p')
    filename = vim.trim(vim.fn.system('git ls-files --full-name -- ' .. filename))
    local line = vim.fn.line('.')
    local remote = vim.trim(vim.fn.system('git remote get-url origin'))
    -- print(filename, line)
    -- make sure file is tracked
    if filename == '' then
        vim.notify('File is untracked', vim.log.levels.ERROR)
        return
    end
    -- check if file is present on origin/master
    vim.fn.system('git show origin/master:' .. filename)
    local ret = vim.v.shell_error
    local file_on_master = true
    if ret ~= 0 then
        vim.notify('File not present on origin/master', vim.log.levels.WARN)
        file_on_master = false
    end
    -- check if current file matches origin/master
    vim.fn.system('git diff --exit-code origin/master -- ' .. filename)
    ret = vim.v.shell_error
    if ret == 0 and file_on_master then
        local url = remote .. '/blob/master/' .. filename .. '#L' .. line
        vim.notify("copied " .. url)
        -- yank url to system clipboard
        vim.fn.setreg('+', url)
    else
        if file_on_master and ret ~= 0 then
            vim.notify('File is not same as origin/master', vim.log.levels.WARN)
        end
        -- make sure file is committed
        vim.fn.system('git diff --exit-code -- ' .. filename)
        ret = vim.v.shell_error
        vim.fn.system('git diff --staged --exit-code -- ' .. filename)
        ret = ret + vim.v.shell_error
        if ret ~= 0 then
            vim.notify('File has uncommitted changes', vim.log.levels.ERROR)
            return
        end
        -- make sure current commit is pushed to origin
        vim.fn.system('git branch -r --contains HEAD')
        ret = vim.v.shell_error
        if ret ~= 0 then
            vim.notify('Current commit is not pushed to origin', vim.log.levels.ERROR)
            return
        end
        local url = remote .. '/blob/' .. vim.fn.system('git rev-parse HEAD') .. '/' .. filename .. '#L' .. line
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end
end
vim.api.nvim_create_user_command('GithubLink', github_link, {})
