vim.cmd("let g:netrw_liststyle = 3")

-- disable unused remote-plugin providers (silences checkhealth warnings)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.swapfile = false


-- tabs & indentations
opt.tabstop = 2    -- 2 space for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.softtabstop = 2

opt.expandtab = true  -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one
opt.scrolloff = 20    -- Centers the text when you  type outside of the vertical bounds
opt.sidescrolloff = 8 -- Centers the text when you type outside of the horizontal bounds

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in search, assumes you want case-sensitmart/ve
opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
--opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"              -- show sign column so that text doesn't shift

opt.backspace = "indent,eol,start"  -- allow backspace on indent, end of line, or mode start of position
opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.splitright = true               -- split veritcal window to the right
opt.splitbelow = true               -- split horizontal window to the bottom

vim.cmd("hi clear")

vim.cmd("syntax off")

vim.cmd("filetype off")
