return {
  {
    dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
    name = "mytheme",
    config = function()
      require("colors.mytheme").setup()
      vim.cmd("colorscheme mytheme")
    end,
  },
}

