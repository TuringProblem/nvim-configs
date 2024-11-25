
local colors = {
  -- GUI Colors
  bg = "#883000",
  fg = "#ffd22b", -- Bright orange
  cursor = "#000000",
  carot = "#",
  

  -- Syntax Colors
  funcName = "#ffffff",
  var = "#ff8503",
  conditional = "#000000",
  func = "#700e01", -- Dark orange 

}

local function setHighlight()
  local hl = vim.api.nvim_set_hl

  -- GUI
  hl(0, "Normal", { fg = colors.fg, bg = colors.bg})

  -- Syntax 
  hl(0, "Identifier", { fg = colors.var})
  hl(0, "Function", { fg = colors.funcName})
  hl(0, "Conditional", { fg = colors.var})
  hl(0, "Type", { fg = colors.var})
  hl(0, "Conditional", { fg = colors.conditional})
  hl(0, "Statement", { fg = colors.func})
  hl(0, "String", { fg = colors.var})
  

end

local M = {}

M.setup = function()
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")
    vim.g.colors_name = "fallguy"
    setHighlight()
end

return M




