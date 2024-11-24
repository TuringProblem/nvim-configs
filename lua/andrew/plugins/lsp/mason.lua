return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
        "ast_grep",
        "basedpyright",
        "harper_ls",
        "jedi_language_server",
        "mutt_ls",
        "gopls",
        "pylsp",
        "pylyzer",
        "pyre",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"emmet_ls",
				"prismals",
				"pyright",
				"clangd",
				"clang-format",
				"bashls",
				"jdtls",
        "java_language_server",
        "sqls",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"pylint",
			},
		})
	end,
}
