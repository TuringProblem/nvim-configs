-- midnight-coder-light
-- Daylight counterpart to midnight-coder. Same hue DNA (teal / cyan / blue core,
-- violet + warm-sand accents), lightness inverted.
--
-- Rules this file follows, so it stays "clean" and not a flash bang:
--   * Background is warm paper (#F2F0EA), never #FFFFFF. Pure white on a bright
--     screen is the flash bang.
--   * Every syntax color is >= 4.4:1 against that paper (WCAG AA body text).
--   * Only comments and punctuation sit below 4.5 -- they are meant to recede.
--   * Accent hues are darkened + saturated versions of the dark theme's, so the
--     two themes read as one family.
--
-- Palette is local (not colors.homegrown.palette): the shared shades are tuned
-- for dark backgrounds and wash out on paper.

local p = {
  -- surfaces
  paper      = "#F2F0EA", -- Normal bg
  paper_dim  = "#E9E7DF", -- floats, pmenu, statusline
  paper_deep = "#DFDDD3", -- pmenu sel, tabline fill
  cursorline = "#EAE8E0",
  visual     = "#D3E2E6", -- cool tint so selection separates from cursorline
  border     = "#C6C8C0",

  -- ink
  ink        = "#1B2733", -- fg  (13.3:1)
  ink_soft   = "#4A5C6A", -- operators, delimiters that must still read (6.1:1)
  ink_mute   = "#7A8894", -- line numbers, whitespace, ignore
  ink_ghost  = "#B4BAC0", -- indent guides, end-of-buffer

  -- accents (dark-theme hue -> darkened light-theme twin)
  cyan       = "#5E8496", -- comments        <- #2CACCF
  teal       = "#00786E", -- keywords        <- #008378
  teal_deep  = "#0A5C4C", -- conditional fg  <- jade
  teal_wash  = "#DBEDE7", -- conditional bg  <- olo
  aqua       = "#0A6E8A", -- functions       <- turquoise
  aqua_alt   = "#0A6E92", -- characters      <- bondi blue
  blue       = "#2361B8", -- strings         <- moroccan blue
  violet     = "#7A3EA8", -- variables       <- lavender
  magenta    = "#9A3E86", -- booleans        <- chinese violet
  jade       = "#0B7A5B", -- constants       <- magic mint
  sienna     = "#9A5B2D", -- types           <- desert sand
  sand       = "#8A7A6A", -- delimiters      <- almond
  amber      = "#A34D06", -- numbers         (new: keeps the cool tones honest)
  rose       = "#B5485C", -- macros          <- tea rose
  red        = "#B3261E", -- errors          <- chili red
  red_wash   = "#F6DCD8",
  green      = "#1F7A3D", -- diff add / git
  green_wash = "#DDEEDF",
  yellow     = "#8A6A00", -- warnings
  yellow_wash = "#F2E9CC",
  blue_wash  = "#DCE6F4",
}

local backgroundColor = function()
  return { fg = p.ink, bg = p.paper }
end

local errorColor = function()
  return { fg = p.red, bg = p.red_wash }
end

local midnight_igloo = function()
  return { fg = p.cyan, italic = true }
end

local midnight_java = function()
  return { fg = p.teal, bg = p.paper_dim }
end

local midnight_skyrizi = function()
  return { fg = p.teal_deep, bg = p.teal_wash, italic = true }
end

local f = vim.api.nvim_set_hl
local theme = {}

theme.set_highlights = function()
  -- Editor chrome
  f(0, "Normal", backgroundColor())
  f(0, "NormalNC", backgroundColor())
  f(0, "NormalFloat", { fg = p.ink, bg = p.paper_dim })
  f(0, "FloatBorder", { fg = p.border, bg = p.paper_dim })
  f(0, "FloatTitle", { fg = p.teal, bg = p.paper_dim, bold = true })
  f(0, "SignColumn", { fg = p.ink_mute, bg = p.paper })
  f(0, "FoldColumn", { fg = p.ink_ghost, bg = p.paper })
  f(0, "Folded", { fg = p.ink_soft, bg = p.paper_dim, italic = true })
  f(0, "LineNr", { fg = p.ink_ghost })
  f(0, "CursorLineNr", { fg = p.teal, bold = true })
  f(0, "CursorLine", { bg = p.cursorline })
  f(0, "CursorColumn", { bg = p.cursorline })
  f(0, "ColorColumn", { bg = p.paper_deep })
  f(0, "Visual", { bg = p.visual })
  f(0, "VisualNOS", { bg = p.visual })
  f(0, "Search", { fg = p.ink, bg = "#F2DFA8" })
  f(0, "IncSearch", { fg = p.paper, bg = p.amber })
  f(0, "CurSearch", { fg = p.paper, bg = p.amber })
  f(0, "MatchParen", { fg = p.magenta, bold = true, underline = true })
  f(0, "Cursor", { fg = p.paper, bg = p.ink })
  f(0, "TermCursor", { fg = p.paper, bg = p.ink })
  f(0, "EndOfBuffer", { fg = p.ink_ghost })
  f(0, "NonText", { fg = p.ink_ghost })
  f(0, "Whitespace", { fg = p.ink_ghost })
  f(0, "SpecialKey", { fg = p.ink_ghost })
  f(0, "Directory", { fg = p.blue, bold = true })
  f(0, "Conceal", { fg = p.ink_mute })
  f(0, "WinSeparator", { fg = p.border, bg = p.paper })
  f(0, "VertSplit", { fg = p.border, bg = p.paper })
  f(0, "StatusLine", { fg = p.ink, bg = p.paper_dim })
  f(0, "StatusLineNC", { fg = p.ink_mute, bg = p.paper_dim })
  f(0, "TabLine", { fg = p.ink_mute, bg = p.paper_deep })
  f(0, "TabLineSel", { fg = p.teal, bg = p.paper, bold = true })
  f(0, "TabLineFill", { bg = p.paper_deep })
  f(0, "WinBar", { fg = p.ink_soft, bg = p.paper })
  f(0, "WinBarNC", { fg = p.ink_mute, bg = p.paper })
  f(0, "Pmenu", { fg = p.ink, bg = p.paper_dim })
  f(0, "PmenuSel", { fg = p.ink, bg = p.visual, bold = true })
  f(0, "PmenuSbar", { bg = p.paper_deep })
  f(0, "PmenuThumb", { bg = p.ink_mute })
  f(0, "PmenuKind", { fg = p.violet, bg = p.paper_dim })
  f(0, "PmenuExtra", { fg = p.ink_mute, bg = p.paper_dim })
  f(0, "QuickFixLine", { bg = p.blue_wash })
  f(0, "ModeMsg", { fg = p.teal, bold = true })
  f(0, "MoreMsg", { fg = p.teal })
  f(0, "Question", { fg = p.teal })
  f(0, "WarningMsg", { fg = p.yellow })
  f(0, "ErrorMsg", { fg = p.red, bold = true })
  f(0, "SpellBad", { sp = p.red, undercurl = true })
  f(0, "SpellCap", { sp = p.yellow, undercurl = true })
  f(0, "SpellLocal", { sp = p.aqua, undercurl = true })
  f(0, "SpellRare", { sp = p.violet, undercurl = true })

  -- Diff
  f(0, "DiffAdd", { fg = p.green, bg = p.green_wash })
  f(0, "DiffChange", { bg = p.blue_wash })
  f(0, "DiffDelete", { fg = p.red, bg = p.red_wash })
  f(0, "DiffText", { fg = p.ink, bg = "#C6DAF0", bold = true })
  f(0, "Added", { fg = p.green })
  f(0, "Changed", { fg = p.blue })
  f(0, "Removed", { fg = p.red })

  -- Code
  f(0, "Comment", midnight_igloo())
  f(0, "Variable", { fg = p.violet })
  f(0, "String", { fg = p.blue })
  f(0, "Character", { fg = p.aqua_alt })
  f(0, "Number", { fg = p.amber })
  f(0, "Float", { fg = p.amber })
  f(0, "Boolean", { fg = p.magenta })
  f(0, "Constant", { fg = p.jade })
  f(0, "Type", { fg = p.sienna })
  f(0, "Function", { fg = p.aqua, italic = true })
  f(0, "Keyword", { fg = p.teal, italic = true })
  f(0, "Conditional", midnight_skyrizi())
  f(0, "Repeat", { fg = p.teal, italic = true })
  f(0, "Operator", { fg = p.ink_soft })
  f(0, "PreProc", { fg = p.magenta })
  f(0, "Include", { fg = p.magenta, italic = true })
  f(0, "Exception", { fg = p.red })
  f(0, "StorageClass", { fg = p.teal, italic = true })
  f(0, "Structure", { fg = p.sienna, bold = true })
  f(0, "Typedef", { fg = p.sienna })
  f(0, "Define", { fg = p.magenta })
  f(0, "Macro", { fg = p.rose })
  f(0, "Debug", { fg = p.amber })
  f(0, "Title", { fg = p.teal, bold = true })
  f(0, "Label", { fg = p.violet })
  f(0, "SpecialChar", { fg = p.rose })
  f(0, "Delimiter", { fg = p.sand })
  f(0, "SpecialComment", { fg = p.cyan, bold = true, italic = true })
  f(0, "Tag", { fg = p.aqua })
  f(0, "Bold", { bold = true })
  f(0, "Italic", { italic = true })
  f(0, "Underlined", { fg = p.blue, underline = true })
  f(0, "Ignore", { fg = p.ink_ghost })
  f(0, "Todo", { fg = p.paper, bg = p.violet, bold = true })
  f(0, "Error", errorColor())
  f(0, "Statement", { fg = p.teal, italic = true })
  f(0, "Identifier", { fg = p.violet })
  f(0, "PreCondit", { fg = p.magenta })
  f(0, "Special", { fg = p.rose })

  -- Treesitter (modern captures; the legacy groups above are the fallback)
  f(0, "@variable", { fg = p.ink })
  f(0, "@variable.builtin", { fg = p.magenta, italic = true })
  f(0, "@variable.parameter", { fg = p.violet })
  f(0, "@variable.member", { fg = p.aqua_alt })
  f(0, "@property", { fg = p.aqua_alt })
  f(0, "@field", { fg = p.aqua_alt })
  f(0, "@constant", { fg = p.jade })
  f(0, "@constant.builtin", { fg = p.magenta })
  f(0, "@constant.macro", { fg = p.rose })
  f(0, "@module", { fg = p.sienna })
  f(0, "@namespace", { fg = p.sienna })
  f(0, "@string", { fg = p.blue })
  f(0, "@string.escape", { fg = p.rose })
  f(0, "@string.special", { fg = p.rose })
  f(0, "@string.regexp", { fg = p.jade })
  f(0, "@character", { fg = p.aqua_alt })
  f(0, "@number", { fg = p.amber })
  f(0, "@boolean", { fg = p.magenta })
  f(0, "@function", { fg = p.aqua, italic = true })
  f(0, "@function.builtin", { fg = p.aqua, bold = true })
  f(0, "@function.call", { fg = p.aqua })
  f(0, "@function.method", { fg = p.aqua, italic = true })
  f(0, "@function.method.call", { fg = p.aqua })
  f(0, "@constructor", { fg = p.sienna, bold = true })
  f(0, "@keyword", { fg = p.teal, italic = true })
  f(0, "@keyword.function", { fg = p.teal, italic = true })
  f(0, "@keyword.return", { fg = p.magenta, italic = true })
  f(0, "@keyword.operator", { fg = p.teal })
  f(0, "@keyword.import", { fg = p.magenta, italic = true })
  f(0, "@keyword.exception", { fg = p.red })
  f(0, "@keyword.conditional", { fg = p.teal, italic = true })
  f(0, "@keyword.repeat", { fg = p.teal, italic = true })
  f(0, "@type", { fg = p.sienna })
  f(0, "@type.builtin", { fg = p.sienna, italic = true })
  f(0, "@type.definition", { fg = p.sienna, bold = true })
  f(0, "@attribute", { fg = p.rose })
  f(0, "@operator", { fg = p.ink_soft })
  f(0, "@punctuation.delimiter", { fg = p.sand })
  f(0, "@punctuation.bracket", { fg = p.ink_soft })
  f(0, "@punctuation.special", { fg = p.rose })
  f(0, "@comment", { fg = p.cyan, italic = true })
  f(0, "@comment.todo", { fg = p.paper, bg = p.violet, bold = true })
  f(0, "@comment.note", { fg = p.paper, bg = p.aqua, bold = true })
  f(0, "@comment.warning", { fg = p.paper, bg = p.yellow, bold = true })
  f(0, "@comment.error", { fg = p.paper, bg = p.red, bold = true })
  f(0, "@tag", { fg = p.teal })
  f(0, "@tag.attribute", { fg = p.violet, italic = true })
  f(0, "@tag.delimiter", { fg = p.sand })
  f(0, "@markup.heading", { fg = p.teal, bold = true })
  f(0, "@markup.strong", { bold = true })
  f(0, "@markup.italic", { italic = true })
  f(0, "@markup.strikethrough", { strikethrough = true })
  f(0, "@markup.link", { fg = p.blue, underline = true })
  f(0, "@markup.link.url", { fg = p.aqua_alt, underline = true })
  f(0, "@markup.raw", { fg = p.jade, bg = p.paper_dim })
  f(0, "@markup.list", { fg = p.violet })
  f(0, "@diff.plus", { fg = p.green })
  f(0, "@diff.minus", { fg = p.red })
  f(0, "@diff.delta", { fg = p.blue })

  -- LSP semantic tokens
  f(0, "@lsp.type.class", { link = "Structure" })
  f(0, "@lsp.type.enum", { link = "Type" })
  f(0, "@lsp.type.enumMember", { link = "Constant" })
  f(0, "@lsp.type.interface", { fg = p.sienna, italic = true })
  f(0, "@lsp.type.namespace", { link = "@module" })
  f(0, "@lsp.type.parameter", { link = "@variable.parameter" })
  f(0, "@lsp.type.property", { link = "@property" })
  f(0, "@lsp.type.struct", { link = "Structure" })
  f(0, "@lsp.type.type", { link = "Type" })
  f(0, "@lsp.type.variable", { fg = p.ink })
  f(0, "@lsp.mod.readonly", { fg = p.jade })
  f(0, "@lsp.mod.deprecated", { strikethrough = true })

  -- LSP / diagnostics
  f(0, "DiagnosticHint", { fg = p.violet })
  f(0, "DiagnosticInfo", { fg = p.aqua_alt })
  f(0, "DiagnosticWarn", { fg = p.yellow })
  f(0, "DiagnosticError", { fg = p.red })
  f(0, "DiagnosticOk", { fg = p.green })
  f(0, "DiagnosticSignHint", { fg = p.violet, bg = p.paper })
  f(0, "DiagnosticSignInfo", { fg = p.aqua_alt, bg = p.paper })
  f(0, "DiagnosticSignWarn", { fg = p.yellow, bg = p.paper })
  f(0, "DiagnosticSignError", { fg = p.red, bg = p.paper })
  f(0, "DiagnosticSignOk", { fg = p.green, bg = p.paper })
  f(0, "DiagnosticFloatingHint", { fg = p.violet, bg = p.paper_dim })
  f(0, "DiagnosticFloatingInfo", { fg = p.aqua_alt, bg = p.paper_dim })
  f(0, "DiagnosticFloatingWarn", { fg = p.yellow, bg = p.paper_dim })
  f(0, "DiagnosticFloatingError", { fg = p.red, bg = p.paper_dim })
  f(0, "DiagnosticUnderlineHint", { sp = p.violet, undercurl = true })
  f(0, "DiagnosticUnderlineInfo", { sp = p.aqua_alt, undercurl = true })
  f(0, "DiagnosticUnderlineWarn", { sp = p.yellow, undercurl = true })
  f(0, "DiagnosticUnderlineError", { sp = p.red, undercurl = true })
  -- virtual text is washed, not solid: inline diagnostics must not out-shout code
  f(0, "DiagnosticVirtualTextHint", { fg = p.violet, bg = p.paper_dim, italic = true })
  f(0, "DiagnosticVirtualTextInfo", { fg = p.aqua_alt, bg = p.blue_wash, italic = true })
  f(0, "DiagnosticVirtualTextWarn", { fg = p.yellow, bg = p.yellow_wash, italic = true })
  f(0, "DiagnosticVirtualTextError", { fg = p.red, bg = p.red_wash, italic = true })
  f(0, "DiagnosticDeprecated", { sp = p.ink_mute, strikethrough = true })
  f(0, "DiagnosticUnnecessary", { fg = p.ink_mute })

  f(0, "LspReferenceRead", { bg = p.teal_wash })
  f(0, "LspReferenceText", { bg = p.paper_deep })
  f(0, "LspReferenceWrite", { bg = p.teal_wash, underline = true })
  f(0, "LspCodeLens", { fg = p.ink_mute, italic = true })
  f(0, "LspCodeLensSeparator", { fg = p.ink_ghost })
  f(0, "LspInlayHint", { fg = p.ink_mute, bg = p.paper_dim, italic = true })
  f(0, "LspSignatureActiveParameter", { fg = p.amber, bold = true })

  -- Quickscope
  f(0, "QuickScopePrimary", { fg = p.magenta, bold = true, underline = true })
  f(0, "QuickScopeSecondary", { fg = p.amber, underline = true })

  -- Telescope
  f(0, "TelescopeNormal", { fg = p.ink, bg = p.paper_dim })
  f(0, "TelescopeBorder", midnight_java())
  f(0, "TelescopeSelection", { fg = p.ink, bg = p.visual, bold = true })
  f(0, "TelescopeSelectionCaret", { fg = p.teal, bg = p.visual })
  f(0, "TelescopeMultiSelection", { fg = p.violet, bg = p.visual })
  f(0, "TelescopeMatching", { fg = p.amber, bold = true })
  f(0, "TelescopePromptNormal", { fg = p.ink, bg = p.paper_deep })
  f(0, "TelescopePromptBorder", { fg = p.paper_deep, bg = p.paper_deep })
  f(0, "TelescopePromptTitle", { fg = p.paper, bg = p.teal, bold = true })
  f(0, "TelescopePromptPrefix", { fg = p.teal, bg = p.paper_deep })
  f(0, "TelescopePromptCounter", { fg = p.ink_mute, bg = p.paper_deep })
  f(0, "TelescopeResultsTitle", { fg = p.paper_dim, bg = p.paper_dim })
  f(0, "TelescopeResultsBorder", { fg = p.paper_dim, bg = p.paper_dim })
  f(0, "TelescopePreviewTitle", { fg = p.paper, bg = p.violet, bold = true })
  f(0, "TelescopePreviewBorder", { fg = p.paper_dim, bg = p.paper_dim })
  f(0, "TelescopePreviewNormal", { bg = p.paper_dim })
  f(0, "TelescopePreviewHyphen", { fg = p.sand })

  -- NvimTree
  f(0, "NvimTreeNormal", { fg = p.ink, bg = p.paper_dim })
  f(0, "NvimTreeNormalNC", { fg = p.ink, bg = p.paper_dim })
  f(0, "NvimTreeWinSeparator", { fg = p.border, bg = p.paper_dim })
  f(0, "NvimTreeVertSplit", { fg = p.border, bg = p.paper_dim })
  f(0, "NvimTreeEndOfBuffer", { fg = p.paper_dim, bg = p.paper_dim })
  f(0, "NvimTreeCursorLine", { bg = p.visual })
  f(0, "NvimTreeFolderIcon", { fg = p.teal })
  f(0, "NvimTreeFolderName", { fg = p.blue })
  f(0, "NvimTreeOpenedFolderName", { fg = p.blue, bold = true })
  f(0, "NvimTreeEmptyFolderName", { fg = p.ink_mute, italic = true })
  f(0, "NvimTreeRootFolder", { fg = p.violet, bold = true })
  f(0, "NvimTreeIndentMarker", { fg = p.ink_ghost })
  f(0, "NvimTreeSymlink", { fg = p.aqua_alt, italic = true })
  f(0, "NvimTreeExecFile", { fg = p.green, bold = true })
  f(0, "NvimTreeImageFile", { fg = p.violet })
  f(0, "NvimTreeSpecialFile", { fg = p.amber, underline = true })
  f(0, "NvimTreeGitIgnored", { fg = p.ink_ghost, italic = true })
  f(0, "NvimTreeGitStaged", { fg = p.green })
  f(0, "NvimTreeGitNew", { fg = p.green })
  f(0, "NvimTreeGitRenamed", { fg = p.violet })
  f(0, "NvimTreeGitDeleted", { fg = p.red })
  f(0, "NvimTreeGitMerge", { fg = p.amber })
  f(0, "NvimTreeGitDirty", { fg = p.yellow })
  f(0, "NvimTreeLspDiagnosticsError", { fg = p.red })
  f(0, "NvimTreeLspDiagnosticsWarning", { fg = p.yellow })
  f(0, "NvimTreeLspDiagnosticsInformation", { fg = p.aqua_alt })
  f(0, "NvimTreeLspDiagnosticsInfo", { fg = p.aqua_alt })
  f(0, "NvimTreeLspDiagnosticsHint", { fg = p.violet })

  -- Oil
  f(0, "OilDir", { fg = p.blue, bold = true })
  f(0, "OilDirIcon", { fg = p.teal })
  f(0, "OilLink", { fg = p.aqua_alt, italic = true })
  f(0, "OilFile", { fg = p.ink })

  -- Gitsigns
  f(0, "GitSignsAdd", { fg = p.green, bg = p.paper })
  f(0, "GitSignsChange", { fg = p.blue, bg = p.paper })
  f(0, "GitSignsDelete", { fg = p.red, bg = p.paper })
  f(0, "GitSignsCurrentLineBlame", { fg = p.ink_ghost, italic = true })

  -- Completion (blink / cmp)
  f(0, "BlinkCmpMenu", { link = "Pmenu" })
  f(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
  f(0, "BlinkCmpMenuSelection", { link = "PmenuSel" })
  f(0, "BlinkCmpLabelMatch", { fg = p.amber, bold = true })
  f(0, "BlinkCmpKind", { fg = p.violet })
  f(0, "BlinkCmpDoc", { link = "NormalFloat" })
  f(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
  f(0, "CmpItemAbbrMatch", { fg = p.amber, bold = true })
  f(0, "CmpItemAbbrMatchFuzzy", { fg = p.amber })
  f(0, "CmpItemAbbrDeprecated", { fg = p.ink_mute, strikethrough = true })
  f(0, "CmpItemKind", { fg = p.violet })
  f(0, "CmpItemMenu", { fg = p.ink_mute, italic = true })

  -- which-key / notify / indent guides
  f(0, "WhichKey", { fg = p.teal })
  f(0, "WhichKeyGroup", { fg = p.violet })
  f(0, "WhichKeyDesc", { fg = p.ink })
  f(0, "WhichKeySeparator", { fg = p.ink_ghost })
  f(0, "WhichKeyFloat", { bg = p.paper_dim })
  f(0, "NotifyERRORBorder", { fg = p.red })
  f(0, "NotifyWARNBorder", { fg = p.yellow })
  f(0, "NotifyINFOBorder", { fg = p.aqua_alt })
  f(0, "NotifyDEBUGBorder", { fg = p.ink_mute })
  f(0, "NotifyTRACEBorder", { fg = p.violet })
  f(0, "IblIndent", { fg = p.ink_ghost })
  f(0, "IblScope", { fg = p.teal })

  -- Terminal (:terminal and anything reading g:terminal_color_*)
  vim.g.terminal_color_0 = p.ink
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.violet
  vim.g.terminal_color_6 = p.teal
  vim.g.terminal_color_7 = p.ink_soft
  vim.g.terminal_color_8 = p.ink_mute
  vim.g.terminal_color_9 = p.rose
  vim.g.terminal_color_10 = p.jade
  vim.g.terminal_color_11 = p.amber
  vim.g.terminal_color_12 = p.aqua
  vim.g.terminal_color_13 = p.magenta
  vim.g.terminal_color_14 = p.aqua_alt
  vim.g.terminal_color_15 = p.ink_ghost
end

local MODULE = "colors.homegrown.themes.midnight-coder.midnight-coder-light"

-- Live-reload: on save, bust the require cache for this theme (and its
-- palette) so edits are picked up, then re-apply the highlights.
local function live_reload()
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("MidnightCoderLightReload", { clear = true }),
    pattern = "*/themes/midnight-coder/midnight-coder-light.lua",
    callback = function()
      package.loaded[MODULE] = nil
      package.loaded["colors.homegrown.palette"] = nil
      local ok, fresh = pcall(require, MODULE)
      if not ok then
        vim.notify("midnight-coder-light reload failed: " .. fresh, vim.log.levels.ERROR)
        return
      end
      fresh.setup()
      vim.cmd("redraw!")
    end,
  })
end

theme.palette = p

function theme.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.background = "light"
  vim.o.termguicolors = true
  vim.g.colors_name = "midnight-coder-light"
  theme.set_highlights()
  live_reload()
end

return theme
