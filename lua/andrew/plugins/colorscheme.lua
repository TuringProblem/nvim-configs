
return { "rose-pine/neovim",
  name = "rose-pine",
priority = 1000,
config = function()
    require('rose-pine').setup({
      dark_variant = 'main',  -- Options: 'main' (default), 'moon', 'dawn'
      disable_background = false,  -- Set to true to disable the background
      disable_float_background = false,
      disable_italics = true,  -- Disable italics if needed
      highlight_groups = {    -- Custom highlight groups if needed
        CursorLine = { bg = '#2a2a37' },
        ColorColumn = { bg = '#3b3052' },
      }
    })  vim.cmd("colorscheme rose-pine-main")
  end

return {

  {
    dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
    name = "og",
    config = function()
      require("colors.og").setup()
      vim.cmd("colorscheme mytheme")
    end,
  },

	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		local bg = "#000000"
		local bg_dark = "#000000"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"

		require("tokyonight").setup({
			style = "night",
			on_colors = function(colors)
				colors.bg = transparent
				colors.bg_dark = transparent
				colors.bg_float = transparent and colors.none or bg_dark
				colors.bg_highlight = transparent 
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = transparent 
				colors.bg_statusline = transparent and colors.none or bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,
		})
		vim.cmd("colorscheme tokyonight")
	end,

}

