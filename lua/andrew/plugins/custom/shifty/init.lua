local M = {}

local config = require('andrew.plugins.custom.shifty.config')
local parser = require('andrew.plugins.custom.shifty.parser')
local executor = require('andrew.plugins.custom.shifty.executor')
local ui = require('andrew.plugins.custom.shifty.ui')
local utils = require('andrew.plugins.custom.shifty.utils')

---@type {initialized: boolean, floating_win: number, current_output: string, history: {code: string, result: string, timestamp: string, line: number}[]}
local state = {
  initialized = false,
  floating_win = nil,
  current_output = "",
  history = {}
}

---@param opts {keymaps: {toggle: string, run: string, clear: string, close: string}}
function M.setup(opts)
  opts = opts or {}
  config.setup(opts)
  
  vim.api.nvim_create_user_command('ShiftyToggle', M.toggle, {})
  vim.api.nvim_create_user_command('ShiftyRun', M.run_current_block, {})
  vim.api.nvim_create_user_command('ShiftyClear', M.clear_output, {})
  vim.api.nvim_create_user_command('ShiftyClose', M.close, {})
  
  if config.options.keymaps.toggle then
    vim.keymap.set('n', config.options.keymaps.toggle, M.toggle, { desc = 'Toggle Shifty window' })
  end
  
  if config.options.keymaps.run then
    vim.keymap.set('n', config.options.keymaps.run, M.run_current_block, { desc = 'Run current code block' })
  end
  
  if config.options.keymaps.clear then
    vim.keymap.set('n', config.options.keymaps.clear, M.clear_output, { desc = 'Clear Shifty output' })
  end
  
  state.initialized = true
  utils.log("Shifty initialized successfully", "info")
end

---@return void
function M.toggle()
  if not state.initialized then
    utils.log("Shifty not initialized. Run :lua require('andrew.plugins.custom.shifty').setup()", "error")
    return
  end
  
  if state.floating_win and vim.api.nvim_win_is_valid(state.floating_win) then
    M.close()
  else
    M.open()
  end
end

---@return void
function M.open()
  state.floating_win = ui.create_floating_window()
  ui.setup_window_keymaps(state.floating_win)
  utils.log("Shifty window opened", "info")
end


---@return void
function M.close()
  if state.floating_win and vim.api.nvim_win_is_valid(state.floating_win) then
    vim.api.nvim_win_close(state.floating_win, true)
    state.floating_win = nil
    utils.log("Shifty window closed", "info")
  end
end

---@return void
function M.run_current_block()
  local current_buf = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
  
  local code_block = parser.extract_code_block_at_cursor(lines, cursor_pos[1])
  
  if not code_block then
    utils.log("No Lua code block found at cursor position", "warn")
    return
  end
  
  M.execute_code(code_block.code, code_block)
end

---@param code string
---@param block_info {start_line: number}
---@return void
function M.execute_code(code, block_info)
  if not state.floating_win or not vim.api.nvim_win_is_valid(state.floating_win) then
    M.open()
  end
  
  local block_name = string.format("lua block (line %d)", block_info.start_line or 0)
  local result = executor.run_lua_code(code, block_name)
  
  table.insert(state.history, {
    code = code,
    result = result,
    timestamp = os.date("%H:%M:%S"),
    line = block_info.start_line
  })
  
  state.current_output = result.output
  ui.update_output(state.floating_win, result, block_name)
  
  utils.log(string.format("Executed Lua block at line %d - %s", 
           block_info.start_line or 0, result.success and "SUCCESS" or "ERROR"), 
           result.success and "info" or "error")
end

---@return void
function M.clear_output()
  state.current_output = ""
  if state.floating_win and vim.api.nvim_win_is_valid(state.floating_win) then
    ui.clear_output(state.floating_win)
  end
  utils.log("Output cleared", "info")
end

---@return {code: string, result: string, timestamp: string, line: number}[]
---@return void
function M.get_history()
  return state.history
end

---@return {initialized: boolean, floating_win: number, current_output: string, history: {code: string, result: string, timestamp: string, line: number}[]}
function M.get_state()
  return state
end

return M