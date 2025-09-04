
-- load colors from ~/.cache/wal/colors


local rgb_to_hsl = function(r, g, b)
    r, g, b = r / 255, g / 255, b / 255
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, l
    l = (max + min) / 2
    if max == min then
        h, s = 0, 0
    else
        local d = max - min
        s = l > 0.5 and d / (2 - max - min) or d / (max + min)
        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end
        h = h / 6
    end
    return h, s, l
end

local hsl_to_rgb = function(h, s, l)
    local r, g, b
    if s == 0 then
        r, g, b = l, l, l
    else
        local hue2rgb = function(p, q, t)
            if t < 0 then
                t = t + 1
            end
            if t > 1 then
                t = t - 1
            end
            if t < 1 / 6 then
                return p + (q - p) * 6 * t
            end
            if t < 1 / 2 then
                return q
            end
            if t < 2 / 3 then
                return p + (q - p) * (2 / 3 - t) * 6
            end
            return p
        end
        local q = l < 0.5 and l * (1 + s) or l + s - l * s
        local p = 2 * l - q
        r = hue2rgb(p, q, h + 1 / 3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1 / 3)
    end
    return r * 255, g * 255, b * 255
end

local hex_to_rgb = function(hex)
    hex = hex:gsub("#", "")
    return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local rgb_to_hex = function(r, g, b)
    return string.format("#%02x%02x%02x", r, g, b)
end

local interpolate_color_hsl = function(color1, color2)
    local h1, s1, l1 = rgb_to_hsl(hex_to_rgb(color1))
    local h2, s2, l2 = rgb_to_hsl(hex_to_rgb(color2))
    local h, s, l = (h1 + h2) / 2, (s1 + s2) / 2, (l1 + l2) / 2
    return rgb_to_hex(hsl_to_rgb(h, s, l))
end

local file = io.open(os.getenv("HOME") .. "/.cache/wal/colors", "r")
if file then
    local wal_colors = {}
    for line in file:lines() do
        wal_colors[#wal_colors + 1] = line
    end
    file:close()

    local colors = {
        wal_black = wal_colors[1],
        wal_red = wal_colors[2],
        wal_green = wal_colors[3],
        wal_yellow = wal_colors[4],
        wal_blue = wal_colors[5],
        wal_magenta = wal_colors[6],
        wal_cyan = wal_colors[7],
        wal_white = wal_colors[8],
        overlay2 = "#9399b2",
        surface2 = "#6e759f",

        wal_orange = interpolate_color_hsl(wal_colors[2], wal_colors[4]),
    }

    local highlights = {
        Comment = { fg = colors.overlay2 }, -- just comments
        SpecialComment = { link = "Special" }, -- special things inside a comment
        Constant = { fg = colors.wal_orange }, -- (preferred) any constant
        String = { fg = colors.wal_green }, -- a string constant: "this is a string"
        Character = { fg = colors.wal_blue }, --  a character constant: 'c', '\n'
        Number = { fg = colors.wal_orange }, --   a number constant: 234, 0xff
        Float = { link = "Number" }, --    a floating point constant: 2.3e10
        Boolean = { fg = colors.wal_orange }, --  a boolean constant: TRUE, false
        Identifier = { fg = colors.wal_magenta }, -- (preferred) any variable name
        Function = { fg = colors.wal_blue }, -- function name (also: methods for classes)
        Statement = { fg = colors.wal_magenta }, -- (preferred) any statement
        Conditional = { fg = colors.wal_magenta }, --  if, then, else, endif, switch, etc.
        Repeat = { fg = colors.wal_magenta }, --   for, do, while, etc.
        Label = { fg = colors.sapphire }, --    case, default, etc.
        Operator = { fg = colors.sky }, -- "sizeof", "+", "*", etc.
        Keyword = { fg = colors.wal_red }, --  any other keyword
        Exception = { fg = colors.wal_magenta }, --  try, catch, throw

        PreProc = { fg = colors.wal_red }, -- (preferred) generic Preprocessor
        Include = { fg = colors.wal_magenta }, --  preprocessor #include
        Define = { link = "PreProc" }, -- preprocessor #define
        Macro = { fg = colors.wal_magenta }, -- same as Define
        PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

        StorageClass = { fg = colors.yellow }, -- static, register, volatile, etc.
        Structure = { fg = colors.yellow }, --  struct, union, enum, etc.
        Special = { fg = colors.wal_red }, -- (preferred) any special symbol
        Type = { fg = colors.wal_yellow }, -- (preferred) int, long, char, etc.
        Typedef = { link = "Type" }, --  A typedef
        SpecialChar = { link = "Special" }, -- special character in a constant
        Tag = { fg = colors.wal_cyan }, -- you can use CTRL-] on this
        Delimiter = { fg = colors.overlay2 }, -- character that needs attention
        Debug = { link = "Special" }, -- debugging statements

        Error = { fg = colors.wal_red },


        ["@property"] = { fg = colors.wal_magenta },
        ["@variable.builtin"] = { fg = colors.wal_red },
        ["@function.builtin"] = { fg = colors.wal_yellow },
        ["@keyword.return"] = { fg = colors.wal_magenta },
        ["@variable.parameter"] = { fg = colors.wal_red },
        ["@parameter"] = { fg = colors.wal_red },
        ["@keyword.function"] = { fg = colors.wal_magenta },

        rainbow1 = { fg = colors.wal_red },
        rainbow2 = { fg = colors.wal_yellow },
        rainbow3 = { fg = colors.wal_green },
        rainbow6 = { fg = colors.wal_cyan },
        rainbow4 = { fg = colors.wal_blue },
        rainbow5 = { fg = colors.wal_magenta },

        RainbowDelimiterRed = { fg = colors.wal_red },
        RainbowDelimiterOrange = { fg = colors.wal_orange },
        RainbowDelimiterYellow = { fg = colors.wal_yellow },
        RainbowDelimiterGreen = { fg = colors.wal_green },
        RainbowDelimiterBlue = { fg = colors.wal_blue },
        RainbowDelimiterCyan = { fg = colors.wal_cyan },
        RainbowDelimiterViolet = { fg = colors.wal_magenta },

        AlphaButtonLabel = { fg = colors.wal_green, bold = true },
        AlphaButtonSides = { fg = colors.surface2 },
        AlphaHeader = { fg = colors.wal_red },
        AlphaDivider = { fg = colors.wal_yellow },

    }

    for group, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, hl)
    end
else
    print("Could not open wal colors file")
end
