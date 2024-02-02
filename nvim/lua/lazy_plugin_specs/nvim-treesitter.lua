local opts = {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'bash',
    'c',
    'css',
    'cpp',
    'go',
    'html',
    'javascript',
    'lua',
    'python',
    'rust',
    'terraform',
    'tsx',
    'typescript',
    'vimdoc',
    'vim',
    'xml',
    'yaml',
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<space>v',
      node_incremental = 'n',
      scope_incremental = 's',
      node_decremental = 'N',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@call.outer',
        ['ic'] = '@call.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup(opts)
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.groovy = {
        install_info = {
          url = "~/tree-sitter-groovy", -- local path or git repo
          files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
          -- optional entries:
          generate_requires_npm = false, -- if stand-alone parser without npm dependencies
          requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
        },
        -- filetype = "groovy", -- if filetype does not match the parser name
      }
      vim.treesitter.language.register('groovy', 'jenkins')
      vim.treesitter.language.register('python', 'xsh')
    end
  },
  'nvim-treesitter/playground',
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   config = function()
  --     require('treesitter-context').setup({})
  --     local colors = require('catppuccin.palettes').get_palette()
  --     vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = colors.surface0 })
  --     vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { bg = colors.surface0, fg = colors.surface2})
  --   end
  -- }
}
