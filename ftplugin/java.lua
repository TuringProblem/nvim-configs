local jdtls = require("jdtls")

-- Find root directory for the Java project
local root_dir = jdtls.setup.find_root({".git", "mvnw", "gradlew", "pom.xml", "build.gradle"})
if not root_dir then
	return
end

-- Use direct path to jdtls installation (simpler approach)
local jdtls_install = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

-- Check if jdtls is actually installed
if vim.fn.isdirectory(jdtls_install) == 0 then
	vim.notify("JDTLS not found. Please install it via Mason (:Mason)", vim.log.levels.ERROR)
	return
end

-- Find the actual launcher jar file
local launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
	vim.notify("JDTLS launcher jar not found in " .. jdtls_install .. "/plugins/", vim.log.levels.ERROR)
	return
end

-- Determine OS configuration
local config_dir
if vim.fn.has("mac") == 1 then
	if vim.fn.system("uname -m"):match("arm64") then
		config_dir = jdtls_install .. "/config_mac_arm"
	else
		config_dir = jdtls_install .. "/config_mac"
	end
elseif vim.fn.has("unix") == 1 then
	config_dir = jdtls_install .. "/config_linux"
else
	config_dir = jdtls_install .. "/config_win"
end

-- Get workspace directory
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/workspace/" .. project_name

-- Ensure workspace directory exists
vim.fn.mkdir(workspace_dir, "p")

local config = {
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens", "java.base/java.util=ALL-UNNAMED",
		"--add-opens", "java.base/java.lang=ALL-UNNAMED",
		"-jar", launcher_jar,
		"-configuration", config_dir,
		"-data", workspace_dir,
	},
	root_dir = root_dir,
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = true,
			},
		},
		signatureHelp = { enabled = true },
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*"
			},
		},
		contentProvider = { preferred = "fernflower" },
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		},
	},
	init_options = {
		bundles = {}
	},
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	on_attach = function(client, bufnr)
		-- Java-specific keybindings
		local opts = { buffer = bufnr, silent = true }
		
		vim.keymap.set("n", "gd", function()
			require("jdtls").goto_definition()
		end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		
		vim.keymap.set("n", "gR", function()
			require("telescope.builtin").lsp_references({ reuse_win = true })
		end, vim.tbl_extend("force", opts, { desc = "Find references" }))
		
		vim.keymap.set("n", "gi", function()
			require("telescope.builtin").lsp_implementations({ reuse_win = true })
		end, vim.tbl_extend("force", opts, { desc = "Find implementations" }))
		
		vim.keymap.set("n", "gt", function()
			require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
		end, vim.tbl_extend("force", opts, { desc = "Find type definitions" }))
		
		-- Java specific commands
		vim.keymap.set("n", "<leader>co", function()
			require("jdtls").organize_imports()
		end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
		
		vim.keymap.set("n", "<leader>crv", function()
			require("jdtls").extract_variable()
		end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
		
		vim.keymap.set("v", "<leader>crv", function()
			require("jdtls").extract_variable(true)
		end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))
		
		vim.keymap.set("n", "<leader>crc", function()
			require("jdtls").extract_constant()
		end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
		
		vim.keymap.set("v", "<leader>crc", function()
			require("jdtls").extract_constant(true)
		end, vim.tbl_extend("force", opts, { desc = "Extract constant" }))
		
		vim.keymap.set("v", "<leader>crm", function()
			require("jdtls").extract_method(true)
		end, vim.tbl_extend("force", opts, { desc = "Extract method" }))
	end,
}

-- Start or attach to jdtls
jdtls.start_or_attach(config)