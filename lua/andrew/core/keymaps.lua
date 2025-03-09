vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness


--keymap.set("i", "<leader>o", "<ESC>", { desc = "Exit insert mode with jk" })



keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- Increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- Decrement

-- looking up keymappings real quick so this just gonna be boring for you rn.. :/ one sec
-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [V]ertically" }) -- show window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [H]orizontally" }) -- show window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "[S]plits size [E]qually" }) -- makes split windows equal width
keymap.set("n", "<leader>sc", "<cmd>close<CR>", { desc = "[S]plit window [C]lose" }) -- closes the current split window

-- Switch between windows
keymap.set("n", "<leader>vn", "<cmd>windo wincmd k<CR>", { desc = " [V]iew [N]ext" })
keymap.set("n", "<leader>vb", "<cmd>windo wincmd h<CR>", { desc = " [V]iew [B]ack" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "[T]ab [O]pen (new)" }) -- opens a new tab
keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[T]ab [C]lose" }) -- closes current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "[T]ab [N]ext -> (right)" }) -- go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "[T]left ab [P]revious <- (left)" }) -- go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --

-- Indentation
keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode." })
keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode." })
