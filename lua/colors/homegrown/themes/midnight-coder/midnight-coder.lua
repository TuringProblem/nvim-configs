local c = require("colors.homegrown.palette")
local comments = "#2CACCF"
local midnight_sky = "#008378"


local backgroundColor = function()
  return { fg = c.white.azure_white, bg = c.black.rich_black, italic = true }
end

local errorColor = function()
  return { fg = c.red.chili_red, bg = c.gray.dim_gray }
end

local custom = function(f, color)
  return { fg = f(color) }
end

local midnight_igloo = function()
  return { fg = comments, italic = true }
end

local midnight_java = function()
  return { fg = c.black.rich_black, bg = c.green.jade, italic = true }
end

local midnight_skyrizi = function()
  return { fg = c.green.jade, bg = c.green.olo, italic = true }
end



local f = vim.api.nvim_set_hl
local theme = {}


-- what color should I make it?

-- alight... what is your pallet
-- I need to fix this fucking color scheme
theme.set_highlights = function()
  f(0, "Normal", backgroundColor())
  f(0, "SignColumn", { fg = c.purple[1].byzantium, bg = c.black.dim_gray })

  f(0, "Cursor", { fg = c.black.vantablack, bg = c.cursor_bg })
  -- Code - Tsoding style: simple and clean
  f(0, "Comment", midnight_igloo())
  f(0, "Variable", { fg = c.blue.lavender })
  f(0, "String", { fg = c.blue.moroccan_blue })
  f(0, "Character", { fg = c.blue.bondi_blue })
  f(0, "Number", {})
  f(0, "Float", {})
  f(0, "Boolean", { fg = c.magenta.chinese_violet })
  f(0, "Constant", { fg = c.green.magic_mint })
  f(0, "Type", { fg = c.brown.desert_sand })
  f(0, "Function", { fg = c.blue.turquoise, italic = true })
  f(0, "Keyword", { fg = midnight_sky, italic = true })
  f(0, "Conditional", midnight_skyrizi())
  f(0, "Repeat", {})
  f(0, "Operator", {})
  f(0, "PreProc", {})
  f(0, "Include", {})
  f(0, "Exception", { fg = c.red.chili_red })
  f(0, "StorageClass", {})
  f(0, "Structure", {})
  f(0, "Typedef", {})
  f(0, "Define", {})
  f(0, "Macro", { fg = c.red.tea_rose })
  f(0, "Debug", errorColor())
  f(0, "Title", {})
  f(0, "Label", {})
  f(0, "SpecialChar", {})
  f(0, "Delimiter", { fg = c.brown.almond })
  f(0, "SpecialComment", {})
  f(0, "Tag", {})
  f(0, "Bold", {})
  f(0, "Italic", {})
  f(0, "Underlined", {})
  f(0, "Ignore", {})
  f(0, "Todo", errorColor())
  f(0, "Error", errorColor())
  f(0, "Statement", {})
  f(0, "Identifier", {})
  f(0, "PreCondit", {})
  f(0, "Special", {})

  -- LSP
  f(0, "DiagnosticHint", {})
  f(0, "DiagnosticInfo", {})
  f(0, "DiagnosticWarn", {})
  f(0, "DiagnosticError", {})
  f(0, "DiagnosticOther", {})
  f(0, "DiagnosticSignHint", {})
  f(0, "DiagnosticSignInfo", {})
  f(0, "DiagnosticSignWarn", {})
  f(0, "DiagnosticSignError", {})
  f(0, "DiagnosticSignOther", {})
  f(0, "DiagnosticSignWarning", {})
  f(0, "DiagnosticFloatingHint", {})
  f(0, "DiagnosticFloatingInfo", {})
  f(0, "DiagnosticFloatingWarn", {})
  f(0, "DiagnosticFloatingError", {})
  f(0, "DiagnosticUnderlineHint", {})
  f(0, "DiagnosticUnderlineInfo", {})
  f(0, "DiagnosticUnderlineWarn", {})
  f(0, "DiagnosticUnderlineError", {})
  f(0, "DiagnosticSignInformation", {})
  f(0, "DiagnosticVirtualTextHint", {})
  f(0, "DiagnosticVirtualTextInfo", {})
  f(0, "DiagnosticVirtualTextWarn", {})
  f(0, "DiagnosticVirtualTextError", {})
  f(0, "LspDiagnosticsError", {})
  f(0, "LspDiagnosticsWarning", {})
  f(0, "LspDiagnosticsInfo", {})
  f(0, "LspDiagnosticsInformation", {})
  f(0, "LspDiagnosticsHint", {})
  f(0, "LspDiagnosticsDefaultError", {})
  f(0, "LspDiagnosticsDefaultWarning", {})
  f(0, "LspDiagnosticsDefaultInformation", {})
  f(0, "LspDiagnosticsDefaultInfo", {})
  f(0, "LspDiagnosticsDefaultHint", {})
  f(0, "LspDiagnosticsVirtualTextError", {})
  f(0, "LspDiagnosticsVirtualTextWarning", {})
  f(0, "LspDiagnosticsVirtualTextInformation", {})
  f(0, "LspDiagnosticsVirtualTextInfo", {})
  f(0, "LspDiagnosticsVirtualTextHint", {})
  f(0, "LspDiagnosticsFloatingError", {})
  f(0, "LspDiagnosticsFloatingWarning", {})
  f(0, "LspDiagnosticsFloatingInformation", {})
  f(0, "LspDiagnosticsFloatingInfo", {})
  f(0, "LspDiagnosticsFloatingHint", {})
  f(0, "LspDiagnosticsSignError", {})
  f(0, "LspDiagnosticsSignWarning", {})
  f(0, "LspDiagnosticsSignInformation", {})
  f(0, "LspDiagnosticsSignInfo", {})
  f(0, "LspDiagnosticsSignHint", {})
  f(0, "NvimTreeLspDiagnosticsError", {})
  f(0, "NvimTreeLspDiagnosticsWarning", {})
  f(0, "NvimTreeLspDiagnosticsInformation", {})
  f(0, "NvimTreeLspDiagnosticsInfo", {})
  f(0, "NvimTreeLspDiagnosticsHint", {})
  f(0, "LspDiagnosticsUnderlineError", {})
  f(0, "LspDiagnosticsUnderlineWarning", {})
  f(0, "LspDiagnosticsUnderlineInformation", {})
  f(0, "LspDiagnosticsUnderlineInfo", {})
  f(0, "LspDiagnosticsUnderlineHint", {})
  f(0, "LspReferenceRead", {})
  f(0, "LspReferenceText", {})
  f(0, "LspReferenceWrite", {})
  f(0, "LspCodeLens", {})
  f(0, "LspCodeLensSeparator", {})

  -- Quickscope
  f(0, "QuickScopePrimary", {})
  f(0, "QuickScopeSecondary", {})

  -- Telescope
  f(0, "TelescopeSelection", {})
  f(0, "TelescopeSelectionCaret", {})
  f(0, "TelescopeMatching", {})
  f(0, "TelescopeBorder", midnight_java())
  f(0, "TelescopeNormal", {})
  f(0, "TelescopePromptTitle", {})
  f(0, "TelescopePromptPrefix", {})
  f(0, "TelescopeResultsTitle", {})
  f(0, "TelescopePreviewTitle", {})
  f(0, "TelescopePromptCounter", {})
  f(0, "TelescopePreviewHyphen", {})

  -- NvimTree
  f(0, "NvimTreeFolderIcon", {})
  f(0, "NvimTreeIndentMarker", {})
  f(0, "NvimTreeNormal", {})
  f(0, "NvimTreeVertSplit", {})
  f(0, "NvimTreeFolderName", {})
  f(0, "NvimTreeOpenedFolderName", {})
  f(0, "NvimTreeEmptyFolderName", {})
  f(0, "NvimTreeGitIgnored", {})
  f(0, "NvimTreeImageFile", {})
  f(0, "NvimTreeSpecialFile", {})
  f(0, "NvimTreeEndOfBuffer", {})
  f(0, "NvimTreeCursorLine", {})
  f(0, "NvimTreeGitStaged", {})
  f(0, "NvimTreeGitNew", {})
  f(0, "NvimTreeGitRenamed", {})
  f(0, "NvimTreeGitDeleted", {})
  f(0, "NvimTreeGitMerge", {})
  f(0, "NvimTreeGitDirty", {})
  f(0, "NvimTreeSymlink", {})
  f(0, "NvimTreeRootFolder", {})
  f(0, "NvimTreeExecFile", {})
end

local MODULE = "colors.homegrown.themes.midnight-coder.midnight-coder"

-- Live-reload: on save, bust the require cache for this theme (and its
-- palette) so edits are picked up, then re-apply the highlights.
local function live_reload()
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("MidnightCoderReload", { clear = true }),
    pattern = "*/themes/midnight-coder/midnight-coder.lua",
    callback = function()
      package.loaded[MODULE] = nil
      package.loaded["colors.homegrown.palette"] = nil
      local ok, fresh = pcall(require, MODULE)
      if not ok then
        vim.notify("midnight-coder reload failed: " .. fresh, vim.log.levels.ERROR)
        return
      end
      fresh.setup()
      vim.cmd("redraw!")
    end,
  })
end

function theme.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = "west-coast-sunset"
  theme.set_highlights()
  live_reload()
end

return theme
