local M = {}

local function run(cmd, cwd)
  if vim.system then
    local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
    local stdout = (res.stdout or ""):gsub("\r\n", "\n")
    local stderr = (res.stderr or ""):gsub("\r\n", "\n")
    return res.code or 1, stdout, stderr
  end

  local prefix = ""
  if cwd and cwd ~= "" then
    prefix = "cd " .. vim.fn.shellescape(cwd) .. " && "
  end
  local shell_cmd = prefix .. table.concat(vim.tbl_map(vim.fn.shellescape, cmd), " ")
  local out = vim.fn.system(shell_cmd)
  local code = vim.v.shell_error
  return code, out or "", ""
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.git_root(file)
  local dir = vim.fn.fnamemodify(file, ":h")
  local code, out, err = run({ "git", "rev-parse", "--show-toplevel" }, dir)
  if code ~= 0 then
    return nil, trim(err ~= "" and err or out)
  end
  return trim(out), nil
end

function M.relpath(file, root)
  local abs = vim.fn.fnamemodify(file, ":p")
  local rp = abs
  if abs:sub(1, #root) == root then
    rp = abs:sub(#root + 2)
  end
  return rp
end

function M.show_head(root, relpath)
  local code, out, err = run({ "git", "show", "HEAD:" .. relpath }, root)
  if code ~= 0 then
    return nil, trim(err ~= "" and err or out)
  end

  local lines = vim.split(out, "\n", { plain = true })
  if #lines > 0 and lines[#lines] == "" then
    table.remove(lines, #lines)
  end
  return lines, nil
end

return M
