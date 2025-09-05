-- Telescope picker for git-related URLs
local github_link = require('github_link')

local function git_url_picker()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    
    -- Get git remote URL and convert to HTTPS
    local remote = vim.trim(vim.fn.system('git remote get-url origin'))
    if vim.v.shell_error ~= 0 then
        vim.notify('Not in a git repository', vim.log.levels.ERROR)
        return
    end
    
    -- Convert SSH to HTTPS and remove .git suffix
    local repo_url = remote:gsub('^git@github.com:', 'https://github.com/')
                           :gsub('%.git$', '')
    
    -- Extract repo owner and name from URL
    local owner, repo_name = repo_url:match('.+/([^/]+)/([^/]+)$')
    
    local git_urls = {
        { name = "Repository", url = repo_url, desc = "Open main repository page" },
        { name = "Pull Requests", url = repo_url .. "/pulls", desc = "View pull requests" },
    }
    
    -- Add current file link if file is tracked
    local file_url = github_link.get_github_link()
    if file_url then
        table.insert(git_urls, { name = "Current File", url = file_url, desc = "View current file on GitHub" })
    end
    
    -- Add Duolingo-specific URLs if this is a Duolingo repo
    if owner == "duolingo" then
        table.insert(git_urls, { name = "Backstage", url = "https://backstage.duolingo.com/catalog/default/system/" .. repo_name, desc = "View in Backstage catalog" })
        table.insert(git_urls, { name = "Deployment Jenkins", url = "https://deployment-jenkins.duolingo.com/job/" .. repo_name .. "/", desc = "View deployment pipeline" })
    end
    
    pickers.new({}, require('telescope.themes').get_dropdown {
        prompt_title = "Git URLs",
        initial_mode = "normal",
        finder = finders.new_table {
            results = git_urls,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name .. " " .. entry.desc,
                }
            end,
        },
        -- previewer = require('telescope.previewers').new_buffer_previewer({
        --     title = "URL",
        --     define_preview = function(self, entry)
        --         vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, {
        --             entry.value.url,
        --             "",
        --             entry.value.desc
        --         })
        --     end
        -- }),
        sorter = false,
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    vim.fn.system('open "' .. selection.value.url .. '"')
                    vim.notify('Opened: ' .. selection.value.name)
                end
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command('GitUrlPicker', git_url_picker, {})
vim.keymap.set('n', '<leader>gu', git_url_picker, { noremap = true, silent = true, desc = "Git URL picker" })
