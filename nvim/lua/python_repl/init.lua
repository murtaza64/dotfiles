local M = {}

-- Plugin state
local state = {
  active = false,
  code_bufnr = nil,
  output_bufnr = nil,
  code_winnr = nil,
  output_winnr = nil,
  autocmd_group = nil,
  update_timer = nil,
  last_code_hash = nil,
  output_filename = nil,
  output_saved_and_quit = false,
  stdin_data = nil,
}

-- Create executable temp script from code
local function create_temp_script(code)
  local temp_script = vim.fn.tempname()
  local code_lines = vim.split(code, '\n', { plain = true })
  vim.fn.writefile(code_lines, temp_script)
  vim.fn.system('chmod +x ' .. vim.fn.shellescape(temp_script))
  return temp_script
end

-- Execute code by saving to temp file and running with interpreter
local function execute_code(code, callback, stdin_data)
  local temp_script = create_temp_script(code)
  
  local opts = { text = true }
  if stdin_data then
    opts.stdin = stdin_data
  end
  
  -- Execute the temp file, which will respect shebang
  vim.system({temp_script}, opts, function(result)
    vim.schedule(function()
      -- Clean up temp file
      vim.fn.delete(temp_script)
      
      local output
      if result.code ~= 0 then
        output = "Error: " .. (result.stderr or result.stdout or "Unknown error")
      else
        output = result.stdout or ""
      end
      callback(output)
    end)
  end)
end


-- Update output buffer with code execution
local function update_output()
  if not state.active or not state.code_bufnr or not state.output_bufnr then
    return
  end
  
  -- Check if buffers are still valid before accessing them
  if not vim.api.nvim_buf_is_valid(state.code_bufnr) or not vim.api.nvim_buf_is_valid(state.output_bufnr) then
    return
  end
  
  -- Recreate output window if it doesn't exist (preview window may have been closed)
  if not state.output_winnr or not vim.api.nvim_win_is_valid(state.output_winnr) then
    create_output_window()
  end
  
  local code_lines = vim.api.nvim_buf_get_lines(state.code_bufnr, 0, -1, false)
  local code = table.concat(code_lines, '\n')
  
  -- Check if code has actually changed to avoid unnecessary updates
  local code_hash = vim.fn.sha256(code)
  if state.last_code_hash == code_hash then
    return
  end
  state.last_code_hash = code_hash
  
  -- Make buffer modifiable temporarily
  vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', true)
  
  -- Show "Running..." while executing
  vim.api.nvim_buf_set_lines(state.output_bufnr, 0, -1, false, {"-- Running script... --"})
  vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', false)
  
  execute_code(code, function(output)
    -- Check if buffers are still valid (user might have closed REPL)
    if not state.output_bufnr or not vim.api.nvim_buf_is_valid(state.output_bufnr) then
      return
    end
    
    -- Make buffer modifiable temporarily
    vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', true)
    
    local output_lines = vim.split(output, '\n', { plain = true })
    
    -- Remove empty last line if present
    if output_lines[#output_lines] == "" then
      table.remove(output_lines)
    end
    
    vim.api.nvim_buf_set_lines(state.output_bufnr, 0, -1, false, output_lines)
    
    -- Make buffer non-modifiable again
    if not state.output_filename then
      vim.api.nvim_buf_set_option(state.output_bufnr, 'modifiable', false)
    end
  end, state.stdin_data)
end

-- Debounced update function
local function debounced_update()
  if state.update_timer then
    vim.fn.timer_stop(state.update_timer)
  end
  
  state.update_timer = vim.fn.timer_start(0, function()  -- TODO: is 0 ok?
    vim.schedule(update_output)
    state.update_timer = nil
  end)
end

-- Handle quit logic with appropriate force behavior for stdin mode
local function handle_quit_logic()
  local ok = pcall(vim.cmd.bprev)
  if not ok then
    if state.output_filename then
      -- In stdin mode, force close to avoid "no write since last change" errors
      vim.cmd('quit!')
    else
      vim.cmd.quit()
    end
  end
end

-- Create code buffer with specified options
local function create_code_buffer(buffer_opts)
  buffer_opts = buffer_opts or {}
  local code_buf = vim.api.nvim_create_buf(buffer_opts.listed or true, false)
  
  if buffer_opts.name then
    vim.api.nvim_buf_set_name(code_buf, buffer_opts.name)
  end

  vim.api.nvim_buf_set_option(code_buf, 'filetype', buffer_opts.filetype or 'python')
  vim.api.nvim_buf_set_option(code_buf, 'buftype', buffer_opts.buftype or 'nofile')
  
  if buffer_opts.buftype == 'nofile' then
    vim.api.nvim_buf_set_option(code_buf, 'bufhidden', 'wipe')
  end
  return code_buf
end

-- Create or recreate the output preview window
local function create_output_window()
  -- Save current window
  local orig_win = vim.api.nvim_get_current_win()
  
  -- Go to code window first if it exists
  if state.code_winnr and vim.api.nvim_win_is_valid(state.code_winnr) then
    vim.api.nvim_set_current_win(state.code_winnr)
  end
  
  vim.cmd('vsplit')
  local output_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(output_win, state.output_bufnr)
  
  -- Set as preview window if in stdin mode
  if state.output_filename then
    vim.api.nvim_set_option_value("previewwindow", true, { scope = "local", win = output_win })
  end
  
  state.output_winnr = output_win
  
  -- Go back to original window
  if vim.api.nvim_win_is_valid(orig_win) then
    vim.api.nvim_set_current_win(orig_win)
  end
  
  return output_win
end

-- Create the split layout
local function create_split(existing_buffer)
  local current_win = vim.api.nvim_get_current_win()
  local code_buf
  
  if existing_buffer then
    -- Use existing buffer (for when called on a .py file)
    code_buf = existing_buffer
  else
    -- Create horizontal split first
    -- vim.cmd('vsplit')
    
    -- Create new scratch buffer for code
    code_buf = create_code_buffer({
      filetype = 'python',
      buftype = 'nofile'
    })
    vim.api.nvim_win_set_buf(current_win, code_buf)
  end
  
  -- If we don't have a split yet (existing buffer case), create one
  if existing_buffer then
    -- vim.cmd('vsplit')
  end
  
  -- Create output buffer in the right split (always scratch buffer)
  local output_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(output_buf, 'filetype', 'text')
  vim.api.nvim_buf_set_option(output_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(output_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(output_buf, 'modifiable', false)
  
  -- Store references
  state.code_bufnr = code_buf
  state.output_bufnr = output_buf
  state.code_winnr = current_win
  
  -- Create output window using helper
  create_output_window()
  
  -- Go back to code buffer
  vim.api.nvim_set_current_win(current_win)
  
  return code_buf, output_buf
end

-- Convert scratch buffer to real file buffer
local function convert_to_file_buffer(bufnr, filename)
  -- Save current content
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  
  -- Reset buffer options to make it a normal file buffer
  vim.api.nvim_buf_set_option(bufnr, 'buftype', '')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', '')
  
  -- Set the filename
  vim.api.nvim_buf_set_name(bufnr, filename)
  
  -- Restore content and mark as modified
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(bufnr, 'modified', true)
end

-- Setup autocmds for live updates
local function setup_autocmds()
  if state.autocmd_group then
    vim.api.nvim_del_augroup_by_id(state.autocmd_group)
  end
  
  state.autocmd_group = vim.api.nvim_create_augroup('PythonRepl', { clear = true })
  
  vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
    group = state.autocmd_group,
    buffer = state.code_bufnr,
    callback = function()
      -- Only update if not in insert mode
      local mode = vim.api.nvim_get_mode().mode
      if mode ~= 'i' and mode ~= 'R' then
        debounced_update()
      end
    end,
  })
  
  -- Update output when entering normal mode (after finishing editing)
  vim.api.nvim_create_autocmd('ModeChanged', {
    group = state.autocmd_group,
    pattern = '*:n',
    callback = function()
      -- Only update if we're in the Python buffer
      if vim.api.nvim_get_current_buf() == state.code_bufnr then
        debounced_update()
      end
    end,
  })
  
  -- Handle buffer write for code buffer - different behavior based on buffer type
  vim.api.nvim_create_autocmd('BufWriteCmd', {
    group = state.autocmd_group,
    buffer = state.code_bufnr,
    callback = function()
      local buftype = vim.api.nvim_buf_get_option(state.code_bufnr, 'buftype')
      
      if buftype == 'acwrite' and state.output_filename then
        -- This is stdin mode - execute script and write output to temp file
        local code_lines = vim.api.nvim_buf_get_lines(state.code_bufnr, 0, -1, false)
        local code = table.concat(code_lines, '\n')
        
        -- Execute code synchronously for write operation
        local temp_script = create_temp_script(code)
        
        local opts = { text = true }
        if state.stdin_data then
          opts.stdin = state.stdin_data
        end
        local result = vim.system({temp_script}, opts):wait()
        
        -- Clean up temp file
        vim.fn.delete(temp_script)
        
        local output
        if result.code ~= 0 then
          output = "Error: " .. (result.stderr or result.stdout or "Unknown error")
        else
          output = result.stdout or ""
        end
        
        -- Write output to the temp file
        local output_lines = vim.split(output, '\n', { plain = true })
        vim.fn.writefile(output_lines, state.output_filename)
        
        -- Mark both buffers as not modified (they work as a unit in stdin mode)
        vim.api.nvim_buf_set_option(state.code_bufnr, 'modified', false)
        if vim.api.nvim_buf_is_valid(state.output_bufnr) then
          vim.api.nvim_buf_set_option(state.output_bufnr, 'modified', false)
        end
        
      elseif buftype == 'nofile' then
        -- This is a scratch buffer being written to a file
        local filename = vim.fn.expand('<afile>')
        convert_to_file_buffer(state.code_bufnr, filename)
        
        -- Now that it's a real file buffer, just write it normally
        vim.cmd('write')
        
        -- Remove this autocmd since we're now a real file
        vim.api.nvim_clear_autocmds({
          group = state.autocmd_group,
          event = 'BufWriteCmd',
          buffer = state.code_bufnr,
        })
      end
    end,
  })
  
  -- Handle buffer write for output buffer (in stdin mode only)
  vim.api.nvim_create_autocmd('BufWriteCmd', {
    group = state.autocmd_group,
    buffer = state.output_bufnr,
    callback = function()
      if state.output_filename then
        -- Write output buffer contents directly to temp file
        local output_lines = vim.api.nvim_buf_get_lines(state.output_bufnr, 0, -1, false)
        vim.fn.writefile(output_lines, state.output_filename)
        
        -- Mark both buffers as not modified (they work as a unit in stdin mode)
        vim.api.nvim_buf_set_option(state.output_bufnr, 'modified', false)
        if vim.api.nvim_buf_is_valid(state.code_bufnr) then
          vim.api.nvim_buf_set_option(state.code_bufnr, 'modified', false)
        end
        
      end
    end,
  })
  
  -- Combined logic for entering Python buffer (reopen output window)
  vim.api.nvim_create_autocmd('BufEnter', {
    group = state.autocmd_group,
    pattern = '*',
    callback = function()
      local current_buf = vim.api.nvim_get_current_buf()
      
      -- Only run if we have an active REPL
      if not state.active or not state.code_bufnr then
        return
      end
      
      -- Check if we're entering one of our REPL buffers
      if current_buf == state.code_bufnr then
        -- Update code window reference
        state.code_winnr = vim.api.nvim_get_current_win()
        
        -- Check if output window was saved and quit - if so, close code window too
        if state.output_saved_and_quit then
          handle_quit_logic()
          return
        end
        
      elseif current_buf == state.output_bufnr then
        -- Update output window reference
        state.output_winnr = vim.api.nvim_get_current_win()
        
      else
        -- Check if code window/buffer is still valid
        local code_win_valid = state.code_winnr and vim.api.nvim_win_is_valid(state.code_winnr)
        local code_buf_valid = state.code_bufnr and vim.api.nvim_buf_is_valid(state.code_bufnr)
        
        -- Only trigger quit logic if code window/buffer is gone (not just output window)
        if not code_win_valid or not code_buf_valid then
          handle_quit_logic()
        end
      end
    end,
  })
  
  -- Handle window closing (especially for stdin mode unsaved buffer recovery)
  vim.api.nvim_create_autocmd('WinClosed', {
    group = state.autocmd_group,
    callback = function(event)
      local closed_winid = tonumber(event.match)
      
      -- Check if it was one of our REPL windows
      if closed_winid == state.code_winnr then
        state.code_winnr = nil
        
      elseif closed_winid == state.output_winnr then
        -- Check if output buffer was saved (not modified) - indicates :wq intent
        if state.output_bufnr and vim.api.nvim_buf_is_valid(state.output_bufnr) then
          local is_modified = vim.api.nvim_buf_get_option(state.output_bufnr, 'modified')
          if not is_modified then
            state.output_saved_and_quit = true
          end
        end
        
        state.output_winnr = nil
      end
    end,
  })
  
  -- Clean up when buffers are deleted
  vim.api.nvim_create_autocmd('BufDelete', {
    group = state.autocmd_group,
    buffer = state.code_bufnr,
    callback = function()
      M.stop()
    end,
  })
end

-- Load template from file
local function load_template(template_name, substitutions)
  substitutions = substitutions or {}
  
  -- Get the directory where this script is located
  local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
  local template_path = plugin_dir .. "/templates/" .. template_name
  
  
  if vim.fn.filereadable(template_path) == 0 then
    return {"# Error loading template" .. template_path}
  end
  
  local template_content = vim.fn.readfile(template_path)
  
  -- Apply substitutions
  for i, line in ipairs(template_content) do
    for key, value in pairs(substitutions) do
      template_content[i] = line:gsub("{" .. key .. "}", value)
    end
  end
  
  return template_content
end

-- Check if current buffer is a Python file
local function is_python_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  return filetype == 'python'
end

-- Start the Python REPL
function M.start()
  if state.active then
    print("Python REPL already active")
    return
  end
  
  local current_buf = vim.api.nvim_get_current_buf()
  local use_current_buffer = is_python_buffer(current_buf)
  
  if use_current_buffer then
    -- Use current Python file
    create_split(current_buf)
  else
    -- Create new scratch buffer
    create_split()
    
    -- Load default template for scratch buffers
    local template_lines = load_template("default.py")
    vim.api.nvim_buf_set_lines(state.code_bufnr, 0, -1, false, template_lines)
    
    -- Move cursor to end of buffer
    vim.api.nvim_win_set_cursor(state.code_winnr, {#template_lines, 0})
  end
  
  setup_autocmds()
  state.active = true
  
  -- Initial update
  update_output()
  
  if use_current_buffer then
    print("Python REPL started with current file")
  else
    print("Python REPL started with scratch buffer")
  end
end

-- Start the Python REPL in text processing mode
function M.process_text(filename)
  if state.active then
    print("Python REPL already active")
    return
  end
  
  if not filename or filename == "" then
    print("Error: filename required for PythonReplProcessText")
    return
  end
  
  -- Check if file exists
  if vim.fn.filereadable(filename) == 0 then
    print("Error: file '" .. filename .. "' not found or not readable")
    return
  end
  
  -- Create new scratch buffer
  create_split()
  
  -- Load text processing template with filename substitution
  local template_lines = load_template("process_text", { filename = filename })
  vim.api.nvim_buf_set_lines(state.code_bufnr, 0, -1, false, template_lines)
  
  -- Move cursor to end of buffer
  vim.api.nvim_win_set_cursor(state.code_winnr, {#template_lines, 0})
  
  setup_autocmds()
  state.active = true
  
  -- Initial update
  update_output()
  
  print("Python REPL started in text processing mode for: " .. filename)
end

-- Start the Python REPL in stdin processing mode (for shell pipelines)
function M.process_stdin(args)
  if state.active then
    print("Python REPL already active")
    return
  end
  
  -- Parse arguments: input_file [output_file] [template]
  local parts = vim.split(args, " ", { plain = true })
  local input_filename = parts[1]
  local output_filename = parts[2]
  local template_name = parts[3] or "python"
  
  if not input_filename or input_filename == "" then
    print("Error: input filename required for PythonReplProcessStdin")
    return
  end
  
  -- Check if input file exists
  if vim.fn.filereadable(input_filename) == 0 then
    print("Error: file '" .. input_filename .. "' not found or not readable")
    return
  end
  
  -- Store output filename and read stdin data
  state.output_filename = output_filename
  state.stdin_data = vim.fn.readfile(input_filename, '')
  -- state.stdin_data = table.concat(state.stdin_data, '\n')
  
  -- Create split with special handling for stdin mode
  local current_win = vim.api.nvim_get_current_win()
  
  -- Create horizontal split first
  vim.cmd('vsplit')
  
  -- Create new real buffer for script code (using acwrite)
  local bufname = 'nvim-python-repl://script'
  if template_name == "python" then
    bufname = './nvim-repl-fake-script.py'
  end
  -- vim.lsp.disable("basedpyright")
  local code_buf = create_code_buffer({
    listed = false,
    filetype = template_name,
    buftype = 'acwrite',
    name = bufname,
  })
  if template_name == "python" then
    -- Start LSP for Python buffer
    vim.cmd("LspStart basedpyright")
  end
  vim.api.nvim_win_set_buf(current_win, code_buf)
  
  -- Create output buffer in the right split (editable in stdin mode)
  local output_win = vim.api.nvim_get_current_win()
  local output_buf = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_option(output_buf, 'filetype', 'text')
  vim.api.nvim_buf_set_option(output_buf, 'buftype', 'acwrite')
  vim.api.nvim_buf_set_name(output_buf, 'nvim-python-repl://output')
  vim.api.nvim_buf_set_option(output_buf, 'modifiable', true)
  vim.api.nvim_win_set_buf(output_win, output_buf)
  
  -- Set as preview window to get proper vim quit behavior
  vim.api.nvim_set_option_value("previewwindow", true, { scope = "local", win = output_win })
  
  -- Store references
  state.code_bufnr = code_buf
  state.output_bufnr = output_buf
  state.code_winnr = current_win
  state.output_winnr = output_win
  
  
  -- Go back to code buffer
  vim.api.nvim_set_current_win(current_win)
  
  -- Load specified template
  local template_lines = load_template(template_name)
  vim.api.nvim_buf_set_lines(state.code_bufnr, 0, -1, false, template_lines)
  
  -- Move cursor to end of buffer
  vim.api.nvim_win_set_cursor(state.code_winnr, {#template_lines, 0})
  
  setup_autocmds()
  state.active = true
  
  -- Initial update
  update_output()
  
  -- Mark the Python buffer as modified so user can't quit without writing
  vim.api.nvim_buf_set_option(state.code_bufnr, 'modified', true)
  
  -- Delete the default buffer (buffer 1) to clean up workspace
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(1) and vim.api.nvim_buf_get_name(1) == "" then
      -- Only delete if it's an empty unnamed buffer
      local lines = vim.api.nvim_buf_get_lines(1, 0, -1, false)
      if #lines <= 1 and (lines[1] == "" or lines[1] == nil) then
        pcall(vim.api.nvim_buf_delete, 1, { force = true })
      end
    end
  end, 100)  -- Small delay to ensure everything is set up
  
  -- print("Python REPL started in stdin processing mode for: " .. filename)
end

-- Stop the Python REPL
function M.stop()
  if not state.active then
    print("Python REPL not active")
    return
  end
  
  -- Clean up timer
  if state.update_timer then
    vim.fn.timer_stop(state.update_timer)
    state.update_timer = nil
  end
  
  -- Clean up autocmds
  if state.autocmd_group then
    vim.api.nvim_del_augroup_by_id(state.autocmd_group)
    state.autocmd_group = nil
  end
  
  -- Close output buffer/window if it exists
  if state.output_bufnr and vim.api.nvim_buf_is_valid(state.output_bufnr) then
    if state.output_winnr and vim.api.nvim_win_is_valid(state.output_winnr) then
      vim.api.nvim_win_close(state.output_winnr, false)
    end
    vim.api.nvim_buf_delete(state.output_bufnr, { force = true })
  end
  
  -- Reset state
  state.active = false
  state.code_bufnr = nil
  state.output_bufnr = nil
  state.code_winnr = nil
  state.output_winnr = nil
  state.last_code_hash = nil
  state.output_filename = nil
  state.output_saved_and_quit = false
  state.stdin_data = nil
  
  print("Python REPL stopped")
end

-- Toggle the Python REPL
function M.toggle()
  if state.active then
    M.stop()
  else
    M.start()
  end
end

function M.test_python_lsp()
  local code_buf = vim.api.nvim_create_buf(true, false)  -- listed, scratch
  -- vim.cmd.edit("nvim-repl-fake-script.py")
  vim.api.nvim_buf_set_name(code_buf, '~/dotfiles/nvim-repl-fake-script.py')
  vim.api.nvim_buf_set_option(code_buf, 'filetype', 'python')
  vim.cmd("LspStart basedpyright")
  -- vim.api.nvim_buf_set_option(code_buf, 'buftype', 'acwrite')
  vim.api.nvim_win_set_buf(0, code_buf)
end
-- Setup function
function M.setup(opts)
  opts = opts or {}
  
  -- Create user commands
  vim.api.nvim_create_user_command('PythonReplStart', M.start, {})
  vim.api.nvim_create_user_command('PythonReplStop', M.stop, {})
  vim.api.nvim_create_user_command('PythonReplToggle', M.toggle, {})
  vim.api.nvim_create_user_command('PythonReplTestLsp', M.test_python_lsp, {})
  vim.api.nvim_create_user_command('PythonReplProcessText', function(opts)
    M.process_text(opts.args)
  end, {
    nargs = 1,
    desc = 'Start Python REPL in text processing mode',
    complete = 'file',
  })
  vim.api.nvim_create_user_command('PythonReplProcessStdin', function(opts)
    M.process_stdin(opts.args)
  end, {
    nargs = 1,
    desc = 'Start Python REPL in stdin processing mode for shell pipelines',
    complete = 'file',
  })
  
  -- Optional key mapping
  if opts.keymap then
    vim.keymap.set('n', opts.keymap, M.toggle, { desc = 'Toggle Python REPL' })
  end
end

return M
