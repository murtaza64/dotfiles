
return {
  {
    'gsuuon/model.nvim',

    -- Don't need these if lazy = false
    cmd = { 'M', 'Model', 'Mchat' },
    init = function()
      vim.filetype.add({
        extension = {
          mchat = 'mchat',
        }
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "mchat",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, 'n', '<C-m>d', ':Mdelete<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, 'n', '<C-m>s', ':Mselect<CR>', { noremap = true, silent = true })
          vim.api.nvim_buf_set_keymap(0, 'n', '<C-m><Space>', ':Mchat<CR>', { noremap = true, silent = true })
        end
      })
    end,
    ft = 'mchat',

    -- keys = {
    --   {'<C-m>d', ':Mdelete<cr>', mode = 'n'},
    --   {'<C-m>s', ':Mselect<cr>', mode = 'n'},
    --   {'<C-m><space>', ':Mchat<cr>', mode = 'n' }
    -- },

    -- To override defaults add a config field and call setup()

    config = function()
      local curl = require('model.util.curl')
      local util = require('model.util')
      local DUOLINGO_JWT = os.getenv('DUOLINGO_JWT')
      local ai_completions_backend = {
        request_completion = function(handlers, params, options)
          curl.request(
            {
              url = 'https://duolingo-ai-completions-prod.duolingo.com/1/ai-completions/chat-completions',
              method = 'PUT',
              headers = {
                ['Content-Type'] = 'application/json',
                ['Authorization'] = 'Bearer ' .. DUOLINGO_JWT,
              },
              body = params,
            },
            function(resp)
              local data = util.json.decode(resp)
              handlers.on_finish(data.message.content)
            end,
            handlers.on_error
          )
        end
      }

      local duo_chat = {
        provider = ai_completions_backend,
        system = 'You are an in-editor assistant to a software engineer. \
          The engineer will assume you know software principles and terminology. \
          Always provide some answer, even if it is just a guess. \
          Try to be as helpful as possible. \
          Try to be as concise as possible. \
          Try to respond with code snippets when possible. ',
        params = {
          userId = 1832845629,
          modelParameters = {
            model = "gpt-4-1106-preview",
            maxTokens = 512,
            topP = 1.0,
          },
          taskName = "general",
        },
        create = function(input, context)
          return context.selection and input or ''
        end,
        run = function(messages, config)
          if config.system then
            table.insert(messages, 1, {
              role = 'system',
              content = config.system
            })
          end

          return { messages = messages }
        end
      }
      require('model').setup({
        prompts = {},
        chats = { duo = duo_chat },
      })
    end
  }
}
