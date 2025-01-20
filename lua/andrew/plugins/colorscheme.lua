return {
  {
    dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
    name = "military",
    config = function()
      require("colors.military").setup()
      vim.cmd("colorscheme mytheme")
    end,
  },
}

