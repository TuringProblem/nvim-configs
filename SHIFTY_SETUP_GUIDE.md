# Shifty Plugin Setup Guide

## What I Fixed

Your Shifty plugin had several issues that prevented it from working properly in Neovim:

1. **Incorrect Loading Mechanism**: The plugin was being loaded directly via `require()` instead of through the proper plugin system
2. **Missing Setup Call**: The plugin was loaded but never initialized with `setup()`
3. **Incorrect Module Paths**: All internal requires were using relative paths instead of full module paths

## Changes Made

### 1. Updated Plugin Loading (`lua/andrew/plugins/init.lua`)
- Replaced direct `require()` with proper plugin configuration
- Added proper setup call with configuration options
- Used `event = "VeryLazy"` for lazy loading

### 2. Fixed Module Paths
Updated all require statements in:
- `init.lua` - Main module requires
- `executor.lua` - Internal module requires  
- `ui.lua` - Internal module requires
- `parser.lua` - Internal module requires
- `shifty.lua` - Command handler requires

### 3. Created Test File
- Added `test_shifty.lua` with sample Lua code blocks for testing

## How to Test Your Plugin

### 1. Restart Neovim
```bash
nvim
```

### 2. Check Plugin Loading
In Neovim, run:
```vim
:Lazy
```
You should see "shifty" in the plugin list.

### 3. Test Commands
Open the test file:
```vim
:e test_shifty.lua
```

Try these commands:
- `:Shifty` or `:ShiftyToggle` - Toggle the floating window
- `:ShiftyRun` - Run the Lua code block at cursor
- `:ShiftyClear` - Clear output
- `:ShiftyClose` - Close the window

### 4. Test Keymaps
With cursor on a Lua code block, try:
- `<leader>st` - Toggle window
- `<leader>sr` - Run current block
- `<leader>sc` - Clear output

### 5. Test Code Execution
1. Place cursor inside a ```lua code block
2. Press `<leader>sr` or run `:ShiftyRun`
3. The floating window should appear with execution results

## Troubleshooting

### If plugin doesn't load:
1. Check for errors: `:messages`
2. Verify plugin path: `:lua print(vim.fn.stdpath("config"))`
3. Check Lazy loading: `:Lazy log`

### If commands don't work:
1. Check if plugin is loaded: `:lua print(require("andrew.plugins.custom.shifty"))`
2. Verify setup was called: `:lua print(require("andrew.plugins.custom.shifty").get_state())`

### If code execution fails:
1. Check syntax in your Lua blocks
2. Verify the parser is finding code blocks correctly
3. Check the floating window appears

## Configuration Options

You can customize the plugin in `lua/andrew/plugins/init.lua`:

```lua
require("andrew.plugins.custom.shifty").setup({
  keymaps = {
    toggle = "<leader>st",
    run = "<leader>sr", 
    clear = "<leader>sc",
    close = "<Esc>"
  },
  window = {
    width = 80,
    height = 20,
    border = "rounded"
  },
  execution = {
    timeout = 5000,
    capture_print = true,
    show_errors = true
  }
})
```

## Plugin Features

- **Hot Code Execution**: Run Lua code blocks directly from markdown files
- **Floating Window**: Clean output display with syntax highlighting
- **Error Handling**: Proper error capture and display
- **History**: Track execution history
- **Keymaps**: Customizable keyboard shortcuts
- **Commands**: Vim commands for all functionality

Your Shifty plugin should now work properly in Neovim! 🎉 