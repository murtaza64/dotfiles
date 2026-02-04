
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

local lighten_color = function(hex_color, amount)
  amount = amount or 0.1 -- default 10% lighter
  local r, g, b = hex_to_rgb(hex_color)
  local h, s, l = rgb_to_hsl(r, g, b)
  l = math.min(1.0, l + amount) -- increase lightness, cap at 1.0
  local new_r, new_g, new_b = hsl_to_rgb(h, s, l)
  return rgb_to_hex(new_r, new_g, new_b)
end

local darken_color = function(hex_color, amount)
  amount = amount or 0.1 -- default 10% darker
  local r, g, b = hex_to_rgb(hex_color)
  local h, s, l = rgb_to_hsl(r, g, b)
  l = math.max(0.0, l * (1 - amount)) -- decrease lightness, floor at 0.0
  local new_r, new_g, new_b = hsl_to_rgb(h, s, l)
  return rgb_to_hex(new_r, new_g, new_b)
end

FALLBACK_COLORS = {
  -- catppuccin-mocha
  background = "#1e1e2e",
  foreground = "#cdd6f4",

  black = "#1e1e2e",
  red = "#f38ba8",
  green = "#a6e3a1",
  yellow = "#f9e2af",
  blue = "#89b4fa",
  magenta = "#f5c2e7",
  cyan = "#94e2d5",
  white = "#cdd6f4",

  bright_black = "#1e1e2e",
  bright_red = "#f38ba8",
  bright_green = "#a6e3a1",
  bright_yellow = "#f9e2af",
  bright_blue = "#89b4fa",
  bright_magenta = "#f5c2e7",
  bright_cyan = "#94e2d5",
  bright_white = "#cdd6f4",

  surface0 = "#313244",
  surface1 = "#45475a",
  surface2 = "#585b70",
  surface3 = "#6c7086",
  surface4 = "#7f849c",
  surface5 = "#9399b2",
  
  color0 = "#1e1e2e", -- black
  color1 = "#f38ba8", -- red
  color2 = "#a6e3a1", -- green
  color3 = "#f9e2af", -- yellow
  color4 = "#89b4fa", -- blue
  color5 = "#f5c2e7", -- magenta
  color6 = "#94e2d5", -- cyan
  color7 = "#cdd6f4", -- white

  color8 = "#1e1e2e", -- black
  color9 = "#f38ba8", -- red
  color10 = "#a6e3a1", -- green
  color11 = "#f9e2af", -- yellow
  color12 = "#89b4fa", -- blue
  color13 = "#f5c2e7", -- magenta
  color14 = "#94e2d5", -- cyan
  color15 = "#cdd6f4", -- white
}

local get_colors = function()
  local file = io.open(os.getenv("HOME") .. "/.cache/wal/colors.properties", "r")
  if not file then
    vim.notify("Could not open wal colors.properties file", vim.log.levels.WARNING)
    return FALLBACK_COLORS
  end
  local colors = {}
  for line in file:lines() do
    if line ~= "" and not line:match("^#") then
      local key, value = line:match("([^=]+)=([^=]+)")
      if key and value then
        colors[key] = value
      end
    end
  end
  file:close()
  colors.orange = interpolate_color_hsl(colors.red, colors.yellow)
  return colors
end

local lualine_theme = function()
  local colors = get_colors()
  local transparent_bg = "NONE"
  local theme = {}

  theme.normal = {
    a = { bg = colors.blue, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.blue },
    c = { bg = transparent_bg, fg = colors.foreground },
  }

  theme.insert = {
    a = { bg = colors.green, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.green },
    c = { bg = "none", fg = colors.green },
  }

  theme.terminal = {
    a = { bg = colors.green, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.green },
    c = { bg = transparent_bg, fg = colors.green },
  }

  theme.command = {
    a = { bg = colors.cyan, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.cyan },
    c = { bg = transparent_bg, fg = colors.cyan },
  }

  theme.visual = {
    a = { bg = colors.magenta, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.magenta },
    c = { bg = transparent_bg, fg = colors.magenta },
  }

  theme.replace = {
    a = { bg = colors.red, fg = colors.background, gui = "bold" },
    b = { bg = colors.surface0, fg = colors.red },
    c = { bg = transparent_bg, fg = colors.red },
  }

  theme.inactive = {
    a = { bg = transparent_bg, fg = colors.blue },
    b = { bg = transparent_bg, fg = colors.surface1, gui = "bold" },
    c = { bg = transparent_bg, fg = colors.surface2 },
  }

  return theme
end

local function load_pywal_colors()
  local colors = get_colors()
  if not colors then
    return
  end
  local highlights = {
    Normal = { bg = colors.background, fg = colors.foreground },
    Title = { fg = colors.blue, bold = true },

    -- UI
    CursorLine = { bg = colors.surface0 }, -- slightly lighter than background
    BentoNormalCustom = { bg = colors.surface0 },
    FloatBorder = { fg = colors.color1 },
    LineNr = { fg = colors.surface2 },
    CursorLineNr = { fg = colors.color1 },
    VerticalSplit = { fg = colors.surface1 },
    WinSeparator = { fg = colors.surface1 },

    -- Git
    GitSignsChange = { fg = colors.yellow },
    GitSignsAdd = { fg = colors.green },
    GitSignsDelete = { fg = colors.red },

    -- Telescope
    TelescopeBorder = { link = "FloatBorder" },
    TelescopeNormal = { link = "NormalFloat" },
    TelescopePreviewNormal = { link = "TelescopeNormal" },
    TelescopePromptNormal = { link = "TelescopeNormal" },
    TelescopeResultsNormal = { link = "TelescopeNormal" },
    TelescopeTitle = { link = "FloatTitle" },
    TelescopeSelectionCaret = { fg = colors.magenta, bg = colors.surface0 },
    TelescopeSelection = { fg = colors.magenta, bg = colors.surface0, bold = true },
    TelescopeMatching = { fg = colors.blue },
    TelescopePromptPrefix = { fg = colors.color1 },
    
    -- Diagnostics
    DiagnosticSignError = { fg = colors.red },
    DiagnosticSignWarn = { fg = colors.yellow },
    DiagnosticSignInfo = { fg = colors.blue },
    DiagnosticSignHint = { fg = colors.cyan },
    DiagnosticSignOk = { fg = colors.green },
    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.blue },
    DiagnosticHint = { fg = colors.cyan },
    DiagnosticOk = { fg = colors.green },

    -- Indentation
    Whitespace = { fg = colors.surface2 },
    IblIndent = { fg = colors.surface2 },
    IblWhitespace = { fg = colors.surface2 },
    ["@ibl.indent.char.1"] = { fg = colors.surface2 },


    -- Syntax
    Comment = { fg = colors.surface4 }, -- just comments
    SpecialComment = { link = "Special" }, -- special things inside a comment
    Constant = { fg = colors.orange }, -- (preferred) any constant
    String = { fg = colors.color2 }, -- a string constant: "this is a string"
    Character = { fg = colors.color4 }, --  a character constant: 'c', '\n'
    Number = { fg = colors.orange }, --   a number constant: 234, 0xff
    Float = { link = "Number" }, --  a floating point constant: 2.3e10
    Boolean = { fg = colors.orange }, --  a boolean constant: TRUE, false
    Identifier = { fg = colors.color5 }, -- (preferred) any variable name
    Function = { fg = colors.color4 }, -- function name (also: methods for classes)
    Statement = { fg = colors.color5 }, -- (preferred) any statement
    Conditional = { fg = colors.color5 }, --  if, then, else, endif, switch, etc.
    Repeat = { fg = colors.color5 }, --   for, do, while, etc.
    Label = { fg = colors.color6 }, --  case, default, etc.
    Operator = { fg = colors.color6 }, -- "sizeof", "+", "*", etc.
    Keyword = { fg = colors.color1 }, --  any other keyword
    Exception = { fg = colors.color5 }, --  try, catch, throw

    PreProc = { fg = colors.color1 }, -- (preferred) generic Preprocessor
    Include = { fg = colors.color5 }, --  preprocessor #include
    Define = { link = "PreProc" }, -- preprocessor #define
    Macro = { fg = colors.color5 }, -- same as Define
    PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

    StorageClass = { fg = colors.color3 }, -- static, register, volatile, etc.
    Structure = { fg = colors.color3 }, --  struct, union, enum, etc.
    Special = { fg = colors.color1 }, -- (preferred) any special symbol
    Type = { fg = colors.color3 }, -- (preferred) int, long, char, etc.
    Typedef = { link = "Type" }, --  A typedef
    SpecialChar = { link = "Special" }, -- special character in a constant
    Tag = { fg = colors.color6 }, -- you can use CTRL-] on this
    Delimiter = { fg = colors.surface4 }, -- character that needs attention
    Debug = { link = "Special" }, -- debugging statements

    Error = { fg = colors.color1 },


    -- Treesitter
    ["@parameter"] = { fg = colors.color1 },

    -- https://github.com/catppuccin/nvim/blob/30fa4d122d9b22ad8b2e0ab1b533c8c26c4dde86/lua/catppuccin/groups/integrations/treesitter.lua
    -- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
    -- Identifiers
    ["@variable"] = { fg = colors.foreground }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"] = { fg = colors.color1 }, -- Variable names that are defined by the languages, like this or self.
    ["@variable.parameter"] = { fg = colors.color1 }, -- For parameters of a function.
    ["@variable.member"] = { fg = colors.foreground }, -- For fields.

    ["@constant"] = { link = "Constant" }, -- For constants
    ["@constant.builtin"] = { fg = colors.orange }, -- For constant that are built in the language: nil in Lua.
    ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

    ["@module"] = { fg = colors.color3 }, -- For identifiers referring to modules and namespaces.
    ["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

    -- Literals
    ["@string"] = { link = "String" }, -- For strings.
    ["@string.documentation"] = { fg = colors.color6 }, -- For strings documenting code (e.g. Python docstrings).
    ["@string.regexp"] = { fg = colors.color5 }, -- For regexes.
    ["@string.escape"] = { fg = colors.color5 }, -- For escape characters within a string.
    ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
    ["@string.special.path"] = { link = "Special" }, -- filenames
    ["@string.special.symbol"] = { fg = colors.color5 }, -- symbols or atoms
    ["@string.special.url"] = { fg = colors.color4 }, -- urls, links and emails
    ["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

    ["@character"] = { link = "Character" }, -- character literals
    ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

    ["@boolean"] = { link = "Boolean" }, -- For booleans.
    ["@number"] = { link = "Number" }, -- For all numbers
    ["@number.float"] = { link = "Float" }, -- For floats.

    -- Types
    ["@type"] = { link = "Type" }, -- For types.
    ["@type.builtin"] = { fg = colors.color5 }, -- For builtin types.
    ["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)

    ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
    ["@property"] = { fg = colors.foreground }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

    -- Functions
    ["@function"] = { link = "Function" }, -- For function (calls and definitions).
    ["@function.builtin"] = { fg = colors.orange }, -- For builtin functions: table.insert in Lua.
    ["@function.call"] = { link = "Function" }, -- function calls
    ["@function.macro"] = { fg = colors.color5 }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.

    ["@function.method"] = { link = "Function" }, -- For method definitions.
    ["@function.method.call"] = { link = "Function" }, -- For method calls.

    ["@constructor"] = { fg = colors.color3 }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
    ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

    -- Keywords
    ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
    ["@keyword.modifier"] = { link = "Keyword" }, -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
    ["@keyword.type"] = { link = "Keyword" }, -- For keywords describing composite types (e.g. `struct`, `enum`)
    ["@keyword.coroutine"] = { link = "Keyword" }, -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    ["@keyword.function"] = { fg = colors.color5 }, -- For keywords used to define a function.
    ["@keyword.operator"] = { fg = colors.color5 }, -- For new keyword operator
    ["@keyword.import"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
    ["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loops.
    ["@keyword.return"] = { fg = colors.color5 },
    ["@keyword.debug"] = { link = "Exception" }, -- For keywords related to debugging
    ["@keyword.exception"] = { link = "Exception" }, -- For exception related keywords.

    ["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
    ["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

    ["@keyword.directive"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
    ["@keyword.directive.define"] = { link = "Define" }, -- preprocessor definition directives
    -- JS & derivative
    ["@keyword.export"] = { fg = colors.color5 },

    -- Punctuation
    ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
    -- ["@punctuation.bracket"] = { fg = C.overlay2 }, -- For brackets and parenthesis.
    ["@punctuation.special"] = { link = "Special" }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

    -- Comment
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

    ["@comment.error"] = { fg = colors.surface0, bg = colors.color1 },
    ["@comment.warning"] = { fg = colors.surface0, bg = colors.color3 },
    ["@comment.hint"] = { fg = colors.surface0, bg = colors.color4 },
    ["@comment.todo"] = { fg = colors.surface0, bg = colors.color1 },
    ["@comment.note"] = { fg = colors.surface0, bg = colors.color5 },

    -- Markup
    ["@markup"] = { fg = colors.foreground }, -- For strings considerated text in a markup language.
    ["@markup.strong"] = { bold=true }, -- bold
    ["@markup.italic"] = { italic=true }, -- italic
    ["@markup.strikethrough"] = { fg = colors.foreground }, -- strikethrough text
    ["@markup.underline"] = { link = "Underlined" }, -- underlined text

    ["@markup.heading"] = { fg = colors.color4 }, -- titles like: # Example
    ["@markup.heading.markdown"] = {  }, -- bold headings in markdown, but not in HTML or other markup

    ["@markup.math"] = { fg = colors.color4 }, -- math environments (e.g. `$ ... $` in LaTeX)
    ["@markup.quote"] = { fg = colors.color5 }, -- block quotes
    ["@markup.environment"] = { fg = colors.color5 }, -- text environments of markup languages
    ["@markup.environment.name"] = { fg = colors.color4 }, -- text indicating the type of an environment

    ["@markup.link"] = { fg = colors.color4 }, -- text references, footnotes, citations, etc.
    ["@markup.link.label"] = { fg = colors.color4 }, -- link, reference descriptions
    ["@markup.link.url"] = { fg = colors.color4 }, -- urls, links and emails

    ["@markup.raw"] = { fg = colors.color2 }, -- used for inline code in markdown and for doc in python (""")

    ["@markup.list"] = { fg = colors.color4 },
    ["@markup.list.checked"] = { fg = colors.color2 }, -- todo notes
    ["@markup.list.unchecked"] = { fg = colors.surface2 }, -- todo notes


    -- Tags
    ["@tag"] = { fg = colors.color6 }, -- Tags like HTML tag names.
    ["@tag.builtin"] = { fg = colors.color6 }, -- JSX tag names.
    ["@tag.attribute"] = { fg = colors.color3 }, -- XML/HTML attributes (foo in foo="bar").
    ["@tag.delimiter"] = { fg = colors.color6 }, -- Tag delimiter like < > /

    -- Misc
    ["@error"] = { link = "Error" },

    -- Language specific:

    -- Bash
    ["@function.builtin.bash"] = { fg = colors.color1 },
    ["@variable.parameter.bash"] = { fg = colors.color2 },

    -- markdown
    ["@markup.heading.1.markdown"] = { fg = colors.color1, bold = true },
    ["@markup.heading.2.markdown"] = { fg = colors.color2, bold = true },
    ["@markup.heading.3.markdown"] = { fg = colors.color3, bold = true },
    ["@markup.heading.4.markdown"] = { fg = colors.color4, bold = true },
    ["@markup.heading.5.markdown"] = { fg = colors.color5, bold = true },
    ["@markup.heading.6.markdown"] = { fg = colors.color6, bold = true },


    RenderMarkdownH1 = { link = "rainbow1" },
    RenderMarkdownH2 = { link = "rainbow2" },
    RenderMarkdownH3 = { link = "rainbow3" },
    RenderMarkdownH4 = { link = "rainbow4" },
    RenderMarkdownH5 = { link = "rainbow5" },
    RenderMarkdownH6 = { link = "rainbow6" },
    

    -- rainbow1 = { fg = colors.color1 },
    -- rainbow2 = { fg = colors.color3 },
    -- rainbow3 = { fg = colors.color2 },
    -- rainbow6 = { fg = colors.color6 },
    -- rainbow4 = { fg = colors.color4 },
    -- rainbow5 = { fg = colors.color5 },

    RenderMarkdownH1Bg = { bg = darken_color(colors.color1, 0.8) },
    RenderMarkdownH2Bg = { bg = darken_color(colors.color3, 0.8) },
    RenderMarkdownH3Bg = { bg = darken_color(colors.color2, 0.8) },
    RenderMarkdownH4Bg = { bg = darken_color(colors.color4, 0.8) },
    RenderMarkdownH5Bg = { bg = darken_color(colors.color5, 0.8) },
    RenderMarkdownH6Bg = { bg = darken_color(colors.color6, 0.8) },

    RenderMarkdownCode = { bg = colors.surface0 },
    RenderMarkdownCodeInline = { bg = colors.surface1 },

    -- Java
    -- ["@constant.java"] = { fg = C.teal },

    -- CSS
    ["@property.css"] = { fg = colors.color4 },
    ["@property.scss"] = { fg = colors.color4 },
    ["@property.id.css"] = { fg = colors.color3 },
    ["@property.class.css"] = { fg = colors.color3 },
    ["@type.css"] = { fg = colors.color4 },
    ["@type.tag.css"] = { fg = colors.color6 },
    ["@string.plain.css"] = { fg = colors.foreground },
    ["@number.css"] = { fg = colors.orange },
    ["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

    -- HTML
    ["@string.special.url.html"] = { fg = colors.color2 }, -- Links in href, src attributes.
    ["@markup.link.label.html"] = { fg = colors.foreground }, -- Text between <a></a> tags.
    ["@character.special.html"] = { fg = colors.color1 }, -- Symbols such as &nbsp;.

    -- TOML
    ["@property.toml"] = { fg = colors.color4 }, -- For fields.

    -- JSON
    ["@property.json"] = { fg = colors.color4 }, -- For fields.

    -- Lua
    ["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

    -- Python
    ["@constructor.python"] = { fg = colors.color6 }, -- __init__(), __new__().

    -- YAML
    ["@property.yaml"] = { fg = colors.color4 }, -- For fields.
    ["@label.yaml"] = { fg = colors.color3 }, -- Anchor and alias names.

    -- Nix
    ["@variable.member.nix"] = { fg = colors.color4 }, -- For fields.
    ["@lsp.type.property.nix"] = { fg = colors.color4 }, -- Also for fields, from LSP.

    -- Ruby
    ["@string.special.symbol.ruby"] = { fg = colors.color1 },

    -- PHP
    ["@function.method.php"] = { link = "Function" },
    ["@function.method.call.php"] = { link = "Function" },

    -- C/CPP
    ["@keyword.import.c"] = { fg = colors.color3 },
    ["@keyword.import.cpp"] = { fg = colors.color3 },

    -- C#
    ["@attribute.c_sharp"] = { fg = colors.color3 },

    -- gitcommit
    ["@comment.warning.gitcommit"] = { fg = colors.color3 },

    -- gitignore
    ["@string.special.path.gitignore"] = { fg = colors.foreground },

    -- Misc
    -- gitcommitSummary = { fg = C.rosewater },

    rainbow1 = { fg = colors.color1 },
    rainbow2 = { fg = colors.color2 },
    rainbow3 = { fg = colors.color3 },
    rainbow4 = { fg = colors.color4 },
    rainbow5 = { fg = colors.color5 },
    rainbow6 = { fg = colors.color6 },

    RainbowDelimiterRed = { fg = colors.color1 },
    RainbowDelimiterOrange = { fg = colors.orange },
    RainbowDelimiterYellow = { fg = colors.color3 },
    RainbowDelimiterGreen = { fg = colors.color2 },
    RainbowDelimiterBlue = { fg = colors.color4 },
    RainbowDelimiterCyan = { fg = colors.color6 },
    RainbowDelimiterViolet = { fg = colors.color5 },

    AlphaButtonLabel = { fg = colors.color2, bold = true },
    AlphaButtonSides = { fg = colors.surface2 },
    AlphaHeader = { fg = colors.color1 },
    AlphaDivider = { fg = colors.color3 },

  }

  for group, hl in pairs(highlights) do
    -- print(vim.inspect(group))
    -- print(vim.inspect(hl))
    vim.api.nvim_set_hl(0, group, hl)
  end
  
  vim.notify("Pywal colors loaded successfully", vim.log.levels.INFO)
end

local reload_pywal_colors = function()
  load_pywal_colors()
  require("lualine.load_lualine").init()
end

local auto_reload_pywal_colors = function()
  local colors_file = os.getenv("HOME") .. "/.cache/wal/colors.properties"
  local last_mtime = 0
  
  local function check_and_reload()
    local stat = vim.uv.fs_stat(colors_file)
    if stat and stat.mtime.sec > last_mtime then
      last_mtime = stat.mtime.sec
      reload_pywal_colors()
    end
  end
  
  -- Initial check to set baseline mtime
  local stat = vim.uv.fs_stat(colors_file)
  if stat then
    last_mtime = stat.mtime.sec
  end
  
  -- Create timer that checks every 3 seconds
  local timer = vim.uv.new_timer()
  timer:start(0, 3000, vim.schedule_wrap(check_and_reload))
  
  return timer
end

-- -- Load colors on initial require
-- load_pywal_colors()

-- Create user command to reload colors
vim.api.nvim_create_user_command('PywalReload', reload_pywal_colors, {
  desc = 'Reload pywal colors for neovim'
})


-- Return the function for manual calling if needed
return {
  auto_reload_pywal_colors = auto_reload_pywal_colors,
  load_pywal_colors = load_pywal_colors,
  lualine_theme = lualine_theme,
  get_colors = get_colors,
}
