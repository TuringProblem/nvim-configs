
-- Define colors
local colors = {
  -- GUI
  bg = "#232b2b", -- Background
  func = "#ffffff",
  main = "#3DED97", -- Main color -> Light Green
  mainDeep = "#05371b", -- Deep being a darker green
  secondary = "#82EEFD", -- Secondary Color -> Light blue
  red = "#8f5458",
  creamOrange = "#ee9d83",


  -- Syntax
  string = "#000000",
  conditional = "#3ded97",
  const = "#355c7d",
  var = "#ffffff",
  op = "#000000",
}

-- Define function to set highlights
local function setHighlight()
    local hl = vim.api.nvim_set_hl

    -- General UI
    hl(0, "Normal", { fg = colors.main, bg = colors.bg })
    hl(0, "CursorLine", { bg = colors.bg})
    hl(0, "Visual", { bg = colors.red })
    hl(0, "LineNr", { fg = colors.secondary })
    hl(0, "CursorLineNr", { fg = colors.main})

    -- Syntax Highlighting
    hl(0, "TsVariable", { fg = colors.const})
    hl(0, "Comment", { fg = colors.mainDeep })
    hl(0, "conditional", { fg = colors.mainDeep })
    hl(0, "Identifier", { fg = colors.var }) -- For all var names
    hl(0, "Operator", { fg = colors.op }) -- For Operators
    hl(0, "Special", { fg = colors.main }) -- For Operators
    hl(0, "String", { fg = colors.string})
    hl(0, "Keyword", { fg = colors.conditional})
    hl(0, "Function", { fg = colors.mainDeep })
    hl(0, "Variable", { fg = colors.creamOrange})
    hl(0, "Type", { fg = colors.creamOrange })
    hl(0, "Constant", { fg = colors.const})
end

-- Export the colorscheme module
local M = {}

M.setup = function()
    vim.cmd("highlight clear")
    vim.cmd("syntax reset")
    vim.g.colors_name = "mytheme" -- Set the colorscheme name
    setHighlight() -- Apply the highlights
end

return M

