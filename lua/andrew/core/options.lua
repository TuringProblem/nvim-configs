vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

<<<<<<< HEAD
opt.relativenumber = true 
opt.number = true 
=======
opt.relativenumber = false
opt.number = false
>>>>>>> 8f4c66f51f065f9e0ef399cd883bcea33fd26b1c

-- tabs & indentations
opt.tabstop = 2 -- 2 space for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in search, assumes you want case-sensitmart/ve

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
--opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line, or mode start of position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows

opt.splitright = true -- split veritcal window to the right
opt.splitbelow = true -- split horizontal window to the bottom

<<<<<<< HEAD
=======
vim.cmd("hi clear")
>>>>>>> 8f4c66f51f065f9e0ef399cd883bcea33fd26b1c
vim.cmd("syntax off")

vim.cmd("filetype off")
