-- floating-notes.lua: A floating window note-taking plugin with file annotations
-- Save this file in your Neovim config directory (typically ~/.config/nvim/lua/)
-- Then load it with: require('floating-notes')

local M = {}

-- State to track the floating notes buffer/window
local buf = -1
local win = -1
local visible = false
local notes_file = vim.fn.stdpath("data") .. "/scratch_notes.md"

-- Track the last used filename for memoization
local last_filename = nil

-- Language comment styles
local comment_styles = {
	-- Single line comment styles
	lua = "--",
	py = "#",
	python = "#",
	rb = "#",
	ruby = "#",
	pl = "#",
	perl = "#",
	sh = "#",
	bash = "#",
	zsh = "#",
	js = "//",
	ts = "//",
	jsx = "//",
	tsx = "//",
	javascript = "//",
	typescript = "//",
	java = "//",
	c = "//",
	h = "//",
	cpp = "//",
	hpp = "//",
	cs = "//",
	php = "//",
	rs = "//",
	rust = "//",
	swift = "//",
	go = "//",

	-- Languages with special comment styles
	html = "<!-- TODO: %s -->",
	xml = "<!-- TODO: %s -->",
	css = "/* TODO: %s */",
	scss = "/* TODO: %s */",
	ml = "(* TODO: %s *)",
	ocaml = "(* TODO: %s *)",
	hs = "-- TODO: %s",
	haskell = "-- TODO: %s",

	-- Default fallback
	default = "/* TODO: %s */",
}

-- Create or open the floating notes window
local function open_floating_notes()
	-- Window dimensions
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create or reuse buffer
	if not vim.api.nvim_buf_is_valid(buf) then
		buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
		vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

		-- Load notes from file if it exists
		if vim.fn.filereadable(notes_file) == 1 then
			local content = vim.fn.readfile(notes_file)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
		else
			-- Default content
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
				"# Quick Notes",
				"",
				"- Use this space for quick notes",
				"- Use @filename.ext to reference files",
				"- Use @filename.ext -> { Note } to add TODOs",
				"- Press <leader>nf to quickly add a file reference",
				"- Press <leader>nt to add a timestamped note",
				"",
				"## TODOs",
				"",
			})
		end

		-- Auto-save on changes
		vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			buffer = buf,
			callback = function()
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				vim.fn.writefile(lines, notes_file)
			end,
		})

		-- Set up highlighting for file references
		vim.api.nvim_buf_call(buf, function()
			vim.cmd([[
                highlight default link NotesFileRef Underlined
                highlight default link NotesAnnotation Special
            ]])
			vim.fn.matchadd("NotesFileRef", "@[%w_%.%-]+%.[%w_]+")
			vim.fn.matchadd("NotesAnnotation", "@[%w_%.%-]+%.[%w_]+%s*%->%s*{.*}")
		end)

		-- Add Enter key handler for file references
		vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
			callback = function()
				local line_nr = vim.api.nvim_win_get_cursor(0)[1]
				local line = vim.api.nvim_buf_get_lines(buf, line_nr - 1, line_nr, false)[1]

				-- Handle @filename.ext -> { note }
				for filename, note in line:gmatch("@([%w_%.%-]+%.[%w_]+)%s*%->%s*{%s*(.-)%s*}") do
					add_todo_to_file(filename, note)
					return
				end

				-- Handle simple @filename.ext
				for filename in line:gmatch("@([%w_%.%-]+%.[%w_]+)") do
					jump_to_file(filename)
					return
				end
			end,
			noremap = true,
			silent = true,
		})
	end

	-- Create window
	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = " Notes ",
		title_pos = "center",
	})

	-- Set window options
	vim.api.nvim_win_set_option(win, "wrap", true)
	vim.api.nvim_win_set_option(win, "number", true)
	vim.api.nvim_win_set_option(win, "cursorline", true)

	visible = true
	return buf, win
end

-- Jump to a file
local function jump_to_file(filename)
	-- Look for the file in the current directory
	local cwd = vim.fn.getcwd()
	local file_path

	-- Check if file exists in current directory
	if vim.fn.filereadable(cwd .. "/" .. filename) == 1 then
		file_path = cwd .. "/" .. filename
	else
		-- Use find to locate the file
		local cmd = string.format("find %s -type f -name '%s' | head -n 1", cwd, filename)
		file_path = vim.fn.system(cmd):gsub("%s+$", "")

		if file_path == "" then
			vim.notify("File not found: " .. filename, vim.log.levels.WARN)
			return
		end
	end

	-- Open the file
	vim.cmd("edit " .. vim.fn.fnameescape(file_path))
	vim.notify("Opened: " .. file_path, vim.log.levels.INFO)
end

-- Add TODO comment to file
local function add_todo_to_file(filename, note)
	-- Find the file
	local cwd = vim.fn.getcwd()
	local file_path

	if vim.fn.filereadable(cwd .. "/" .. filename) == 1 then
		file_path = cwd .. "/" .. filename
	else
		local cmd = string.format("find %s -type f -name '%s' | head -n 1", cwd, filename)
		file_path = vim.fn.system(cmd):gsub("%s+$", "")

		if file_path == "" then
			vim.notify("File not found: " .. filename, vim.log.levels.WARN)
			return
		end
	end

	-- Get file extension
	local ext = filename:match("%.([^%.]+)$") or "default"
	local comment_style = comment_styles[ext] or comment_styles["default"]

	-- Format the TODO comment
	local todo_comment
	if comment_style:find("%%s") then
		todo_comment = string.format(comment_style, note)
	else
		todo_comment = comment_style .. " TODO: " .. note
	end

	-- Read file, add comment, write back
	local lines = vim.fn.readfile(file_path)
	table.insert(lines, 1, todo_comment)
	vim.fn.writefile(lines, file_path)

	vim.notify("Added TODO to " .. filename, vim.log.levels.INFO)

	-- Open the file
	jump_to_file(filename)
end

-- Toggle notes window
function M.toggle_notes()
	if not vim.api.nvim_win_is_valid(win) or not visible then
		open_floating_notes()
	else
		vim.api.nvim_win_hide(win)
		visible = false
	end
end

-- Move notes window right
function M.move_right()
	if not vim.api.nvim_win_is_valid(win) then
		vim.notify("Notes window not open", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_win_set_config(win, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.3),
		height = vim.o.lines - 4,
		col = vim.o.columns - math.floor(vim.o.columns * 0.3),
		row = 2,
	})
end

-- Move notes window center
function M.move_center()
	if not vim.api.nvim_win_is_valid(win) then
		vim.notify("Notes window not open", vim.log.levels.WARN)
		return
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	vim.api.nvim_win_set_config(win, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
	})
end

-- Move notes window left
function M.move_left()
	if not vim.api.nvim_win_is_valid(win) then
		vim.notify("Notes window not open", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_win_set_config(win, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.3),
		height = vim.o.lines - 4,
		col = 0,
		row = 2,
	})
end

-- Add a timestamped note
function M.add_timestamped_note()
	if not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("Notes buffer not valid", vim.log.levels.ERROR)
		return
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local timestamp = os.date("%Y-%m-%d %H:%M")
	local line = "- [" .. timestamp .. "] "

	vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { line })
	vim.api.nvim_win_set_cursor(0, { row, #line })

	if vim.api.nvim_get_current_buf() == buf then
		vim.cmd("startinsert!")
	end
end

-- Function to show the filename input prompt
local function show_filename_prompt(current_win)
	-- Create a small buffer for the prompt
	local prompt_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(prompt_buf, "bufhidden", "wipe")

	-- Set prompt buffer's initial content
	vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, { "Enter filename: " })

	-- Calculate dimensions for the prompt window
	local width = 40
	local height = 1
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor(vim.o.lines / 2 - height)

	-- Create the prompt window
	local prompt_win = vim.api.nvim_open_win(prompt_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = " Add File Reference ",
		title_pos = "center",
	})

	-- Set window options
	vim.api.nvim_win_set_option(prompt_win, "wrap", false)

	-- Position cursor after the prompt text
	vim.api.nvim_win_set_cursor(prompt_win, { 1, 16 })

	-- Enter insert mode
	vim.cmd("startinsert!")

	-- Set up autocmd for when Enter is pressed
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = prompt_buf,
		once = true,
		callback = function()
			-- Get the entered filename
			local prompt_text = vim.api.nvim_buf_get_lines(prompt_buf, 0, -1, false)[1]
			local filename = prompt_text:match("Enter filename: (.+)")

			-- Close the prompt window
			vim.api.nvim_win_close(prompt_win, true)

			-- Return to the notes window
			vim.api.nvim_set_current_win(current_win)

			-- If a filename was entered, add it to the notes
			if filename and filename ~= "" then
				-- Remember this filename for next time
				last_filename = filename

				-- Get cursor position in notes buffer
				local cursor = vim.api.nvim_win_get_cursor(current_win)
				local row = cursor[1]

				-- Create annotation text with the filename
				local annotation_text = "@" .. filename .. " -> { }"

				-- Insert the annotation at cursor position
				vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { annotation_text })

				-- Move cursor to inside the braces
				vim.api.nvim_win_set_cursor(current_win, { row, #annotation_text - 1 })

				-- Enter insert mode
				vim.cmd("startinsert")
			end
		end,
	})

	-- Add key mappings for the prompt buffer
	vim.api.nvim_buf_set_keymap(prompt_buf, "i", "<CR>", "<Esc>", {
		noremap = true,
		silent = true,
	})

	vim.api.nvim_buf_set_keymap(prompt_buf, "i", "<Esc>", "", {
		noremap = true,
		silent = true,
		callback = function()
			vim.api.nvim_win_close(prompt_win, true)
			vim.api.nvim_set_current_win(current_win)
		end,
	})
end

-- Function to add a file reference via a floating prompt with memoization
function M.add_file_reference()
	-- Ensure the notes buffer exists
	if not vim.api.nvim_buf_is_valid(buf) then
		vim.notify("Notes buffer not valid", vim.log.levels.ERROR)
		return
	end

	-- Ensure the notes window is visible
	if not vim.api.nvim_win_is_valid(win) or not visible then
		M.toggle_notes()
	end

	-- Store the current window to return to it later
	local current_win = vim.api.nvim_get_current_win()

	-- If we have a previously used filename, ask if user wants to reuse it
	if last_filename then
		-- Create a buffer for the confirmation prompt
		local confirm_buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_option(confirm_buf, "bufhidden", "wipe")

		-- Set prompt text
		local prompt_text = "Reuse '" .. last_filename .. "'? (y/n): "
		vim.api.nvim_buf_set_lines(confirm_buf, 0, -1, false, { prompt_text })

		-- Calculate dimensions for the prompt window
		local width = #prompt_text + 5
		local height = 1
		local col = math.floor((vim.o.columns - width) / 2)
		local row = math.floor(vim.o.lines / 2 - height)

		-- Create the confirmation window
		local confirm_win = vim.api.nvim_open_win(confirm_buf, true, {
			relative = "editor",
			width = width,
			height = height,
			col = col,
			row = row,
			style = "minimal",
			border = "rounded",
			title = " Reuse Previous ",
			title_pos = "center",
		})

		-- Set window options
		vim.api.nvim_win_set_option(confirm_win, "wrap", false)

		-- Position cursor at the end of the prompt
		vim.api.nvim_win_set_cursor(confirm_win, { 1, #prompt_text })

		-- Enter insert mode
		vim.cmd("startinsert!")

		-- Handle 'y' or 'n' keypress
		vim.api.nvim_buf_set_keymap(confirm_buf, "i", "y", "", {
			noremap = true,
			silent = true,
			callback = function()
				-- Close the confirmation window
				vim.api.nvim_win_close(confirm_win, true)

				-- Return to the notes window
				vim.api.nvim_set_current_win(current_win)

				-- Insert the annotation with the last filename
				local cursor = vim.api.nvim_win_get_cursor(current_win)
				local row = cursor[1]
				local annotation_text = "@" .. last_filename .. " -> { }"

				vim.api.nvim_buf_set_lines(buf, row - 1, row - 1, false, { annotation_text })

				-- Move cursor to inside the braces
				vim.api.nvim_win_set_cursor(current_win, { row, #annotation_text - 1 })

				-- Enter insert mode
				vim.cmd("startinsert")
			end,
		})

		vim.api.nvim_buf_set_keymap(confirm_buf, "i", "n", "", {
			noremap = true,
			silent = true,
			callback = function()
				-- Close the confirmation window
				vim.api.nvim_win_close(confirm_win, true)

				-- Return to the notes window
				vim.api.nvim_set_current_win(current_win)

				-- Continue with the new filename prompt
				show_filename_prompt(current_win)
			end,
		})

		-- Allow Escape to cancel
		vim.api.nvim_buf_set_keymap(confirm_buf, "i", "<Esc>", "", {
			noremap = true,
			silent = true,
			callback = function()
				vim.api.nvim_win_close(confirm_win, true)
				vim.api.nvim_set_current_win(current_win)
			end,
		})
	else
		-- No previous filename, go straight to the filename prompt
		show_filename_prompt(current_win)
	end
end

-- Setup function
function M.setup(opts)
	-- Process options
	opts = opts or {}

	-- Set notes file location
	if opts.notes_file then
		notes_file = opts.notes_file
	end

	-- Update comment styles with custom ones
	if opts.comment_styles then
		for ext, style in pairs(opts.comment_styles) do
			comment_styles[ext] = style
		end
	end

	-- Create keybindings (unless disabled)
	if opts.create_keymaps ~= false then
		vim.keymap.set("n", "<leader>nn", M.toggle_notes, { desc = "Toggle Notes Window" })
		vim.keymap.set("n", "<leader>nf", M.add_file_reference, { desc = "Add File Reference" })
		vim.keymap.set("n", "<leader>nr", M.move_right, { desc = "Move Notes Right" })
		vim.keymap.set("n", "<leader>nc", M.move_center, { desc = "Center Notes" })
		vim.keymap.set("n", "<leader>nl", M.move_left, { desc = "Move Notes Left" })
		vim.keymap.set("n", "<leader>nt", M.add_timestamped_note, { desc = "Add Timestamped Note" })
	end

	-- Create commands
	vim.api.nvim_create_user_command("NotesToggle", M.toggle_notes, {})
	vim.api.nvim_create_user_command("NotesAddFile", M.add_file_reference, {})
	vim.api.nvim_create_user_command("NotesRight", M.move_right, {})
	vim.api.nvim_create_user_command("NotesCenter", M.move_center, {})
	vim.api.nvim_create_user_command("NotesLeft", M.move_left, {})
	vim.api.nvim_create_user_command("NotesTimestamp", M.add_timestamped_note, {})
end

-- Initialize with default options
M.setup()

return M
