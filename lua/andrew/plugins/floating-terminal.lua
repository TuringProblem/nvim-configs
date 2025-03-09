vim.o.hidden = true
vim.keymap.set("t", "<esc>", [[<c-\><c-n>]])

local state = {
	floating = {
		buf = -1,
		win = -1,
		last_win = -1, -- Store the last active window before switching to terminal
		visible = false, -- Whether the floating terminal is currently visible
		term_job = nil, -- Store the terminal job id
	},
}

local function open_floating_terminal(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2 - 1)

	local buf
	if vim.api.nvim_buf_is_valid(state.floating.buf) then
		buf = state.floating.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
	end

	local win_configs = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}
	local win = vim.api.nvim_open_win(buf, true, win_configs)
	return buf, win
end

local function toggle_terminal()
	if not vim.api.nvim_win_is_valid(state.floating.win) or not state.floating.visible then
		-- Terminal is either not open or hidden—open (or reopen) it.
		local buf, win = open_floating_terminal()
		state.floating.buf = buf
		state.floating.win = win
		state.floating.visible = true
		-- Check if terminal is active: if not, open it.
		if
			vim.bo[buf].buftype ~= "terminal"
			or (state.floating.term_job and vim.fn.jobwait({ state.floating.term_job }, 0)[1] ~= -1)
		then
			state.floating.term_job = vim.fn.termopen(vim.o.shell)
		end
		vim.cmd.startinsert()
	else
		-- Terminal is visible—hide it.
		vim.api.nvim_win_hide(state.floating.win)
		state.floating.visible = false
	end
end

local function toggle_terminal_focus()
	if not vim.api.nvim_win_is_valid(state.floating.win) or not state.floating.visible then
		toggle_terminal()
		return
	end

	local current_win = vim.api.nvim_get_current_win()
	if current_win == state.floating.win then
		if state.floating.last_win and vim.api.nvim_win_is_valid(state.floating.last_win) then
			vim.api.nvim_set_current_win(state.floating.last_win)
		else
			vim.cmd("wincmd p")
		end
	else
		state.floating.last_win = current_win
		vim.api.nvim_set_current_win(state.floating.win)
		vim.cmd("startinsert")
	end
end

local function move_right()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		vim.notify("Floating terminal is not open", vim.log.levels.WARN)
		return
	end
	local new_width = math.floor(vim.o.columns * 0.3)
	local new_height = vim.o.lines - 2
	local new_col = vim.o.columns - new_width
	local new_row = 0

	local cfg = vim.api.nvim_win_get_config(state.floating.win)
	cfg.width = new_width
	cfg.height = new_height
	cfg.col = new_col
	cfg.row = new_row
	vim.api.nvim_win_set_config(state.floating.win, cfg)
end

local function move_bottom()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		vim.notify("Floating terminal is not open", vim.log.levels.WARN)
		return
	end
	local new_width = math.floor(vim.o.columns)
	local new_height = math.floor(vim.o.lines * 0.3)
	local new_col = 0
	local new_row = vim.o.lines - new_height

	local cfg = vim.api.nvim_win_get_config(state.floating.win)
	cfg.width = new_width
	cfg.height = new_height
	cfg.col = new_col
	cfg.row = new_row
	vim.api.nvim_win_set_config(state.floating.win, cfg)
end

local function move_center()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		vim.notify("Floating terminal is not open", vim.log.levels.WARN)
		return
	end
	local new_width = math.floor(vim.o.columns)
	local new_height = vim.o.lines - 2
	local new_col = math.floor((vim.o.columns - new_width) / 2)
	local new_row = 0

	local cfg = vim.api.nvim_win_get_config(state.floating.win)
	cfg.width = new_width
	cfg.height = new_height
	cfg.col = new_col
	cfg.row = new_row
	vim.api.nvim_win_set_config(state.floating.win, cfg)
end
local function move_left()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		vim.notify("Floating terminal is not open", vim.log.levels.WARN)
		return
	end
	local new_width = math.floor(vim.o.columns * 0.3)
	local new_height = vim.o.lines - 2
	local new_col = 0
	local new_row = 0

	local cfg = vim.api.nvim_win_get_config(state.floating.win)
	cfg.width = new_width
	cfg.height = new_height
	cfg.col = new_col
	cfg.row = new_row
	vim.api.nvim_win_set_config(state.floating.win, cfg)
end

vim.keymap.set({ "n", "t" }, "<leader>tb", move_bottom, { silent = true, desc = "Move floating terminal bottom" })
vim.keymap.set({ "n", "t" }, "<leader>tl", move_left, { silent = true, desc = "Move floating terminal left" })

vim.keymap.set({ "n", "t" }, "<leader>tr", move_right, { desc = "Move floating terminal right" })

vim.keymap.set({ "n", "t" }, "<leader>mc", move_center, { silent = true, desc = "Center floating terminal" })

vim.api.nvim_create_user_command("Floterminal", toggle_terminal, {})
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "[T]oggle [T]erminal" })
vim.keymap.set({ "n", "t" }, "<leader>tf", toggle_terminal_focus, { desc = "Toggle focus between terminal and editor" })

-- something
