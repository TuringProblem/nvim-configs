return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = false,
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
  vim.keymap.set("n", "<space>-", "<CMD>Oil<CR>", { desc = "Runs the parent directory" }),
}
