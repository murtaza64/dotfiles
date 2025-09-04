return {
  "folke/noice.nvim",
  event = "VeryLazy",
  name = 'noice',
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {},
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = "^:", icon = ":", lang = "vim" },
        search_down = { view = "cmdline", kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { view = "cmdline", kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = false,
        input = {}, -- Used by input()
        -- lua = false, -- to disable a format, set to `false`
      },
    },
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      progress = {
        view = "mini_lsp_progress",
      },
      signature = {
        enabled = false
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    messages = {
      view = "mini",
      view_error = "mini",
      view_warn = "mini",
      view_search = "virtualtext",
    },
    -- you can enable a preset for easier configuration
    views = {
      notify_lsp = {
        backend = "notify",
        fallback = "mini",
        format = "notify",
        replace = true,
        merge = false,
      },
      mini_lsp_progress = {
        backend = "mini",
        relative = "editor",
        align = "message-right",
        timeout = 2000,
        reverse = true,
        focusable = false,
        position = {
          row = -1,
          col = "100%",
          -- col = 0,
        },
        size = "auto",
        border = {
          style = "none",
        },
        zindex = 59,
        win_options = {
          winbar = "",
          foldenable = false,
          winblend = 30,
          winhighlight = {
            Normal = "NoiceMini",
            IncSearch = "",
            CurSearch = "",
            Search = "",
          },
        },
      },
      mini_showmode = {
        backend = "mini",
      },
      mini = {
        align = "message-right",
        timeout = 4000,
        position = {
          row = -1,
          col = "100%",
        }
      },
      hover = {
        anchor = "SW",
        position = { row = 0, col = 0 },
      },
    },
    routes = {
      -- {
      --   filter = { event = "msg_show", find = "Do you really want to" },
      --   view = "popup",
      -- },
      -- {
      --   filter = { event = "msg_show", find = "!!!" },
      --   view = "popup",
      -- },
    },
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    {
      "rcarriga/nvim-notify",
      opts = {
        -- render = 'compact',
        minimum_width = 1,
        -- top_down = false,
      },
      config = function(_, opts)
        local stages_util = require("notify.stages.util")
        local base = require("notify.render.base")
        opts.render = function(bufnr, notif, highlights)
          local namespace = base.namespace()
          local icon = notif.icon
          local title = notif.title[1]

          local prefix
          -- if type(title) == "string" and #title > 0 then
          --   prefix = string.format("%s  %s", icon, title)
          -- else
          --   prefix = string.format("%s", icon)
          -- end
          prefix = string.format("%s", icon)
          notif.message[1] = string.format("%s  %s", prefix, notif.message[1])

          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

          local icon_length = vim.str_utfindex(icon)
          local prefix_length = vim.str_utfindex(prefix)

          vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
            hl_group = highlights.icon,
            end_col = icon_length + 1,
            priority = 50,
          })
          vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
            hl_group = highlights.title,
            end_col = prefix_length + 2,
            priority = 50,
          })
          vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, prefix_length + 2, {
            hl_group = highlights.body,
            end_line = #notif.message,
            priority = 50,
          })
        end
        opts.stages = {
          function(state)
            local next_height = state.message.height + 1
            local next_row = stages_util.available_slot(
              state.open_windows,
              next_height,
              stages_util.DIRECTION.BOTTOM_UP
            )
            if not next_row then
              return nil
            end
            return {
              relative = "editor",
              anchor = "NE",
              width = state.message.width,
              height = state.message.height,
              col = vim.opt.columns:get(),
              row = next_row,
              border = "none",
              style = "minimal",
            }
          end,
          function(state, win)
            return {
              col = vim.opt.columns:get(),
              time = true,
              row = stages_util.slot_after_previous(
                win,
                state.open_windows,
                stages_util.DIRECTION.BOTTOM_UP
              ),
            }
          end,
        }
        require("notify").setup(opts)
      end,
    },
  },
}
