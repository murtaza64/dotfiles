local all_options = vim.api.nvim_get_all_options_info()
local win_number = vim.api.nvim_get_current_win()
local v = vim.wo[win_number]
local all_options = vim.api.nvim_get_all_options_info()
local result = ""
for key, val in pairs(all_options) do
    if val.global_local == false and val.scope == "win" then
        result = result .. "|" .. key .. "=" .. tostring(v[key] or "<not set>") .. "\n"
    end
end
print(result)
