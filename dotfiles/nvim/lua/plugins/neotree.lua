return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", "<cmd>Neotree focus<cr>", desc = "Neotree Focus" },
  },
  config = function()
    require("neo-tree").setup({
      event_handlers = {
        {
          event = "file_opened",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    })
  end,
}
