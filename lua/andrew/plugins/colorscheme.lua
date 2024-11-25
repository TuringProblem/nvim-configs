return {
  {
    dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
    name = "fallguy",
    config = function()
      require("colors.fallguy").setup()
      vim.cmd("colorscheme mytheme")
    end,
  },
}

