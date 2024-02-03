return {
  'mbbill/undotree',
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false
    },
    config = function(_, opts)
      local lang_utils = require('treesj.langs.utils')
      opts.langs = {
        groovy = {
          map = lang_utils.set_preset_for_dict({
            join = { space_in_brackets = false }
          }),
          argument_list = lang_utils.set_preset_for_args(),
          list = lang_utils.set_preset_for_list({
            join = { space_in_brackets = false }
          }),
        }
      }
      require('treesj').setup(opts)
    end,
    init = function()
      vim.keymap.set('n', '<leader>m', require('treesj').toggle, { desc = "split/join (TreeSJ)"})
    end,
  },
  {
    'gbprod/yanky.nvim',
    opts = {
      highlight = {
        timer = 200,
      },
    },
    init = function()
      vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
      vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
      vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
      vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")
      vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
      vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")

      vim.keymap.set({"n","x"}, "y", "<Plug>(YankyYank)")

      vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
      vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
      vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

      vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
      vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
      vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
      vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

      vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
      vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")
      -- local colors = require('catppuccin.palettes').get_palette('mocha')
      -- vim.api.nvim_set_hl(0, 'YankyPut', { bg = colors.sky })
    end,
  },

  { 'numToStr/Comment.nvim', opts = {} },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "gs",
          visual_line = "gS"
        }
      })
    end
  },
  {
    "chrisgrieser/nvim-spider",
    init = function ()
      vim.keymap.set(
        { "n", "o", "x" },
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        { desc = "Spider-w" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        { desc = "Spider-e" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        { desc = "Spider-b" }
      )
      vim.keymap.set(
        { "n", "o", "x" },
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        { desc = "Spider-ge" }
      )
      -- retain access to classic iw
      vim.keymap.set({ 'n', 'o', 'x' }, 'gw', 'w')
      -- clashes with comment blockwise
      -- vim.keymap.set({ 'n', 'o', 'x' }, 'gb', 'b')
      vim.keymap.set({ 'o', 'x' }, 'igw', 'iw')
      vim.keymap.set({ 'o', 'x' }, 'agw', 'aw')
    end
  },

  {
    "chrisgrieser/nvim-various-textobjs",
    lazy = false,
    opts = { useDefaultKeymaps = false },
    init = function ()
      vim.keymap.set({ "o", "x" }, "aw", '<cmd>lua require("various-textobjs").subword("outer")<CR>')
      vim.keymap.set({ "o", "x" }, "iw", '<cmd>lua require("various-textobjs").subword("inner")<CR>')
      vim.keymap.set({ "o", "x" }, "ii", '<cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>')
      vim.keymap.set({ "o", "x" }, "ai", '<cmd>lua require("various-textobjs").indentation("outer", "inner")<CR>')
      vim.keymap.set({ "o", "x" }, "i|", '<cmd>lua require("various-textobjs").shellPipe("inner")<CR>')
      vim.keymap.set({ "o", "x" }, "a|", '<cmd>lua require("various-textobjs").shellPipe("outer")<CR>')
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  "lambdalisue/suda.vim",
  {
    "monaqa/dial.nvim",
    init = function()
      vim.keymap.set("n", "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, { noremap = false })
      vim.keymap.set("n", "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, { noremap = false })
      vim.keymap.set("v", "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, { noremap = false })
      vim.keymap.set("v", "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, { noremap = false })
      vim.keymap.set("n", "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, { noremap = false })
      vim.keymap.set("n", "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, { noremap = false })
      vim.keymap.set("v", "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, { noremap = false })
      vim.keymap.set("v", "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, { noremap = false })
    end,
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group{
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.constant.new{ elements = {"let", "const"} },
        },
        python = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new{ elements = {"True", "False"} },
        },
      }
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typescript",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("typescript"), { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("typescript"), { noremap = true })
        end
      }
      )
    end
  },
  {
    -- "m4xshen/hardtime.nvim",
    -- dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    -- opts = {
    --   disable_mouse = false,
    -- }
  },
}
