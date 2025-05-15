return {
	{
		dir = "~/.config/nvim/lua/colors", -- Correct path to your custom theme directory
		name = "testColor",
		config = function()
			require("colors.testColor").setup()
			vim.cmd("colorscheme testColor")
		end,
	},
}
