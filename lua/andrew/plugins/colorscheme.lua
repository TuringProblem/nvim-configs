return {
  {
    dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
    name = "og",
    config = function()
      require("colors.og").setup()
      vim.cmd("colorscheme mytheme")
    end,
  },
}

