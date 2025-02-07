-- based on alpha startify theme
-- alpha-nvim/lua/alpha/themes/startify.lua
local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

local handle = io.popen("hostname -s")  -- Run the hostname command
local hostname = handle:read("*a")  -- Read the output
handle:close()  -- Close the handle
hostname = hostname:gsub("%s+", "")  -- Remove any whitespace (including newlines)
local current_time = os.date("%H:%M")
local current_date = os.date("%a %b %d")

local leader = "SPC"

local margin = 3
local align = 70

local asciis = require('neovim_ascii')
local art = asciis[math.random(#asciis)]
if #art < 3 then
    for _ = 1, 3 - #art do
        table.insert(art, "")
    end
end
art[#art - 2] = art[#art - 2] .. string.rep(" ", align - #art[#art - 2] - #hostname) .. hostname
art[#art - 1] = art[#art - 1] .. string.rep(" ", align - #art[#art - 1] - #current_date) .. current_date
art[#art - 0] = art[#art - 0] .. string.rep(" ", align - #art[#art - 0] - #current_time) .. current_time


local default_header = {
    type = "text",
    -- val = {
    --     [[                                  __]],
    --     [[     ___     ___    ___   __  __ /\_\    ___ ___]],
    --     [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
    --     [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
    --     [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    --     [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    -- },
    val = art,
    opts = {
        hl = "AlphaHeader",
        shrink_margin = false,
        -- wrap = "overflow";
    },
}


local align_center = function(s)
    return string.rep(" ", align - #s) .. s
end

local truncate_path = function(fname, max_length)
    if #fname > max_length then
        fname = vim.fn.pathshorten(fname, 3)
        if #fname > max_length then
            fname = '...' .. string.sub(fname, - (max_length-3))
        end
    end
    return fname
end


local function button(sc, txt, keybind, opts)
    -- print(sc, txt, keybind, vim.inspect(opts))
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")
    local left_padding = if_nil(opts.left_padding, align - #txt)
    -- print(txt, left_padding, align - #txt, #txt)
    local left_padding_txt = ""
    if left_padding > 0 then
        left_padding_txt = string.rep(" ", left_padding)
    end

    local icon_txt = opts.icon

    local out_opts = {
        position = "left",
        -- shortcut = " " .. sc .. " ",
        -- shortcut = " █" .. sc .. "█",
        shortcut = " [" .. sc .. "] " .. icon_txt,
        cursor = align + 5,
        -- width = 50,
        align_shortcut = "right",
        hl_shortcut = {
            { "AlphaButtonSides", 0, 2 },
            { "AlphaButtonLabel", 2, #sc + 2 },
            { "AlphaButtonSides", #sc + 2, #sc + 4 },
        },
        shrink_margin = false,
        hl = {}
    }
    if opts.icon_hl then
        table.insert(out_opts.hl_shortcut, { opts.icon_hl, #sc + 4, #sc + 10 })
    end
    if opts.text_hl then
        table.insert(out_opts.hl, { opts.text_hl, margin, margin + align })
    end
    if keybind then
        local keybind_opts = if_nil(opts.keybind_opts, { noremap = true, silent = true, nowait = true })
        out_opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        -- val = left_padding_txt .. txt .. icon_txt,
        val = left_padding_txt .. txt,
        on_press = on_press,
        opts = out_opts,
    }
end

local function get_extension(fn)
    local match = fn:match("^.+(%..+)$")
    local ext = ""
    if match ~= nil then
        ext = match:sub(2)
    end
    return ext
end

local function icon(fn)
    local nwd = require("nvim-web-devicons")
    local ext = get_extension(fn)
    return nwd.get_icon(fn, ext, { default = true })
end

local shortcuts = '056789abcdegimprstuvwxyz'

local function file_button(fn, shortcut_key, short_fn, autocd, row, col)
    short_fn = if_nil(short_fn, fn)
    local position_txt = ""
    if row and col then
        position_txt = (":%d:%d"):format(row, col)
    end
    short_fn = truncate_path(short_fn, align - 0 - #position_txt)
    local final_fn = short_fn .. position_txt
    local fb_hl = {}
    local ico, hl = icon(fn)
    local left_padding = align - #final_fn
    local cursor_cmd = ""
    if row then
        if col then
            cursor_cmd = (" | call cursor(%d, %d)"):format(row, col)
        else
            cursor_cmd = (" | call cursor(%d, 0)"):format(row)
        end
    end

    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local sc
    if type(shortcut_key) == "number" then
        sc = shortcuts:sub(shortcut_key, shortcut_key)
    else
        sc = shortcut_key
    end
    local file_button_el = button(
        sc,
        final_fn,
        "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. cursor_cmd .." <CR>",
        {
            icon = ico .. " ",
            icon_hl = hl,
            left_padding = left_padding
        }
    )
    local fn_start = (
        final_fn:match(".*[/\\]")
        or final_fn:match("%.%.%..*[/\\]")
        or final_fn:match("%.%.%.")
    )
    if fn_start ~= nil then
        table.insert(fb_hl, {
            "Comment",
            margin + left_padding,
            margin + left_padding + #fn_start
        })
    end
    table.insert(fb_hl, {
        "Function",
        margin + align - #position_txt,
        margin + align
    })
    file_button_el.opts.hl = fb_hl
    return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    autocd = false
}



local function mru()
    local oldfiles_cwd = {}
    local cwd_item_number = 12
    local cwd = vim.fn.getcwd()
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles_cwd == cwd_item_number then
            break
        end
        local ignore = (mru_opts.ignore and mru_opts.ignore(v, get_extension(v))) or false
        if (filereadable(v) == 1) and vim.startswith(v, cwd) and not ignore then
            table.insert(oldfiles_cwd, v)
        end
    end

    local oldfiles_all = {}
    local max_item_number = 20
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles_all + #oldfiles_cwd == max_item_number then
            break
        end
        local ignore = (mru_opts.ignore and mru_opts.ignore(v, get_extension(v))) or false
        if (filereadable(v) == 1) and not ignore and not require('utils').tableContains(oldfiles_cwd, v) then
            table.insert(oldfiles_all, v)
        end
    end

    local tbl_cwd = {}
    for i, fn in ipairs(oldfiles_cwd) do
        tbl_cwd[i] = file_button(fn, i, fnamemodify(fn, ":."), mru_opts.autocd)
    end
    local tbl_all = {}
    for i, fn in ipairs(oldfiles_all) do
        tbl_all[i] = file_button(fn, i + #oldfiles_cwd, fnamemodify(fn, ":~"), mru_opts.autocd)
    end
    return {
        {
            type = "text",
            val = function () return align_center(vim.fn.getcwd()) end,
            opts = { hl = "AlphaDivider", shrink_margin = false },
        },
        -- { type = "padding", val = 1 },
        {
            type = "group",
            val = tbl_cwd,
            opts = {},
        },
        { type = "padding", val = 1 },
        {
            type = "text",
            val = align_center("other oldfiles"),
            opts = { hl = "AlphaDivider", shrink_margin = false },
        },
        -- { type = "padding", val = 1 },
        {
            type = "group",
            val = tbl_all,
            opts = {},
        },
    }
end

local global_marks = function()
    local tbl = {}
    for i = 65, 90 do
        local mark = string.char(i)
        local row, col, _, fn = unpack(vim.api.nvim_get_mark(mark, {}))
        if fn ~= "" then
            -- print(("%s:%d:%d"):format(fn, row, col))
            table.insert(tbl, file_button(fn, mark, fnamemodify(fn, ":~"), nil, row, col))
        end
    end
    -- print(vim.inspect(tbl))
    return {
        {
            type = "text",
            val = align_center("global marks"),
            opts = { hl = "AlphaDivider", shrink_margin = false },
        },
        { type = "group", val = tbl },
    }
end

local harpoon_marks = function()
    local tbl = {}
    for i = 1, 10 do
        local filename = require("harpoon.mark").get_marked_file_name(i)
        if filename ~= nil then
            shortcut = string.format("%d", i)
            table.insert(tbl, file_button(filename, shortcut, fnamemodify(filename, ":."), nil))
        end
    end
    return {
        {
            type = "text",
            val = align_center("harpoon marks"),
            opts = { hl = "AlphaDivider", shrink_margin = false },
        },
        { type = "group", val = tbl },
    }
end

local section = {
    header = default_header,
    top_buttons = {
        type = "group",
        val = {
            button(
                "n",
                "new file",
                "<cmd>ene <CR>",
                {
                    icon = "󰻭 ",
                    icon_hl = "String",
                    text_hl = "AlphaDivider",
                }
            ),
            button(
                "o",
                "oil",
                "<cmd>Oil <CR>",
                {
                    icon = "󰼙 ",
                    text_hl = "AlphaDivider",
                }
            ),
            button(
                "f",
                "find files",
                "<cmd>Telescope find_files<CR>",
                {
                    icon = "󰱽 ",
                    text_hl = "AlphaDivider",
                    keybind_opts = { noremap = false }
                }
            ),
        },
    },
    harpoon_marks = {
        type = "group",
        val = function() return harpoon_marks() end
    },
    global_marks = {
        type = "group",
        val = function() return global_marks() end
    },
    -- note about MRU: currently this is a function,
    -- since that means we can get a fresh mru
    -- whenever there is a DirChanged. this is *really*
    -- inefficient on redraws, since mru does a lot of I/O.
    -- should probably be cached, or maybe figure out a way
    -- to make it a reference to something mutable
    -- and only mutate that thing on DirChanged
    mru = {
        type = "group",
        val = function()
            return mru()
        end
        --     { type = "padding", val = 1 },
        --     {
        --         type = "text",
        --         val = mru_title,
        --         opts = { hl = "AlphaDivider", shrink_margin = false },
        --     },
        --     { type = "padding", val = 1 },
        --     {
        --         type = "group",
        --         val = function()
        --             return { mru(0, vim.fn.getcwd(), 16) }
        --         end,
        --         opts = { shrink_margin = false },
        --     },
        -- },
    },
    bottom_buttons = {
        type = "group",
        val = {
            button(
                "?",
                "more oldfiles",
                "<cmd>Telescope oldfiles<CR>",
                { icon = "󱋢 ", keybind_opts = { noremap = false }, text_hl = "AlphaDivider"}
            ),
            button(
                "q",
                "quit",
                "<cmd>q <CR>",
                { icon = "󰗼 ", text_hl = "Error" }
            ),
        },
    },
    footer = {
        type = "group",
        val = {},
    },
}

local config = {
    layout = {
        { type = "padding", val = 1 },
        section.header,
        { type = "padding", val = 1 },
        section.top_buttons,
        { type = "padding", val = 1 },
        section.harpoon_marks,
        { type = "padding", val = 1 },
        section.mru,
        { type = "padding", val = 1 },
        section.global_marks,
        { type = "padding", val = 1 },
        section.bottom_buttons,
        section.footer,
    },
    opts = {
        margin = margin,
        redraw_on_resize = false,
        setup = function()
            vim.api.nvim_create_autocmd('DirChanged', {
                pattern = '*',
                group = "alpha_temp",
                callback = function () require('alpha').redraw() end,
            })
        end,
    },
}

return {
    icon = icon,
    button = button,
    file_button = file_button,
    mru = mru,
    mru_opts = mru_opts,
    section = section,
    config = config,
    -- theme config
    -- nvim_web_devicons = nvim_web_devicons,
    leader = leader,
    -- deprecated
    opts = config,
}
