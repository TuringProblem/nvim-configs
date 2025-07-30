local M = {}

-- Default configuration
local defaults = {
  -- Window settings
  window = {
    width = 80,
    height = 20,
    border = "rounded",
    title = " Shifty - Lua HOT Compiler ",
    title_pos = "center",
    relative = "editor",
    style = "minimal",
    focusable = true,
    zindex = 100
  },
  
  -- Keymaps
  keymaps = {
    toggle = "<leader>st",
    run = "<leader>sr",
    clear = "<leader>sc",
    close = "<Esc>"  -- In floating window
  },
  
  -- Execution settings
  execution = {
    timeout = 5000,  -- 5 seconds
    capture_print = true,
    show_errors = true,
    auto_clear = false
  },
  
  -- UI settings
  ui = {
    show_line_numbers = false,
    syntax_highlighting = true,
    auto_scroll = true,
    show_timestamp = true,
    colors = {
      success = "DiagnosticOk",
      error = "DiagnosticError", 
      info = "DiagnosticInfo",
      border = "FloatBorder"
    }
  },
  
  -- Parser settings
  parser = {
    supported_languages = { "lua" },  -- Only Lua for now
    block_pattern = "```%s*lua%s*\n(.-)\n```",  -- Standard markdown lua blocks
    require_language_tag = true  -- Require explicit 'lua' language tag
  }
}

M.options = {}

-- Setup configuration
function M.setup(user_opts)
  M.options = vim.tbl_deep_extend("force", defaults, user_opts or {})
  
  -- Validate configuration
  M.validate()
end

-- Validate configuration options
function M.validate()
  -- Validate window dimensions
  if M.options.window.width <= 0 or M.options.window.width > 200 then
    M.options.window.width = defaults.window.width
  end
  
  if M.options.window.height <= 0 or M.options.window.height > 50 then
    M.options.window.height = defaults.window.height
  end
  
  -- Validate timeout
  if M.options.execution.timeout <= 0 then
    M.options.execution.timeout = defaults.execution.timeout
  end
end

-- Get option value with fallback
function M.get(key)
  local keys = vim.split(key, ".", { plain = true })
  local value = M.options
  
  for _, k in ipairs(keys) do
    if type(value) == "table" and value[k] then
      value = value[k]
    else
      return nil
    end
  end
  
  return value
end

return M