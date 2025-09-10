
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


    -- Syntax
    Comment = { fg = colors.surface4 }, -- just comments
    SpecialComment = { link = "Special" }, -- special things inside a comment
    Constant = { fg = colors.orange }, -- (preferred) any constant
    String = { fg = colors.green }, -- a string constant: "this is a string"
    Character = { fg = colors.blue }, --  a character constant: 'c', '\n'
    Number = { fg = colors.orange }, --   a number constant: 234, 0xff
    Float = { link = "Number" }, --  a floating point constant: 2.3e10
    Boolean = { fg = colors.orange }, --  a boolean constant: TRUE, false
    Identifier = { fg = colors.magenta }, -- (preferred) any variable name
    Function = { fg = colors.blue }, -- function name (also: methods for classes)
    Statement = { fg = colors.magenta }, -- (preferred) any statement
    Conditional = { fg = colors.magenta }, --  if, then, else, endif, switch, etc.
    Repeat = { fg = colors.magenta }, --   for, do, while, etc.
    Label = { fg = colors.sapphire }, --  case, default, etc.
    Operator = { fg = colors.sky }, -- "sizeof", "+", "*", etc.
    Keyword = { fg = colors.red }, --  any other keyword
    Exception = { fg = colors.magenta }, --  try, catch, throw

    PreProc = { fg = colors.red }, -- (preferred) generic Preprocessor
    Include = { fg = colors.magenta }, --  preprocessor #include
    Define = { link = "PreProc" }, -- preprocessor #define
    Macro = { fg = colors.magenta }, -- same as Define
    PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

    StorageClass = { fg = colors.yellow }, -- static, register, volatile, etc.
    Structure = { fg = colors.yellow }, --  struct, union, enum, etc.
    Special = { fg = colors.red }, -- (preferred) any special symbol
    Type = { fg = colors.yellow }, -- (preferred) int, long, char, etc.
    Typedef = { link = "Type" }, --  A typedef
    SpecialChar = { link = "Special" }, -- special character in a constant
    Tag = { fg = colors.cyan }, -- you can use CTRL-] on this
    Delimiter = { fg = colors.surface4 }, -- character that needs attention
    Debug = { link = "Special" }, -- debugging statements

    Error = { fg = colors.red },


    -- Treesitter
    ["@parameter"] = { fg = colors.red },

    -- https://github.com/catppuccin/nvim/blob/30fa4d122d9b22ad8b2e0ab1b533c8c26c4dde86/lua/catppuccin/groups/integrations/treesitter.lua
    -- Reference: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md
    -- Identifiers
    ["@variable"] = { fg = colors.foreground }, -- Any variable name that does not have another highlight.
    ["@variable.builtin"] = { fg = colors.red }, -- Variable names that are defined by the languages, like this or self.
    ["@variable.parameter"] = { fg = colors.red }, -- For parameters of a function.
    ["@variable.member"] = { fg = colors.foreground }, -- For fields.

    ["@constant"] = { link = "Constant" }, -- For constants
    ["@constant.builtin"] = { fg = colors.orange }, -- For constant that are built in the language: nil in Lua.
    ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

    ["@module"] = { fg = colors.yellow }, -- For identifiers referring to modules and namespaces.
    ["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.

    -- Literals
    ["@string"] = { link = "String" }, -- For strings.
    ["@string.documentation"] = { fg = colors.cyan }, -- For strings documenting code (e.g. Python docstrings).
    ["@string.regexp"] = { fg = colors.magenta }, -- For regexes.
    ["@string.escape"] = { fg = colors.magenta }, -- For escape characters within a string.
    ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)
    ["@string.special.path"] = { link = "Special" }, -- filenames
    ["@string.special.symbol"] = { fg = colors.magenta }, -- symbols or atoms
    ["@string.special.url"] = { fg = colors.blue }, -- urls, links and emails
    ["@punctuation.delimiter.regex"] = { link = "@string.regexp" },

    ["@character"] = { link = "Character" }, -- character literals
    ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

    ["@boolean"] = { link = "Boolean" }, -- For booleans.
    ["@number"] = { link = "Number" }, -- For all numbers
    ["@number.float"] = { link = "Float" }, -- For floats.

    -- Types
    ["@type"] = { link = "Type" }, -- For types.
    ["@type.builtin"] = { fg = colors.magenta }, -- For builtin types.
    ["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)

    ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
    ["@property"] = { fg = colors.foreground }, -- For fields, like accessing `bar` property on `foo.bar`. Overriden later for data languages and CSS.

    -- Functions
    ["@function"] = { link = "Function" }, -- For function (calls and definitions).
    ["@function.builtin"] = { fg = colors.orange }, -- For builtin functions: table.insert in Lua.
    ["@function.call"] = { link = "Function" }, -- function calls
    ["@function.macro"] = { fg = colors.magenta }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.

    ["@function.method"] = { link = "Function" }, -- For method definitions.
    ["@function.method.call"] = { link = "Function" }, -- For method calls.

    ["@constructor"] = { fg = colors.yellow }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
    ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

    -- Keywords
    ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
    ["@keyword.modifier"] = { link = "Keyword" }, -- For keywords modifying other constructs (e.g. `const`, `static`, `public`)
    ["@keyword.type"] = { link = "Keyword" }, -- For keywords describing composite types (e.g. `struct`, `enum`)
    ["@keyword.coroutine"] = { link = "Keyword" }, -- For keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    ["@keyword.function"] = { fg = colors.magenta }, -- For keywords used to define a function.
    ["@keyword.operator"] = { fg = colors.magenta }, -- For new keyword operator
    ["@keyword.import"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
    ["@keyword.repeat"] = { link = "Repeat" }, -- For keywords related to loops.
    ["@keyword.return"] = { fg = colors.magenta },
    ["@keyword.debug"] = { link = "Exception" }, -- For keywords related to debugging
    ["@keyword.exception"] = { link = "Exception" }, -- For exception related keywords.

    ["@keyword.conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
    ["@keyword.conditional.ternary"] = { link = "Operator" }, -- For ternary operators (e.g. `?` / `:`)

    ["@keyword.directive"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
    ["@keyword.directive.define"] = { link = "Define" }, -- preprocessor definition directives
    -- JS & derivative
    ["@keyword.export"] = { fg = colors.magenta },

    -- Punctuation
    ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
    -- ["@punctuation.bracket"] = { fg = C.overlay2 }, -- For brackets and parenthesis.
    ["@punctuation.special"] = { link = "Special" }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

    -- Comment
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" }, -- For comments documenting code

    ["@comment.error"] = { fg = colors.surface0, bg = colors.red },
    ["@comment.warning"] = { fg = colors.surface0, bg = colors.yellow },
    ["@comment.hint"] = { fg = colors.surface0, bg = colors.blue },
    ["@comment.todo"] = { fg = colors.surface0, bg = colors.red },
    ["@comment.note"] = { fg = colors.surface0, bg = colors.magenta },

    -- Markup
    ["@markup"] = { fg = colors.foreground }, -- For strings considerated text in a markup language.
    ["@markup.strong"] = { fg = colors.red }, -- bold
    ["@markup.italic"] = { fg = colors.red }, -- italic
    ["@markup.strikethrough"] = { fg = colors.foreground }, -- strikethrough text
    ["@markup.underline"] = { link = "Underlined" }, -- underlined text

    ["@markup.heading"] = { fg = colors.blue }, -- titles like: # Example
    ["@markup.heading.markdown"] = {  }, -- bold headings in markdown, but not in HTML or other markup

    ["@markup.math"] = { fg = colors.blue }, -- math environments (e.g. `$ ... $` in LaTeX)
    ["@markup.quote"] = { fg = colors.magenta }, -- block quotes
    ["@markup.environment"] = { fg = colors.magenta }, -- text environments of markup languages
    ["@markup.environment.name"] = { fg = colors.blue }, -- text indicating the type of an environment

    ["@markup.link"] = { fg = colors.blue }, -- text references, footnotes, citations, etc.
    ["@markup.link.label"] = { fg = colors.blue }, -- link, reference descriptions
    ["@markup.link.url"] = { fg = colors.blue }, -- urls, links and emails

    ["@markup.raw"] = { fg = colors.green }, -- used for inline code in markdown and for doc in python (""")

    ["@markup.list"] = { fg = colors.blue },
    ["@markup.list.checked"] = { fg = colors.green }, -- todo notes
    ["@markup.list.unchecked"] = { fg = colors.surface2 }, -- todo notes


    -- Tags
    ["@tag"] = { fg = colors.cyan }, -- Tags like HTML tag names.
    ["@tag.builtin"] = { fg = colors.cyan }, -- JSX tag names.
    ["@tag.attribute"] = { fg = colors.yellow }, -- XML/HTML attributes (foo in foo="bar").
    ["@tag.delimiter"] = { fg = colors.cyan }, -- Tag delimiter like < > /

    -- Misc
    ["@error"] = { link = "Error" },

    -- Language specific:

    -- Bash
    ["@function.builtin.bash"] = { fg = colors.red },
    ["@variable.parameter.bash"] = { fg = colors.green },

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
    ["@property.css"] = { fg = colors.blue },
    ["@property.scss"] = { fg = colors.blue },
    ["@property.id.css"] = { fg = colors.yellow },
    ["@property.class.css"] = { fg = colors.yellow },
    ["@type.css"] = { fg = colors.blue },
    ["@type.tag.css"] = { fg = colors.cyan },
    ["@string.plain.css"] = { fg = colors.foreground },
    ["@number.css"] = { fg = colors.orange },
    ["@keyword.directive.css"] = { link = "Keyword" }, -- CSS at-rules: https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule.

    -- HTML
    ["@string.special.url.html"] = { fg = colors.green }, -- Links in href, src attributes.
    ["@markup.link.label.html"] = { fg = colors.foreground }, -- Text between <a></a> tags.
    ["@character.special.html"] = { fg = colors.red }, -- Symbols such as &nbsp;.

    -- TOML
    ["@property.toml"] = { fg = colors.blue }, -- For fields.

    -- JSON
    ["@property.json"] = { fg = colors.blue }, -- For fields.

    -- Lua
    ["@constructor.lua"] = { link = "@punctuation.bracket" }, -- For constructor calls and definitions: = { } in Lua.

    -- Python
    ["@constructor.python"] = { fg = colors.cyan }, -- __init__(), __new__().

    -- YAML
    ["@property.yaml"] = { fg = colors.blue }, -- For fields.
    ["@label.yaml"] = { fg = colors.yellow }, -- Anchor and alias names.

    -- Nix
    ["@variable.member.nix"] = { fg = colors.blue }, -- For fields.
    ["@lsp.type.property.nix"] = { fg = colors.blue }, -- Also for fields, from LSP.

    -- Ruby
    ["@string.special.symbol.ruby"] = { fg = colors.red },

    -- PHP
    ["@function.method.php"] = { link = "Function" },
    ["@function.method.call.php"] = { link = "Function" },

    -- C/CPP
    ["@keyword.import.c"] = { fg = colors.yellow },
    ["@keyword.import.cpp"] = { fg = colors.yellow },

    -- C#
    ["@attribute.c_sharp"] = { fg = colors.yellow },

    -- gitcommit
    ["@comment.warning.gitcommit"] = { fg = colors.yellow },

    -- gitignore
    ["@string.special.path.gitignore"] = { fg = colors.foreground },

    -- Misc
    -- gitcommitSummary = { fg = C.rosewater },

    rainbow1 = { fg = colors.red },
    rainbow2 = { fg = colors.yellow },
    rainbow3 = { fg = colors.green },
    rainbow6 = { fg = colors.cyan },
    rainbow4 = { fg = colors.blue },
    rainbow5 = { fg = colors.magenta },

    RainbowDelimiterRed = { fg = colors.red },
    RainbowDelimiterOrange = { fg = colors.orange },
    RainbowDelimiterYellow = { fg = colors.yellow },
    RainbowDelimiterGreen = { fg = colors.green },
    RainbowDelimiterBlue = { fg = colors.blue },
    RainbowDelimiterCyan = { fg = colors.cyan },
    RainbowDelimiterViolet = { fg = colors.magenta },

    AlphaButtonLabel = { fg = colors.green, bold = true },
    AlphaButtonSides = { fg = colors.surface2 },
    AlphaHeader = { fg = colors.red },
    AlphaDivider = { fg = colors.yellow },

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
