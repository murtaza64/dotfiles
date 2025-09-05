-- Claude tmux abstractions
local function claude_window_exists()
    local result = vim.system({'bash', '-c', 'tmux list-windows -F "#{window_name}" | grep -q "^claude$"'}):wait()
    return result.code == 0
end

local function create_claude_window()
    vim.system({'tmux', 'new-window', '-a', '-n', 'claude'}):wait()
    vim.system({'tmux', 'send-keys', '-t', 'claude', 'claude', 'Enter'}):wait()
end

local function send_to_claude(message)
    if not claude_window_exists() then
        create_claude_window()
    end
    
    vim.system({'tmux', 'set-buffer', '-b', 'nvim-claude', message}):wait()
    vim.system({'tmux', 'select-window', '-t', 'claude'}):wait()
    vim.system({'tmux', 'send-keys', '-t', 'claude', 'Escape', 'a'}):wait()
    vim.system({'tmux', 'paste-buffer', '-b', 'nvim-claude', '-t', 'claude'}):wait()
end

local function get_relative_path()
    local filename = vim.fn.expand('%:p')
    local git_root = vim.trim(vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'))
    
    if vim.v.shell_error == 0 and git_root ~= '' then
        return vim.fn.fnamemodify(filename, ':s?' .. git_root .. '/??')
    else
        return vim.fn.fnamemodify(filename, ':.')
    end
end

local function get_selection_info()
    local mode = vim.fn.mode()
    if mode:match('[vV\22]') then
        -- Currently in visual mode - get current selection
        local start_pos = vim.fn.getpos('v')  -- start of visual selection
        local end_pos = vim.fn.getpos('.')    -- current cursor position
        local start_line = math.min(start_pos[2], end_pos[2])
        local end_line = math.max(start_pos[2], end_pos[2])
        local start_col = math.min(start_pos[3], end_pos[3])
        local end_col = math.max(start_pos[3], end_pos[3])
        return {
            start_line = start_line,
            end_line = end_line,
            start_col = start_col,
            end_col = end_col,
            mode = mode
        }
    else
        -- Not in visual mode - use current line
        local current_line = vim.fn.line('.')
        return {
            start_line = current_line,
            end_line = current_line,
            start_col = 1,
            end_col = vim.fn.col('$'),
            mode = 'n'
        }
    end
end

local function get_code_reference()
    local relative_path = get_relative_path()
    local sel = get_selection_info()
    
    if sel.start_line ~= sel.end_line then
        return '@' .. relative_path .. ':' .. sel.start_line .. '-' .. sel.end_line
    elseif sel.mode:match('[vV\22]') then
        return '@' .. relative_path .. ':' .. sel.start_line
    else
        return '@' .. relative_path
    end
end

local function claude_explain(sel_info)
    local relative_path = get_relative_path()
    local sel = sel_info or get_selection_info()
    local lines = vim.fn.getline(sel.start_line, sel.end_line)
    local code = table.concat(lines, '\n')
    
    local prompt = string.format("Explain this code from %s:\n\n```\n%s\n```", relative_path, code)
    
    send_to_claude(prompt)
    vim.notify('Sent code to claude for explanation')
end

local function claude_inline_test(sel_info)
    local sel = sel_info or get_selection_info()
    local relative_path = get_relative_path()
    
    local code_ref
    if sel.start_line ~= sel.end_line then
        code_ref = '@' .. relative_path .. ':' .. sel.start_line .. '-' .. sel.end_line
    elseif sel.mode:match('[vV\22]') then
        code_ref = '@' .. relative_path .. ':' .. sel.start_line
    else
        code_ref = '@' .. relative_path
    end
    
    local prompt = string.format("/inline-test %s", code_ref)
    
    send_to_claude(prompt)
    vim.notify('Sent code reference to claude for inline test: ' .. code_ref)
end

local function claude_send_code_ref(sel_info)
    local sel = sel_info or get_selection_info()
    local relative_path = get_relative_path()
    
    local code_ref
    if sel.start_line ~= sel.end_line then
        code_ref = '@' .. relative_path .. ':' .. sel.start_line .. '-' .. sel.end_line
    elseif sel.mode:match('[vV\22]') then
        code_ref = '@' .. relative_path .. ':' .. sel.start_line
    else
        code_ref = '@' .. relative_path
    end
    
    send_to_claude(code_ref .. ' ')
    vim.notify('Sent to claude: ' .. code_ref)
end

local function claude_send_code_inline(sel_info)
    local sel = sel_info or get_selection_info()
    local code
    
    if sel.mode == 'v' and sel.start_line == sel.end_line then
        -- Character-wise visual selection on single line
        local line = vim.fn.getline(sel.start_line)
        code = string.sub(line, sel.start_col, sel.end_col)
    else
        -- Line-wise or multi-line selection
        local lines = vim.fn.getline(sel.start_line, sel.end_line)
        code = table.concat(lines, '\n')
        
        -- Trim leading whitespace for single line in normal mode
        if sel.mode == 'n' and sel.start_line == sel.end_line then
            code = code:match('^%s*(.-)%s*$') or code  -- Trim leading and trailing whitespace
        end
    end
    
    local message
    local line_count = sel.end_line - sel.start_line + 1
    if line_count <= 1 and #code < 80 then
        -- Single line or short text - use inline backticks
        message = '`' .. code .. '`'
    else
        -- Multiple lines or long text - use fenced code block
        message = '\n```\n' .. code .. '\n``` \n'
    end
    
    send_to_claude(message)
    vim.notify('Sent code inline to claude (' .. line_count .. ' line' .. (line_count == 1 and '' or 's') .. ')')
end

-- Telescope picker for Claude actions  
local function claude_picker(args)
    -- Capture selection info before opening picker
    local captured_selection = get_selection_info()
    
    -- If in visual mode, exit it properly to set the '< and '> marks
    if captured_selection.mode:match('[vV\22]') then
        vim.cmd('normal! \27')  -- ESC to exit visual mode
    end
    
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    
    local claude_actions = {
        { name = "Send Code Ref", desc = "Send file/line reference to Claude", func = claude_send_code_ref },
        { name = "Send Code Inline", desc = "Send actual code to Claude", func = claude_send_code_inline },
        { name = "Explain Code", desc = "Ask Claude to explain selected code", func = claude_explain },
        { name = "Inline Test", desc = "Generate and run inline test for code", func = claude_inline_test },
    }
    
    pickers.new({}, require('telescope.themes').get_cursor {
        prompt_title = "Claude Actions",
        layout_config = { width = 30 },
        initial_mode = "normal",
        finder = finders.new_table {
            results = claude_actions,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name .. " " .. entry.desc,
                }
            end,
        },
        sorter = false,
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    -- Pass captured selection info to the action
                    selection.value.func(captured_selection)
                    
                    -- Reactivate visual selection if it was originally visual mode
                    if captured_selection.mode:match('[vV\22]') then
                        vim.schedule(function()
                            vim.cmd('normal! gv')
                        end)
                    end
                end
            end)
            return true
        end,
    }):find()
end

vim.keymap.set({ 'n', 'v' }, '<leader>cl', claude_send_code_ref, { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>ci', claude_send_code_inline, { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>cc', claude_picker, { noremap = true, silent = true, desc = "Claude actions picker" })
