local config = {
  cmd = {vim.fn.expand("~/.local/share/nvim/mason/bin/")},
  rootDir = vim.fs.dirname(vim.fs.find({".gradlew", ".git", "mvnw" }, {upward = true})[1]),
}

require("jdtls").start_or_attach(config)
