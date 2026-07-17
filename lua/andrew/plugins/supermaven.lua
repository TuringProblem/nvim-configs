return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy", -- fires regardless of whether a file buffer was opened
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
