
return {
  {
    'zbirenbaum/copilot.lua',
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = '<C-l>',
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-c>',
        }
      }
    },
    config = true
  },
  'AndreM222/copilot-lualine',
}
