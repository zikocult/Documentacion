return {
  {
    "eduardomosko/header42.nvim",
    lazy = false,
    config = function()
      local header = require("header42")
      header.setup({
        user = "ZikoCult",
        mail = "ZikoCult@student.42barcelona.com",
        -- You can also extend filetypes, e.g:
        ft = {
          lua = {
            start_comment = "--",
            end_comment = "--",
            fill_comment = "-",
          },
        },
      })
    end,
  },
}
