return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "BufRead", -- or any appropriate lazy-loading event
    config = function()
      require("supermaven-nvim").setup({})
    end,
  },
}
