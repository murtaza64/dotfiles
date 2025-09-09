local signature_opts = {
  -- floating_window = false,
  doc_lines = 0,
  floating_window_off_x = 0,

  hint_enable = false,
  hint_prefix = '',
  hint_scheme = 'LspSignatureHint',
  handler_opts = {
    border = 'none'
  }
}


local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  require('lsp_signature').on_attach(signature_opts, bufnr)

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- ruby_lsp = {},
  rust_analyzer = {},
  ts_ls = {},
  html = {},
  cssls = {},
  -- terraform_lsp = {},
  -- jdtls = {},
  -- zls = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

local config_cmp = function()
  -- [[ Configure nvim-cmp ]]
  -- See `:help cmp`
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'
  require('luasnip.loaders.from_vscode').lazy_load()
  luasnip.config.setup {}

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-n>'] = function(fallback) fallback() end,
      ['<C-p>'] = function(fallback) fallback() end,
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-.>'] = cmp.mapping.complete {},
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    },
  }
end

return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'ray-x/lsp_signature.nvim',

    -- Couldn't get this to work
    -- {
    --   'xbase-lab/xbase',
    --   build = 'make install',
    --   config = function()
    --     require('xbase').setup({})
    --   end,
    -- },

    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',
        -- buffer words
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets',
      },
      config = config_cmp,
    },

    -- { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
  },
  config = function()
    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure the servers above are installed
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }
    -- mason_lspconfig.setup_handlers {
    --   function(server_name)
    --     require('lspconfig')[server_name].setup {
    --       capabilities = capabilities,
    --       on_attach = on_attach,
    --       settings = servers[server_name],
    --     }
    --   end,
    --
    --   jdtls = function() end
    -- }
    require('lspconfig').clangd.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { 'clangd', '--offset-encoding=utf-16' },
    }

    local shellcheck = {
      prefix = 'shellcheck',
      -- lintCommand = 'shellcheck --color=never --format=gcc -',
      lintIgnoreExitCode = true,
      rootMarkers = {},
      lintCommand = 'shellcheck -f gcc -x',
      lintSource = 'shellcheck',
      lintFormats = {
        '%f:%l:%c: %trror: %m',
        '%f:%l:%c: %tarning: %m',
        '%f:%l:%c: %tote: %m'
      }
    }
    local jenkins = {
      prefix = 'jenkins',
      lintSource = 'jenkins',
      lintCommand = 'jenkins-validate',
      lintIgnoreExitCode = true,
      lintFormats = {
        '%l:%c: %m'
      }
    }
    -- require('lspconfig')['efm'].setup {
    --   init_options = {documentFormatting = true},
    --   filetypes = { 'sh', 'groovy', 'jenkins' },
    --   -- capabilities = capabilities,
    --   on_attach = on_attach,
    --   settings = {
    --     logLevel = 1,
    --     logFile = '/Users/murtaza/efm-nvim.log',
    --     rootMarkers = {".git/"},
    --     languages = {
    --       -- lua = {
    --       --   -- {formatCommand = "lua-format -i", formatStdin = true}
    --       -- },
    --       sh = {
    --         shellcheck
    --       },
    --       groovy = {
    --         jenkins
    --       },
    --       jenkins = {
    --         jenkins
    --       },
    --     }
    --   }
    -- }
    require('lspconfig')['hls'].setup{
      filetypes = { 'haskell', 'lhaskell', 'cabal' },
    }

    -- require('lspconfig')['basedpyright'].setup{
    --   settings = {
    --     basedpyright = {
    --       analysis = {
    --         typeCheckingMode = "standard"
    --       },
    --     }
    --   },
    --   on_attach = on_attach,
    --   root_markers = { ".python-version", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" }
    -- }
    vim.lsp.enable('basedpyright')
    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard"
          },
        }
      },
      on_attach = on_attach,
    })
    

    require('lspconfig')['svelte'].setup {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
          end,
        })
      end,
    }
    -- require("lspconfig")["gdscript"].setup({
    --   name = "godot",
    --   cmd = {"godot-wsl-lsp", "--host", "localhost"},
    --   on_attach = on_attach,
    -- })

    -- require'lspconfig'.sourcekit.setup{
    --   cmd = {'xcrun', 'sourcekit-lsp'},
    --   on_attach = on_attach,
    -- }

    vim.diagnostic.config {
      severity_sort = true,
      virtual_text = false,
      float = {
        header = false,
      }
    }
    local signs = { Error = " ", Warn = " ", Hint = "󱠃", Info = " " }
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.INFO] = signs.Info,
          [vim.diagnostic.severity.HINT] = signs.Hint,
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
          [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
          [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        }
      }
    })
  end
}
