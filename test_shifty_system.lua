-- Test script for Shifty Multi-Language REPL System
-- Run this in Neovim with :lua dofile('test_shifty_system.lua')

print("🚀 Testing Shifty Multi-Language REPL System...")

-- Test 1: Load the main module
local success, shifty = pcall(require, 'andrew.plugins.custom.shifty')
if not success then
  print("❌ Failed to load main Shifty module:", shifty)
  return
end
print("✅ Main Shifty module loaded successfully")

-- Test 2: Load the registry
local success, registry = pcall(require, 'andrew.plugins.custom.shifty.registry')
if not success then
  print("❌ Failed to load registry:", registry)
  return
end
print("✅ Registry module loaded successfully")

-- Test 3: Load the proxy
local success, proxy = pcall(require, 'andrew.plugins.custom.shifty.proxy')
if not success then
  print("❌ Failed to load proxy:", proxy)
  return
end
print("✅ Proxy module loaded successfully")

-- Test 4: Load the languages module
local success, languages = pcall(require, 'andrew.plugins.custom.shifty.languages')
if not success then
  print("❌ Failed to load languages module:", languages)
  return
end
print("✅ Languages module loaded successfully")

-- Test 5: Load individual language modules
local language_modules = {"lua", "python", "javascript"}
for _, lang in ipairs(language_modules) do
  local success, module = pcall(require, 'andrew.plugins.custom.shifty.languages.' .. lang)
  if success then
    print("✅ Language module '" .. lang .. "' loaded successfully")
  else
    print("❌ Failed to load language module '" .. lang .. "':", module)
  end
end

-- Test 6: Initialize the system
print("\n🔧 Initializing Shifty system...")
local success, result = pcall(function()
  shifty.setup({
    languages = {
      lua = { enabled = true },
      python = { enabled = true, interpreter = "python3" },
      javascript = { enabled = true, runtime = "node" }
    }
  })
end)

if success then
  print("✅ Shifty system initialized successfully")
else
  print("❌ Failed to initialize Shifty system:", result)
end

-- Test 7: Check system info
local success, info = pcall(function()
  return proxy.get_system_info()
end)

if success then
  print("✅ System info retrieved successfully")
  print("  - Version:", info.version)
  print("  - Healthy:", info.healthy)
  print("  - Available languages:", #info.available_languages)
  for _, lang in ipairs(info.available_languages) do
    print("    - " .. lang)
  end
else
  print("❌ Failed to get system info:", info)
end

print("\n🎉 Shifty system test complete!") 