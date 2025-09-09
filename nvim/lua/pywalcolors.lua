
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

local function load_pywal_colors()
    local file = io.open(os.getenv("HOME") .. "/.cache/wal/colors", "r")
    if not file then
        vim.notify("Could not open wal colors file", vim.log.levels.ERROR)
        return
    end
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

        -- https://github.com/catppuccin/nvim/blob/30fa4d122d9b22ad8b2e0ab1b533c8c26c4dde86/lua/catppuccin/groups/integrations/treesitter.lua
        -- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
        -- Identifiers
        -- ["@variable"] = { fg = C.text }, -- Any variable name that does not have another highlight.
        ["@variable.builtin"] = { fg = colors.wal_red }, -- Variable names that are defined by the languages, like this or self.
        ["@variable.parameter"] = { fg = colors.wal_red }, -- For parameters of a function.
        -- ["@variable.member"] = { fg = C.text }, -- For fields.

        ["@constant"] = { link = "Constant" }, -- For constants
        ["@constant.builtin"] = { fg = colors.wal_orange }, -- For constant that are built in the language: nil in Lua.
        ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

        ["@module"] = { fg = colors.wal_yellow }, -- For identifiers referring to modules and namespaces.
        ["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

        -- Literals
        ["@string"] = { link = "String" }, -- For strings.
        ["@string.documentation"] = { fg = colors.wal_cyan }, -- For strings documenting code (e.g. Python docstrings).
        ["@string.regexp"] = { fg = colors.wal_magenta }, -- For regexes.
        ["@string.escape"] = { fg = colors.wal_magenta }, -- For escape characters within a string.
        ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
        ["@string.special.path"] = { link = "Special" }, -- filenames
        ["@string.special.symbol"] = { fg = colors.wal_magenta }, -- symbols or atoms
        ["@string.special.url"] = { fg = colors.wal_blue }, -- urls, links and emails
        ["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

        ["@character"] = { link = "Character" }, -- character literals
        ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

        ["@boolean"] = { link = "Boolean" }, -- For booleans.
        ["@number"] = { link = "Number" }, -- For all numbers
        ["@number.float"] = { link = "Float" }, -- For floats.

        -- Types
        ["@type"] = { link = "Type" }, -- For types.
        ["@type.builtin"] = { fg = colors.wal_magenta }, -- For builtin types.
        ["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)

        ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
        -- ["@property"] = { fg = C.text }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

        -- Functions
        ["@function"] = { link = "Function" }, -- For function (calls and definitions).
        ["@function.builtin"] = { fg = colors.wal_orange }, -- For builtin functions: table.insert in Lua.
        ["@function.call"] = { link = "Function" }, -- function calls
        ["@function.macro"] = { fg = colors.wal_magenta }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.

        ["@function.method"] = { link = "Function" }, -- For method definitions.
        ["@function.method.call"] = { link = "Function" }, -- For method calls.

        ["@constructor"] = { fg = colors.wal_yellow }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
        ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

        -- Keywords
        ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
        ["@keyword.modifier"] = { link = "Keyword" }, -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
        ["@keyword.type"] = { link = "Keyword" }, -- For keywords describing composite types (e.g. `struct`, `enum`)
        ["@keyword.coroutine"] = { link = "Keyword" }, -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
        ["@keyword.function"] = { fg = colors.wal_magenta }, -- For keywords used to define a function.
        ["@keyword.operator"] = { fg = colors.wal_magenta }, -- For new keyword operator
        ["@keyword.import"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
        ["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loops.
        ["@keyword.return"] = { fg = colors.wal_magenta },
        ["@keyword.debug"] = { link = "Exception" }, -- For keywords related to debugging
        ["@keyword.exception"] = { link = "Exception" }, -- For exception related keywords.

        ["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
        ["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

        ["@keyword.directive"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
        ["@keyword.directive.define"] = { link = "Define" }, -- preprocessor definition directives
        -- JS & derivative
        ["@keyword.export"] = { fg = colors.wal_magenta },

        -- Punctuation
        ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
        -- ["@punctuation.bracket"] = { fg = C.overlay2 }, -- For brackets and parenthesis.
        ["@punctuation.special"] = { link = "Special" }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

        -- Comment
        ["@comment"] = { link = "Comment" },
        ["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

        -- ["@comment.error"] = { fg = C.base, bg = colors.wal_red },
        -- ["@comment.warning"] = { fg = C.base, bg = colors.wal_yellow },
        -- ["@comment.hint"] = { fg = C.base, bg = colors.wal_blue },
        -- ["@comment.todo"] = { fg = C.base, bg = colors.wal_red },
        -- ["@comment.note"] = { fg = C.base, bg = C.rosewater },

        -- Markup
        -- ["@markup"] = { fg = C.text }, -- For strings considerated text in a markup language.
        ["@markup.strong"] = { fg = colors.wal_red }, -- bold
        ["@markup.italic"] = { fg = colors.wal_red }, -- italic
        -- ["@markup.strikethrough"] = { fg = C.text }, -- strikethrough text
        ["@markup.underline"] = { link = "Underlined" }, -- underlined text

        ["@markup.heading"] = { fg = colors.wal_blue }, -- titles like: # Example
        ["@markup.heading.markdown"] = {  }, -- bold headings in markdown, but not in HTML or other markup

        ["@markup.math"] = { fg = colors.wal_blue }, -- math environments (e.g. `$ ... $` in LaTeX)
        ["@markup.quote"] = { fg = colors.wal_magenta }, -- block quotes
        ["@markup.environment"] = { fg = colors.wal_magenta }, -- text environments of markup languages
        ["@markup.environment.name"] = { fg = colors.wal_blue }, -- text indicating the type of an environment

        ["@markup.link"] = { fg = colors.wal_blue }, -- text references, footnotes, citations, etc.
        ["@markup.link.label"] = { fg = colors.wal_blue }, -- link, reference descriptions
        ["@markup.link.url"] = { fg = colors.wal_blue }, -- urls, links and emails

        ["@markup.raw"] = { fg = colors.wal_green }, -- used for inline code in markdown and for doc in python (""")

        ["@markup.list"] = { fg = colors.wal_blue },
        ["@markup.list.checked"] = { fg = colors.wal_green }, -- todo notes
        -- ["@markup.list.unchecked"] = { fg = C.overlay1 }, -- todo notes


        -- Tags
        ["@tag"] = { fg = colors.wal_cyan }, -- Tags like HTML tag names.
        ["@tag.builtin"] = { fg = colors.wal_cyan }, -- JSX tag names.
        ["@tag.attribute"] = { fg = colors.wal_yellow }, -- XML/HTML attributes (foo in foo="bar").
        ["@tag.delimiter"] = { fg = colors.wal_cyan }, -- Tag delimiter like < > /

        -- Misc
        ["@error"] = { link = "Error" },

        -- Language specific:

        -- Bash
        ["@function.builtin.bash"] = { fg = colors.wal_red },
        ["@variable.parameter.bash"] = { fg = colors.wal_green },

        -- markdown
        ["@markup.heading.1.markdown"] = { link = "rainbow1" },
        ["@markup.heading.2.markdown"] = { link = "rainbow2" },
        ["@markup.heading.3.markdown"] = { link = "rainbow3" },
        ["@markup.heading.4.markdown"] = { link = "rainbow4" },
        ["@markup.heading.5.markdown"] = { link = "rainbow5" },
        ["@markup.heading.6.markdown"] = { link = "rainbow6" },

        -- Java
        -- ["@constant.java"] = { fg = C.teal },

        -- CSS
        ["@property.css"] = { fg = colors.wal_blue },
        ["@property.scss"] = { fg = colors.wal_blue },
        ["@property.id.css"] = { fg = colors.wal_yellow },
        ["@property.class.css"] = { fg = colors.wal_yellow },
        ["@type.css"] = { fg = colors.wal_blue },
        ["@type.tag.css"] = { fg = colors.wal_cyan },
        -- ["@string.plain.css"] = { fg = C.text },
        ["@number.css"] = { fg = colors.wal_orange },
        ["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

        -- HTML
        ["@string.special.url.html"] = { fg = colors.wal_green }, -- Links in href, src attributes.
        -- ["@markup.link.label.html"] = { fg = C.text }, -- Text between <a></a> tags.
        ["@character.special.html"] = { fg = colors.wal_red }, -- Symbols such as &nbsp;.

        -- TOML
        ["@property.toml"] = { fg = colors.wal_blue }, -- For fields.

        -- JSON
        ["@property.json"] = { fg = colors.wal_blue }, -- For fields.

        -- Lua
        ["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

        -- Python
        ["@constructor.python"] = { fg = colors.wal_cyan }, -- __init__(), __new__().

        -- YAML
        ["@property.yaml"] = { fg = colors.wal_blue }, -- For fields.
        ["@label.yaml"] = { fg = colors.wal_yellow }, -- Anchor and alias names.

        -- Nix
        ["@variable.member.nix"] = { fg = colors.wal_blue }, -- For fields.
        ["@lsp.type.property.nix"] = { fg = colors.wal_blue }, -- Also for fields, from LSP.

        -- Ruby
        ["@string.special.symbol.ruby"] = { fg = colors.wal_red },

        -- PHP
        ["@function.method.php"] = { link = "Function" },
        ["@function.method.call.php"] = { link = "Function" },

        -- C/CPP
        ["@keyword.import.c"] = { fg = colors.wal_yellow },
        ["@keyword.import.cpp"] = { fg = colors.wal_yellow },

        -- C#
        ["@attribute.c_sharp"] = { fg = colors.wal_yellow },

        -- gitcommit
        ["@comment.warning.gitcommit"] = { fg = colors.wal_yellow },

        -- gitignore
        -- ["@string.special.path.gitignore"] = { fg = C.text },

        -- Misc
        -- gitcommitSummary = { fg = C.rosewater },

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
    
    vim.notify("Pywal colors loaded successfully", vim.log.levels.INFO)
end

-- Load colors on initial require
load_pywal_colors()

-- Create user command to reload colors
vim.api.nvim_create_user_command('PywalReload', load_pywal_colors, {
    desc = 'Reload pywal colors for neovim'
})

-- Return the function for manual calling if needed
return {
    load_pywal_colors = load_pywal_colors
}
