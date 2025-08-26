return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Custom function for definition with preview that opens in new tab
		local function goto_definition_with_preview()
			local params = vim.lsp.util.make_position_params()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result, ctx)
				if err or not result or vim.tbl_isempty(result) then
					print("No definition found")
					return
				end

				if #result == 1 then
					local uri = result[1].uri
					local range = result[1].range
					local bufnr = vim.uri_to_bufnr(uri)

					if not vim.api.nvim_buf_is_loaded(bufnr) then
						vim.fn.bufload(bufnr)
					end

					local start_line = range.start.line
					local end_line = math.min(range["end"].line + 10, vim.api.nvim_buf_line_count(bufnr) - 1)
					local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

					local width = math.min(80, vim.api.nvim_get_option("columns") - 4)
					local height = math.min(#lines, 20)

					local buf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
					vim.api.nvim_buf_set_option(buf, "filetype", vim.api.nvim_buf_get_option(bufnr, "filetype"))

					local win = vim.api.nvim_open_win(buf, false, {
						relative = "cursor",
						width = width,
						height = height,
						row = 1,
						col = 0,
						border = "rounded",
						title = " Preview: " .. vim.fn.fnamemodify(vim.uri_to_fname(uri), ":t") .. " ",
						title_pos = "center",
					})

					vim.api.nvim_buf_add_highlight(
						buf,
						-1,
						"Search",
						range.start.line - start_line,
						range.start.character,
						range["end"].character
					)

					local opts = { buffer = buf, nowait = true, silent = true }
					vim.keymap.set("n", "<CR>", function()
						vim.api.nvim_win_close(win, true)
						-- Execute your custom tab open command
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<leader>to", true, false, true),
							"n",
							false
						)
						vim.defer_fn(function()
							vim.lsp.util.jump_to_location(result[1], "utf-8")
						end, 200)
					end, opts)
					vim.keymap.set("n", "t", function()
						vim.api.nvim_win_close(win, true)
						vim.cmd("tabnew")
						vim.lsp.util.jump_to_location(result[1], "utf-8")
					end, opts)
					vim.keymap.set("n", "q", function()
						vim.api.nvim_win_close(win, true)
					end, opts)

					print("Press <CR> to open with <leader>to, 't' for direct new tab, 'q' to close")
				else
					require("telescope.builtin").lsp_definitions()
				end
			end)
		end

		-- LSP keymaps
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				-- Telescope LSP keybinds with preview
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				-- Open in new tab keybinds
				keymap.set("n", "<leader>gd", function()
					vim.cmd("tabnew")
					vim.lsp.buf.definition()
				end, { buffer = ev.buf, silent = true, desc = "Go to definition in new tab" })

				keymap.set("n", "<leader>gr", function()
					vim.cmd("tabnew")
					require("telescope.builtin").lsp_references()
				end, { buffer = ev.buf, silent = true, desc = "Show references in new tab" })

				-- Custom definition with preview
				keymap.set(
					"n",
					"<leader>gp",
					goto_definition_with_preview,
					{ buffer = ev.buf, silent = true, desc = "Go to definition with preview" }
				)

				keymap.set("n", "K", vim.lsp.buf.hover, opts)
				keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Enhanced capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic symbols
		local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Manually setup the language servers we need
		local servers = {
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"eslint",
			"jdtls",
			"clangd",
			"rust_analyzer",
			"gopls",
			"sqls",
			"bashls",
			"lua_ls",
		}

		-- Setup each server with basic config
		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				capabilities = capabilities,
			})
		end

		-- Special configurations for specific servers
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "literal",
						includeInlayFunctionParameterTypeHints = true,
					},
				},
			},
		})

		lspconfig.clangd.setup({
			capabilities = capabilities,
			cmd = { "clangd", "--offset-encoding=utf-16" },
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					completion = { callSnippet = "Replace" },
				},
			},
		})
	end,
}
