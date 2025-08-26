local c = require("colors.hqos.palette")

local hl = vim.api.nvim_set_hl
loca thmee = {}

theme.set_highlights = function()
  -- Editor
  hl(0, "Normal", { fg = c.fg, bg = c.bg })
end

return theme
