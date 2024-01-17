local config_telescope = function()
  local lga_actions = require("telescope-live-grep-args.actions")
  local quote_prompt = lga_actions.quote_prompt()
  local glob = lga_actions.quote_prompt({ postfix = " --iglob " })
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
          ['<C-v>'] = require('telescope.actions.layout').toggle_preview,
        },
      },
    },
    extensions = {
      live_grep_args = {
        auto_quoting = true, -- enable/disable auto-quoting
        -- define mappings, e.g.
        mappings = { -- extend mappings
          i = {
            ["<C-k>"] = quote_prompt,
            ["<C-g>"] = glob,
          },
        },
        -- ... also accepts theme settings, for example:
        -- theme = "dropdown", -- use dropdown theme
        -- theme = { }, -- use own theme spec
        -- layout_config = { mirror=true }, -- mirror preview pane
      }
    }
  }

  require("telescope").load_extension("live_grep_args")

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
  -- vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>ff', function()
    require('telescope.builtin').find_files({
      -- find_command = {"find", "-L", "-not", "-path", "**/.git/*"},
      find_command = {'fd', '-E', '.git', '-E', '.build' },
      hidden = true,
      follow = true,
      no_ignore = false,
      no_ignore_parent = false,
      prompt_title = "Find Files"
    })
  end, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fa', function()
    require('telescope.builtin').find_files({
      -- find_command = {"find", "-L", "-not", "-path", "**/.git/*"},
      find_command = {'fd', '-E', '.git', '-E', '.build' },
      hidden = true,
      follow = true,
      no_ignore = true,
      no_ignore_parent = false,
      prompt_title = "Find All Files"
    })
  end, { desc = '[F]ind [A]ll' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('v', '<leader>sg', function ()
    local text = table.concat(require('utils').get_visual_text(), '\n')
    require('telescope').extensions.live_grep_args.live_grep_args({ default_text = text })
  end, { desc = '[S]earch by [G]rep selection' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
end
return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
      },
    },
    config = config_telescope,
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}
