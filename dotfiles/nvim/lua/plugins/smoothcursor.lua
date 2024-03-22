return {
  "gen740/SmoothCursor.nvim",
  event = "VeryLazy",
  config = function()
    require("smoothcursor").setup({
      type = "exp",
      -- type = "matrix",
      -- fancy = {
      --   enable = true,
      -- },
    })
  end,
}
