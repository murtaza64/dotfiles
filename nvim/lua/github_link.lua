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
        local url = remote .. '/blob/master/' .. filename .. '#L' .. line
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end

    if committed and pushed then
        local url = remote .. '/blob/' .. vim.fn.system('git rev-parse HEAD') .. '/' .. filename .. '#L' .. line
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end

    if file_on_master then
        -- skip line number if file is not committed
        local url = remote .. '/blob/master/' .. filename
        vim.notify("copied " .. url)
        vim.fn.setreg('+', url)
        return
    end
    
    vim.notify('File is uncommitted or unpushed and doesn\'t exist on master', vim.log.levels.ERROR)
end
vim.api.nvim_create_user_command('GithubLink', github_link, {})
