return {
	"rose-pine/nvim",
	name = "rose-pine",
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
		require("rose-pine").setup({
			dark_varient = "main", --'main' -> default 'moon', 'dawn'
			disable_background = true,
			disable_float_background = true,
			highlight_groups = {
				CursorLine = { bg = "#2a2a37" },
				ColorColumn = { bg = "#3b3052" },
			},
		})
		vim.cmd("colorscheme rose-pine-main")
	end,
}
