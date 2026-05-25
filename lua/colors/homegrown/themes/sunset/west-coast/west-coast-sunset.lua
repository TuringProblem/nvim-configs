local c = require("colors.homegrown.palette")
local f = vim.api.nvim_set_hl
local theme = {}

theme.set_highlights = function()
  f(0, "Normal", { fg = c.white.azure_white, bg = c.black.dim_gray })
end

function theme.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = "west-coast-sunset"
  theme.set_highlights()
end

return theme
