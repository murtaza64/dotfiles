return {
  {
    'stevearc/oil.nvim',
    config = function(_, opts)
      -- Create namespace for oil selection extmarks
      _G.oil_selection_ns = vim.api.nvim_create_namespace('oil_selection')
      
      require('oil').setup(opts)
    end,
    opts = {
      -- cleanup_delay_ms = false,
      win_options = {
        wrap = true,
        signcolumn = "yes:2",
      },
      keymaps = {
        ["h"] = "actions.parent",
        ["l"] = "actions.select",
        ["q"] = "actions.close",
        ["gi"] = {
          callback = function()
            local oil = require("oil")
            
            -- Use global variable to track state
            local detailed = vim.g.oil_detailed_view
            
            if detailed then
              -- Switch to icon only
              oil.set_columns({ "icon" })
              vim.g.oil_detailed_view = false
            else
              -- Switch to detailed view
              oil.set_columns({ 
                { "mtime", highlight = "Special" },
                { "size", highlight = "Comment" }, 
                "icon", 
              })
              vim.g.oil_detailed_view = true
            end
          end,
          desc = "Toggle detailed file info",
        },
        ["gs"] = {
          callback = function()
            local oil = require("oil")
            
            -- Use global variable to track sort state
            local time_sort = vim.g.oil_time_sort
            
            if time_sort then
              -- Switch to type, name sort
              oil.set_sort({ { "type", "asc" }, { "name", "asc" } })
              vim.g.oil_time_sort = false
            else
              -- Switch to type, mtime, name sort
              oil.set_sort({ { "type", "asc" }, { "mtime", "desc" }, { "name", "asc" } })
              vim.g.oil_time_sort = true
            end
            
            -- Refresh extmarks after sort change
            vim.schedule(function()
              -- Add a small delay to ensure Oil has updated
              vim.defer_fn(function()
                local bufnr = vim.api.nvim_get_current_buf()
                local current_dir = oil.get_current_dir()
                local selected_files = vim.b.oil_selected_files or {}
                
                -- Clear all existing extmarks
                vim.api.nvim_buf_clear_namespace(bufnr, _G.oil_selection_ns, 0, -1)
                
                -- Re-place extmarks based on current file positions
                for line_num = 1, vim.api.nvim_buf_line_count(bufnr) do
                  local entry = oil.get_entry_on_line(bufnr, line_num)
                  if entry then
                    local filepath = current_dir .. "/" .. entry.name
                    if selected_files[filepath] then
                      vim.api.nvim_buf_set_extmark(bufnr, _G.oil_selection_ns, line_num - 1, 0, {
                        sign_text = '●',
                        sign_hl_group = 'DiagnosticSignInfo',
                        line_hl_group = 'CursorLine'
                      })
                    end
                  end
                end
              end, 50)  -- 50ms delay
            end)
          end,
          desc = "Toggle time-based sorting",
        },
        ["gd"] = {
          callback = function()
            local oil = require("oil")
            local current_dir = oil.get_current_dir()
            local filepaths = {}
            
            local mode = vim.fn.mode()
            if mode:match('[vV\22]') then
              -- Visual mode - get selection range
              local start_pos = vim.fn.getpos('v')  -- start of visual selection
              local end_pos = vim.fn.getpos('.')    -- current cursor position
              local start_line = math.min(start_pos[2], end_pos[2])
              local end_line = math.max(start_pos[2], end_pos[2])
              
              -- Get all files in the visual selection
              for line = start_line, end_line do
                local entry = oil.get_entry_on_line(0, line)
                if entry then
                  table.insert(filepaths, current_dir .. entry.name)
                end
              end
            else
              -- Normal mode - get single file under cursor
              local entry = oil.get_cursor_entry()
              if entry then
                table.insert(filepaths, current_dir .. entry.name)
              end
            end
            
            if #filepaths == 0 then return end
            
            -- Build ripdrag command with relative paths
            local cmd = "ripdrag -An -W200 -H200"
            for _, path in ipairs(filepaths) do
              cmd = cmd .. " " .. vim.fn.shellescape(path)
            end
            
            vim.fn.system(cmd)
            vim.notify(cmd)
            vim.notify("Dragging " .. #filepaths .. " file" .. (#filepaths == 1 and "" or "s"))
          end,
          desc = "Drag file(s) with ripdrag",
        },
        ["<Tab>"] = {
          callback = function()
            local oil = require("oil")
            local entry = oil.get_cursor_entry()
            if not entry then return end
            
            local bufnr = vim.api.nvim_get_current_buf()
            local current_dir = oil.get_current_dir()
            local filepath = current_dir .. "/" .. entry.name
            local line = vim.fn.line('.')
            
            -- Initialize selection state if not exists
            if not vim.b.oil_selected_files then
              vim.b.oil_selected_files = {}
            end
            
            -- Copy table, modify, then write back (vim.b limitation)
            local selected_files = vim.b.oil_selected_files
            
            -- Toggle selection
            if selected_files[filepath] then
              selected_files[filepath] = nil
              vim.b.oil_selected_files = selected_files
              -- Remove extmark
              vim.api.nvim_buf_clear_namespace(bufnr, _G.oil_selection_ns, line - 1, line)
            else
              selected_files[filepath] = true
              vim.b.oil_selected_files = selected_files
              -- Add extmark with sign and line highlight
              vim.api.nvim_buf_set_extmark(bufnr, _G.oil_selection_ns, line - 1, 0, {
                sign_text = '●',
                sign_hl_group = 'DiagnosticSignInfo',
                line_hl_group = 'CursorLine'
              })
            end
            
          end,
          desc = "Toggle file selection",
        },
      },
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, bufnr)
          return name == ".."
        end,
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "refractalize/oil-git-status.nvim",

    dependencies = {
      "stevearc/oil.nvim",
    },

    config = true,
  },
}
