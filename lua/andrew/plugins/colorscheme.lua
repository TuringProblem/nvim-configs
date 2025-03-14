return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000,
	config = function()
		require("rose-pine").setup({
			dark_variant = "main", -- Options: 'main' (default), 'moon', 'dawn'
			disable_background = false, -- Set to true to disable the background
			disable_float_background = false,
			disable_italics = true, -- Disable italics if needed
			highlight_groups = { -- Custom highlight groups if needed
				CursorLine = { bg = "#2a2a37" },
				ColorColumn = { bg = "#3b3052" },
			},
		})
		vim.cmd("colorscheme rose-pine-main")
	end,
}

--[[
return {

	{
		dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
		name = "og",
		config = function()
			require("colors.og").setup()
			vim.cmd("colorscheme mytheme")
		end,
	},
}
]]
