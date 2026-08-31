vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

local color_path = "colors.homegrown.themes.midnight-coder.midnight-coder-light"

vim.o.background = "light"
vim.o.termguicolors = true
vim.g.colors_name = "midnight-coder-light"

local theme = require(color_path)
theme.set_highlights()
