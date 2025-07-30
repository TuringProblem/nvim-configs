return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"christoomey/vim-tmux-navigator", --tmux & split window navigation
	
	-- Custom Shifty plugin
	{
		dir = vim.fn.stdpath("config") .. "/lua/andrew/plugins/custom/shifty",
		name = "shifty",
		config = function()
			require("andrew.plugins.custom.shifty").setup({
				-- You can customize these settings
				keymaps = {
					toggle = "<leader>st",
					run = "<leader>sr", 
					clear = "<leader>sc",
					close = "<Esc>"
				},
				window = {
					width = 80,
					height = 20,
					border = "rounded"
				}
			})
		end,
		event = "VeryLazy"
	}
}
