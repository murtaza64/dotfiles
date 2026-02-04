local M = {}

local git = require("modaldiff.git")

local augroup = vim.api.nvim_create_augroup("modaldiff", { clear = false })

---@type table<integer, table>
local state_by_tab = {}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function clamp_cursor(bufnr, cursor)
  local line = cursor[1]
  local col = cursor[2]
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  if line < 1 then
    line = 1
  elseif line > line_count then
    line = line_count
  end
  local txt = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
  local maxcol = #txt
  if col < 0 then
    col = 0
  elseif col > maxcol then
    col = maxcol
  end
  return { line, col }
end

local function diffoff_win(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return
  end
  local cur = vim.api.nvim_get_current_win()
  pcall(vim.api.nvim_set_current_win, win)
  pcall(vim.cmd, "diffoff")
  pcall(vim.api.nvim_set_current_win, cur)
end

local function cleanup(tab)
  local st = state_by_tab[tab]
  if not st then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)

  diffoff_win(st.scratch_win)
  diffoff_win(st.orig_win)

  if st.winopts then
    for win, opts in pairs(st.winopts) do
      if win and vim.api.nvim_win_is_valid(win) then
        for k, v in pairs(opts) do
          pcall(vim.api.nvim_set_option_value, k, v, { scope = "local", win = win })
        end
      end
    end
  end

  if st.scratch_win and vim.api.nvim_win_is_valid(st.scratch_win) then
    pcall(vim.api.nvim_win_close, st.scratch_win, true)
  end

  if st.orig_win and vim.api.nvim_win_is_valid(st.orig_win) then
    pcall(vim.api.nvim_set_current_win, st.orig_win)
    if st.orig_buf and vim.api.nvim_buf_is_valid(st.orig_buf) then
      cursor = clamp_cursor(st.orig_buf, cursor)
      pcall(vim.api.nvim_win_set_cursor, st.orig_win, cursor)
    end
  end

  if st.autocmd_ids then
    for _, id in ipairs(st.autocmd_ids) do
      pcall(vim.api.nvim_del_autocmd, id)
    end
  end

  state_by_tab[tab] = nil
end

local function snapshot_winopts(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return nil
  end
  return {
    foldenable = vim.api.nvim_get_option_value("foldenable", { scope = "local", win = win }),
    foldmethod = vim.api.nvim_get_option_value("foldmethod", { scope = "local", win = win }),
    foldlevel = vim.api.nvim_get_option_value("foldlevel", { scope = "local", win = win }),
  }
end

local function show_whole_file(win)
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return
  end
  -- In diff mode, Vim may fold unchanged sections (typically via foldmethod=diff).
  -- Keep folding mechanics intact, but force everything open.
  pcall(vim.api.nvim_set_option_value, "foldenable", true, { scope = "local", win = win })
  pcall(vim.api.nvim_set_option_value, "foldlevel", 99, { scope = "local", win = win })
  pcall(vim.api.nvim_set_option_value, "foldlevelstart", 99, { scope = "local", win = win })

  local cur = vim.api.nvim_get_current_win()
  pcall(vim.api.nvim_set_current_win, win)
  pcall(vim.cmd, "normal! zR")
  pcall(vim.api.nvim_set_current_win, cur)
end

local function setup_autocmds(tab, st)
  st.autocmd_ids = st.autocmd_ids or {}

  local function on_win_closed(args)
    local closed = tonumber(args.match)
    if not closed then
      return
    end
    local cur = state_by_tab[tab]
    if not cur then
      return
    end
    if closed == cur.scratch_win or closed == cur.orig_win then
      cleanup(tab)
    end
  end

  table.insert(st.autocmd_ids, vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = on_win_closed,
  }))
end

local function open_head_left(st)
  local orig_win = st.orig_win
  local orig_buf = st.orig_buf

  local file = vim.api.nvim_buf_get_name(orig_buf)
  if file == "" then
    return nil, "Current buffer is not a file"
  end

  local root, err = git.git_root(file)
  if not root then
    return nil, err ~= "" and err or "Not a git repo"
  end

  local rel = git.relpath(file, root)
  local head_lines, err2 = git.show_head(root, rel)
  if not head_lines then
    return nil, err2 ~= "" and err2 or "File not found at HEAD"
  end

  local ft = vim.bo[orig_buf].filetype

  local scratch = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(scratch, "[ModalDiff HEAD] " .. rel)
  vim.bo[scratch].buftype = "nofile"
  vim.bo[scratch].bufhidden = "wipe"
  vim.bo[scratch].swapfile = false
  vim.bo[scratch].modifiable = true
  vim.bo[scratch].readonly = true
  vim.bo[scratch].filetype = ft
  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, head_lines)
  vim.bo[scratch].modifiable = false

  vim.api.nvim_set_current_win(orig_win)
  vim.cmd("leftabove vsplit")
  local scratch_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(scratch_win, scratch)

  st.scratch_buf = scratch
  st.scratch_win = scratch_win

  st.winopts = st.winopts or {}
  st.winopts[orig_win] = snapshot_winopts(orig_win)
  st.winopts[scratch_win] = snapshot_winopts(scratch_win)

  vim.api.nvim_set_current_win(scratch_win)
  vim.cmd("diffthis")
  vim.api.nvim_set_current_win(orig_win)
  vim.cmd("diffthis")

  show_whole_file(scratch_win)
  show_whole_file(orig_win)

  return true, nil
end

function M.toggle()
  local tab = vim.api.nvim_get_current_tabpage()
  if state_by_tab[tab] then
    cleanup(tab)
    return
  end

  local orig_win = vim.api.nvim_get_current_win()
  local orig_buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_get_option(orig_buf, "buftype") ~= "" then
    notify("ModalDiff: unsupported buffer", vim.log.levels.WARN)
    return
  end

  local st = {
    orig_win = orig_win,
    orig_buf = orig_buf,
  }

  local ok, err = open_head_left(st)
  if not ok then
    notify("ModalDiff: " .. err, vim.log.levels.ERROR)
    return
  end

  state_by_tab[tab] = st
  setup_autocmds(tab, st)
end

return M
