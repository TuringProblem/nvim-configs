return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    local keymap = vim.keymap

    -- native completion popup behavior
    vim.opt.completeopt = { "menu", "menuone", "noinsert", "popup" }

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        -- built-in LSP completion popup (replaces nvim-cmp)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client and client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        -- LSP navigation (Telescope-powered, buffer-local so only active when a server attaches)
        opts.desc = "Go to definition"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

        opts.desc = "Find references"
        keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

        opts.desc = "Go to implementation"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

        opts.desc = "Go to type definition"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- no telescope picker for declaration

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", vim.diagnostic.setloclist, opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    -- server overrides (base configs come from nvim-lspconfig's lsp/ dir)
    vim.lsp.config("ts_ls", {
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
        },
      },
    })

    vim.lsp.config("tinymist", {
      settings = {
        exportPdf = "onType",
        serverPath = "",
      },
    })

    vim.lsp.config("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
            extraPaths = {},
          },
        },
        pyright = {
          disableOrganizeImports = false,
        },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          checkOnSave = {
            command = "cargo clippy",
          },
          procMacro = {
            enable = true,
          },
          diagnostics = {
            enable = true,
            experimental = {
              enable = true,
            },
          },
        },
      },
    })

    -- explicit server list (jdtls is handled by nvim-jdtls, not here)
    vim.lsp.enable({
      "clangd",
      "ts_ls",
      "lua_ls",
      "tinymist",
      "pyright",
      "rust_analyzer",
      "zls",
      "racket_langserver",
    })
  end,
}
