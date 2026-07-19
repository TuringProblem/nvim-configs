return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_to_qflist,          -- send to quickfix list
          },
        },
      },
      pickers = {
        lsp_definitions = {
          theme = "dropdown",
          reuse_win = true,
          show_line = false,
        },
        lsp_references = {
          theme = "ivy",
          reuse_win = true,
          show_line = false,
        },
        lsp_implementations = {
          reuse_win = true,
          show_line = false,
        },
        lsp_type_definitions = {
          reuse_win = true,
          show_line = false,
        },
      },
    })

    -- Load extensions
    telescope.load_extension("fzf")

    -- LSP nav keymaps live in lsp/lspconfig.lua (buffer-local, on LspAttach)
    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fz", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  end,
}
