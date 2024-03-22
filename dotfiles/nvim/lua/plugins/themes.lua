return {
  -- "ellisonleao/gruvbox.nvim",
  -- opts = {
  --   transparent_mode = true,
  -- },

  "neanias/everforest-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("everforest").setup({
      opts = {
        background = "soft",
        transparent_background_level = 2,
      },
    })
  end,
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "everforest",
    },
  },
}
