vim.api.nvim_create_user_command("ModalDiff", function()
  require("modaldiff").toggle()
end, {})
