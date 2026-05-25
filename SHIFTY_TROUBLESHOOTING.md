# 🔧 Shifty Troubleshooting Guide

## 🚨 Common Issues and Solutions

### Issue 1: Language Module Loading Errors

**Error**: `module 'lua/andrew/plugins/custom/shifty/languages.javascript' not found`

**Cause**: Module path resolution issues in the language discovery system.

**Solution**: The module paths have been fixed. The system now correctly loads:
- `andrew.plugins.custom.shifty.languages.lua`
- `andrew.plugins.custom.shifty.languages.python`  
- `andrew.plugins.custom.shifty.languages.javascript`

### Issue 2: Circular Reference Errors

**Error**: Module loading fails due to circular references.

**Cause**: Language modules were overwriting the `M` table incorrectly.

**Solution**: Fixed the module creation pattern in all language modules.

### Issue 3: System Command Execution Issues

**Error**: Python/JavaScript execution fails.

**Cause**: Incorrect handling of `vim.fn.system` return values.

**Solution**: Fixed to properly capture exit codes and output.

## 🧪 Testing the System

### Quick Test
Run this in Neovim to test the system:

```lua
:lua dofile('test_shifty_system.lua')
```

### Manual Testing
1. **Load modules individually**:
   ```lua
   :lua print(require('andrew.plugins.custom.shifty.languages.lua'))
   :lua print(require('andrew.plugins.custom.shifty.languages.python'))
   :lua print(require('andrew.plugins.custom.shifty.languages.javascript'))
   ```

2. **Test the registry**:
   ```lua
   :lua local r = require('andrew.plugins.custom.shifty.registry'); print(r.get_statistics())
   ```

3. **Test the proxy**:
   ```lua
   :lua local p = require('andrew.plugins.custom.shifty.proxy'); print(p.get_system_info())
   ```

## 🔍 Debug Steps

### Step 1: Check Module Loading
```lua
-- Test each module individually
local modules = {
  'andrew.plugins.custom.shifty',
  'andrew.plugins.custom.shifty.registry',
  'andrew.plugins.custom.shifty.proxy',
  'andrew.plugins.custom.shifty.languages',
  'andrew.plugins.custom.shifty.languages.lua',
  'andrew.plugins.custom.shifty.languages.python',
  'andrew.plugins.custom.shifty.languages.javascript'
}

for _, module_name in ipairs(modules) do
  local success, result = pcall(require, module_name)
  print(string.format("%s: %s", module_name, success and "✅" or "❌"))
  if not success then
    print("  Error:", result)
  end
end
```

### Step 2: Check Language Availability
```lua
-- Check if languages are available on your system
local commands = {
  lua = "lua --version",
  python = "python3 --version", 
  javascript = "node --version"
}

for lang, cmd in pairs(commands) do
  local output = vim.fn.system(cmd)
  local available = vim.v.shell_error == 0
  print(string.format("%s: %s", lang, available and "✅" or "❌"))
  if available then
    print("  Version:", vim.trim(output))
  end
end
```

### Step 3: Test Language Discovery
```lua
-- Test the language discovery system
local languages = require('andrew.plugins.custom.shifty.languages')
languages.init()
print("Discovery stats:", vim.inspect(languages.get_discovery_stats()))
```

## 🛠️ Manual Setup

If automatic discovery fails, you can manually register languages:

```lua
-- Manual language registration
local registry = require('andrew.plugins.custom.shifty.registry')
local lua_module = require('andrew.plugins.custom.shifty.languages.lua')
local python_module = require('andrew.plugins.custom.shifty.languages.python')
local js_module = require('andrew.plugins.custom.shifty.languages.javascript')

registry.register_language('lua', lua_module)
registry.register_language('python', python_module)
registry.register_language('javascript', js_module)

print("Languages registered:", vim.inspect(registry.get_registered_languages()))
```

## 🎯 Expected Behavior

After fixing the issues, you should see:

```
[Shifty:INFO] Initializing language discovery system...
[Shifty:INFO] Starting language discovery...
[Shifty:INFO] Attempting to load language module 'lua' from path 'andrew.plugins.custom.shifty.languages.lua'
[Shifty:INFO] Successfully loaded language module 'lua'
[Shifty:INFO] Successfully registered language 'lua'
[Shifty:INFO] Attempting to load language module 'python' from path 'andrew.plugins.custom.shifty.languages.python'
[Shifty:INFO] Successfully loaded language module 'python'
[Shifty:INFO] Successfully registered language 'python'
[Shifty:INFO] Attempting to load language module 'javascript' from path 'andrew.plugins.custom.shifty.languages.javascript'
[Shifty:INFO] Successfully loaded language module 'javascript'
[Shifty:INFO] Successfully registered language 'javascript'
[Shifty:INFO] Discovered 3 language modules
[Shifty:INFO] Auto-registering built-in languages...
[Shifty:INFO] Language discovery complete: 3 discovered, 3 registered, 3 healthy
```

## 🚀 Usage After Fix

Once the system is working:

1. **Open a markdown file** with code blocks
2. **Position cursor** in a code block
3. **Run**: `:ShiftyRun` or press `<leader>sr`
4. **Check status**: `:ShiftyInfo`

## 🔧 Configuration

If you need to customize the setup:

```lua
require('andrew.plugins.custom.shifty').setup({
  languages = {
    python = {
      interpreter = "python3",  -- or "python"
      venv_support = true,
      timeout = 10000
    },
    javascript = {
      runtime = "node",
      npm_support = false,
      timeout = 8000
    }
  }
})
```

## 📞 Still Having Issues?

If you're still experiencing problems:

1. **Check Neovim version**: Ensure you're using Neovim 0.8+
2. **Check Lua version**: Ensure LuaJIT is available
3. **Check system commands**: Verify `python3`, `node`, `lua` are available
4. **Check file permissions**: Ensure the language module files are readable
5. **Run the test script**: `:lua dofile('test_shifty_system.lua')`

The system should now work correctly with the fixes applied! 🎉 