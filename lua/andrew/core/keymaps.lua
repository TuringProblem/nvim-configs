vim.g.mapleader = " "
vim.opt.guicursor = "n-v-c-i:block"

local keymap = vim.keymap -- for conciseness
--local state = vim.api.nvim_get_current_tabpage()
--local conf = vim.api.nvim_win_get_config(state)

--keymap.set("i", "<leader>o", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })                 -- Increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })                 -- Decrement

keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertically" })    -- show window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontally" })  -- show window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "[S]plits size [E]qually" })        -- makes split windows equal width
keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "[S]plit window [C]lose" }) -- closes the current split window
--[[
keymap.set("n", "<leader>sm", function()
	conf.width = math.floor(vim.o.columns * 0.3)
	conf.height = math.floor(vim.o.lines * 0.8)
end, { desc = "[S]creen [M]aximize" })
]]

keymap.set("n", "<leader>vn", "<cmd>windo wincmd k<CR>", { desc = " [V]iew [N]ext" })
keymap.set("n", "<leader>vb", "<cmd>windo wincmd h<CR>", { desc = " [V]iew [B]ack" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[T]ab [O]pen (new)" })               -- opens a new tab
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[T]ab [C]lose" })                  -- closes current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "[T]ab [N]ext -> (right)" })            -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "[T]left ab [P]revious <- (left)" })    -- go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --

keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode." })
keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode." })

keymap.set("n", "<leader>ip", "<cmd>ImagePreview<CR>", { desc = "[I]mage [P]review" })
keymap.set("n", "<leader>iw", "<cmd>ImagePreviewWeb<CR>", { desc = "[I]mage preview [W]eb" })
keymap.set("n", "<leader>it", "<cmd>ImagePreviewTerminal<CR>", { desc = "[I]mage preview [T]erminal" })

-- Quickfix/loclist: <CR> or double-click jumps to entry AND closes the list window
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("QuickfixAutoClose", { clear = true }),
	pattern = "qf",
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		-- Loclist windows have wintype "loclist"; plain quickfix has "quickfix".
		local close_cmd = vim.fn.win_gettype() == "loclist" and ":lclose<CR>" or ":cclose<CR>"
		keymap.set("n", "<CR>", "<CR>" .. close_cmd, opts)
		keymap.set("n", "<2-LeftMouse>", "<2-LeftMouse>" .. close_cmd, opts)
	end,
})
