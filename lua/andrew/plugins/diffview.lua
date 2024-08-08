return {
	"sindrets/diffview.nvim",
	hooks = {
		diff_buf_win_enter = function(bufnr, winid, ctx)
			if ctx.layout_name:match("^diff2") then
				if ctx.symbol == "a" then
					vim.opt_local.winhl = table.concat({
						"DiffAdd:DiffviewDiffAddAsDelete",
						"DiffDelete:DiffviewDiffDelete",
					}, ",")
				elseif ctx.symbol == "b" then
					vim.opt_local.winhl = table.concat({
						"DiffDelete:DiffviewDiffDelete",
					}, ",")
				end
			end
		end,
		diff_buf_read = function(bufnr)
			-- Change local options in diff buffers
			vim.opt_local.wrap = false
			vim.opt_local.list = false
			vim.opt_local.colorcolumn = { 80 }
		end,
		view_opened = function(view)
			print(("A new %s was opened on tab page %d!"):format(view.class:name(), view.tabpage))
		end,
	},
}
