return {
  "TuringProblem/craftos-pc.nvim",
  config = function()
    require("craftos-pc").setup({
      keymaps = {
        run = "<leader>cr",
        shell = "<leader>co",
      },
      ft_scope = true,
    })
  end,
}
