
local colors = {
  -- GUI Colors
  bg = "#700e01", -- Dark orange 
  fg = "#ffd22b", -- Bright orange
  

  -- Syntax Colors
  

}

local function setHighlight()
  local hl = vim.api.nvim_set_hl
  hl(0, "Normal", { fg = colors.fg, bg = colors.bg})
end

local M = {}

M.setup = function()
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")
    vim.g.colors_name = "fallguy"
    setHighlight()
end

return M




