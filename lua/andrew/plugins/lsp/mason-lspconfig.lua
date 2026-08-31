return {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason-lspconfig").setup({
      -- servers are enabled explicitly in lspconfig.lua; mason only installs
      automatic_enable = false,
      ensure_installed = {
        "clangd",
        "ts_ls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "jdtls",
        "zls",
      },
    })
  end,
}
