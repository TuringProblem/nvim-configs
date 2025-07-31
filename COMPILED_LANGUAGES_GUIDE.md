# 🚀 Compiled Languages Guide for Shifty

## 🎯 Overview

Shifty now supports **compiled languages** with intelligent semantic validation and error suggestions. This guide shows you how to add support for any compiled language like C, Java, Go, OCaml, and more.

## 🔧 How Compiled Language Support Works

### Core Features
- ✅ **Compilation Pipeline**: Write → Compile → Execute → Cleanup
- ✅ **Semantic Validation**: Pre-compilation code analysis
- ✅ **Error Suggestions**: Intelligent hints for fixing issues
- ✅ **Performance Metrics**: Compilation and execution timing
- ✅ **Temporary File Management**: Automatic cleanup

### Architecture Pattern
```lua
-- 1. Validate code syntax and semantics
-- 2. Create temporary source file
-- 3. Compile with appropriate flags
-- 4. Execute compiled binary
-- 5. Capture output and errors
-- 6. Clean up temporary files
-- 7. Provide suggestions for improvements
```

## 🛠️ Adding New Compiled Languages

### Step 1: Create Language Module

Create `lua/andrew/plugins/custom/shifty/languages/{language}/init.lua`:

```lua
local M = {}

local base = require('andrew.plugins.custom.shifty.languages.base')
local utils = require('andrew.plugins.custom.shifty.utils')

-- Language metadata
local metadata = {
  name = "your_language",
  version = "1.0.0",
  file_extensions = {".ext"},
  executable_check = "compiler --version",
  aliases = {"alias1", "alias2"}
}

-- Create the language module
local function create_language_module(config)
  config = config or {}
  
  local module = base.create_base_module(metadata, config)
  
  -- Override methods with language-specific implementations
  module.execute_code = function(code, context)
    return M.execute_language_code(module, code, context)
  end
  
  module.setup_environment = function(config)
    return M.setup_language_environment(module, config)
  end
  
  module.get_capabilities = function()
    return M.get_language_capabilities(module)
  end
  
  module.health_check = function()
    return M.health_check_language(module)
  end
  
  module.cleanup = function()
    return M.cleanup_language(module)
  end
  
  return module
end

-- Implement your language-specific functions here...

local language_module = create_language_module()
return language_module
```

### Step 2: Implement Semantic Validation

```lua
-- Validate language-specific semantics
function M.validate_language_semantics(code)
  local suggestions = {}
  local warnings = {}
  
  -- Language-specific validation rules
  -- Examples:
  -- - Check for required functions (main, etc.)
  -- - Validate imports/includes
  -- - Check syntax patterns
  -- - Suggest missing dependencies
  
  return #warnings == 0, table.concat(warnings, "; "), suggestions
end
```

### Step 3: Implement Code Execution

```lua
function M.execute_language_code(module, code, context)
  local result = {
    success = false,
    output = "",
    error = nil,
    execution_time = 0,
    metadata = {}
  }
  
  -- 1. Validate code
  local valid, error_msg = base.validate_code(code, "your_language")
  if not valid then
    result.error = error_msg
    result.output = result.error
    return result
  end
  
  -- 2. Validate semantics
  local semantically_valid, semantic_error, suggestions = M.validate_language_semantics(code)
  
  -- 3. Create temporary files
  local temp_source_file = os.tmpname() .. ".ext"
  local temp_exe_file = os.tmpname()
  
  -- 4. Write code to file
  local file = io.open(temp_source_file, "w")
  if not file then
    result.error = "Failed to create temporary file"
    return result
  end
  file:write(code)
  file:close()
  
  -- 5. Compile
  local compile_command = string.format("%s -o %s %s", 
    module.environment.compiler, temp_exe_file, temp_source_file)
  local compile_output = vim.fn.system(compile_command)
  local compile_success = vim.v.shell_error == 0
  
  if not compile_success then
    result.error = "Compilation failed"
    result.output = "Compilation Error:\n" .. compile_output
    
    -- Add semantic suggestions
    if not semantically_valid and #suggestions > 0 then
      result.output = result.output .. "\n\n💡 Suggestions:\n"
      for _, suggestion in ipairs(suggestions) do
        result.output = result.output .. "  • " .. suggestion .. "\n"
      end
    end
    
    os.remove(temp_source_file)
    return result
  end
  
  -- 6. Execute
  local exec_output = vim.fn.system(temp_exe_file)
  local exec_success = vim.v.shell_error == 0
  
  -- 7. Clean up
  os.remove(temp_source_file)
  os.remove(temp_exe_file)
  
  -- 8. Process results
  if exec_success then
    result.success = true
    result.output = exec_output:gsub("\n*$", "")
    if result.output == "" then
      result.output = "✓ Program executed successfully (no output)"
    end
  else
    result.success = false
    result.error = "Runtime error"
    result.output = "Runtime Error:\n" .. exec_output
  end
  
  -- 9. Add semantic warnings
  if not semantically_valid and #suggestions > 0 then
    result.output = result.output .. "\n\n⚠️  Warnings:\n"
    for _, suggestion in ipairs(suggestions) do
      result.output = result.output .. "  • " .. suggestion .. "\n"
    end
  end
  
  return result
end
```

## 🌍 Language Examples

### Java Support
```lua
-- languages/java/init.lua
local metadata = {
  name = "java",
  version = "1.0.0",
  file_extensions = {".java"},
  executable_check = "javac -version",
  aliases = {"java"}
}

-- Java-specific validation
function M.validate_java_semantics(code)
  local suggestions = {}
  local warnings = {}
  
  -- Check for public class
  if not code:match("public%s+class%s+%w+") then
    table.insert(suggestions, "Add 'public class Main' declaration")
    table.insert(warnings, "No public class found")
  end
  
  -- Check for main method
  if not code:match("public%s+static%s+void%s+main%s*%(") then
    table.insert(suggestions, "Add 'public static void main(String[] args)' method")
    table.insert(warnings, "No main method found")
  end
  
  -- Check for imports
  local common_imports = {
    ["System.out.println"] = "import java.util.*;",
    ["Scanner"] = "import java.util.Scanner;",
    ["ArrayList"] = "import java.util.ArrayList;",
    ["HashMap"] = "import java.util.HashMap;"
  }
  
  for func, import in pairs(common_imports) do
    if code:match(func:gsub("%%", "%%")) and not code:match(import:gsub("%%", "%%")) then
      table.insert(suggestions, string.format("Add '%s' for %s", import, func))
    end
  end
  
  return #warnings == 0, table.concat(warnings, "; "), suggestions
end
```

### Go Support
```lua
-- languages/go/init.lua
local metadata = {
  name = "go",
  version = "1.0.0",
  file_extensions = {".go"},
  executable_check = "go version",
  aliases = {"go", "golang"}
}

-- Go-specific validation
function M.validate_go_semantics(code)
  local suggestions = {}
  local warnings = {}
  
  -- Check for package declaration
  if not code:match("package%s+main") then
    table.insert(suggestions, "Add 'package main' declaration")
    table.insert(warnings, "No package main declaration")
  end
  
  -- Check for main function
  if not code:match("func%s+main%s*%(") then
    table.insert(suggestions, "Add 'func main()' function")
    table.insert(warnings, "No main function found")
  end
  
  -- Check for imports
  local common_imports = {
    ["fmt.Println"] = "import \"fmt\"",
    ["time.Sleep"] = "import \"time\"",
    ["os.Exit"] = "import \"os\"",
    ["strconv.Atoi"] = "import \"strconv\""
  }
  
  for func, import in pairs(common_imports) do
    if code:match(func:gsub("%%", "%%")) and not code:match(import:gsub("%%", "%%")) then
      table.insert(suggestions, string.format("Add '%s' for %s", import, func))
    end
  end
  
  return #warnings == 0, table.concat(warnings, "; "), suggestions
end
```

### OCaml Support
```lua
-- languages/ocaml/init.lua
local metadata = {
  name = "ocaml",
  version = "1.0.0",
  file_extensions = {".ml", ".mli"},
  executable_check = "ocamlc -version",
  aliases = {"ocaml", "ml"}
}

-- OCaml-specific validation
function M.validate_ocaml_semantics(code)
  local suggestions = {}
  local warnings = {}
  
  -- Check for proper OCaml syntax
  if not code:match("let%s+_%s*=%s*") and not code:match("let%s+main%s*=%s*") then
    table.insert(suggestions, "Add 'let _ = ' or 'let main = ' for execution")
    table.insert(warnings, "No execution entry point found")
  end
  
  -- Check for proper semicolons
  local lines = vim.split(code, "\n")
  for i, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if trimmed ~= "" and not trimmed:match("^%s*;;") and not trimmed:match("^%s*let") then
      if trimmed:match("[^;]%s*$") and not trimmed:match("^%s*$") then
        table.insert(suggestions, string.format("Line %d: Add ';;' at end of expression", i))
      end
    end
  end
  
  return #warnings == 0, table.concat(warnings, "; "), suggestions
end
```

## ⚙️ Configuration

Add your language to the configuration:

```lua
-- In config.lua
languages = {
  your_language = {
    enabled = true,
    compiler = "your_compiler",
    flags = "-your -flags",
    optimization = "-O2",
    timeout = 15000
  }
}
```

## 🎯 Best Practices

### 1. Semantic Validation
- **Check for required elements** (main functions, imports, etc.)
- **Validate syntax patterns** (semicolons, brackets, etc.)
- **Suggest missing dependencies** (headers, imports, etc.)
- **Provide context-aware suggestions**

### 2. Error Handling
- **Clear error messages** with line numbers
- **Compilation vs runtime errors** distinction
- **Helpful suggestions** for fixing issues
- **Graceful degradation** when tools aren't available

### 3. Performance
- **Efficient compilation** with appropriate flags
- **Temporary file cleanup** to prevent disk bloat
- **Timeout handling** for long-running compilations
- **Resource monitoring** (memory, CPU usage)

### 4. User Experience
- **Consistent interface** across all languages
- **Rich output formatting** with syntax highlighting
- **Progress indicators** for long operations
- **Keyboard shortcuts** for common actions

## 🚀 Advanced Features

### Multi-File Support
```lua
-- Support for multiple source files
local source_files = {"main.c", "utils.c", "header.h"}
local compile_command = string.format("gcc -o %s %s", 
  temp_exe_file, table.concat(source_files, " "))
```

### Dependency Management
```lua
-- Check for required dependencies
local dependencies = {"libcurl", "libssl", "libcrypto"}
for _, dep in ipairs(dependencies) do
  if not M.check_dependency(dep) then
    table.insert(suggestions, string.format("Install %s", dep))
  end
end
```

### Build System Integration
```lua
-- Support for Makefiles, Cargo.toml, etc.
if vim.fn.filereadable("Makefile") == 1 then
  compile_command = "make"
elseif vim.fn.filereadable("Cargo.toml") == 1 then
  compile_command = "cargo build"
end
```

## 🎉 Success Metrics

Your compiled language support should achieve:

✅ **Compilation Success**: >95% of valid code compiles successfully  
✅ **Error Detection**: >90% of semantic errors are caught  
✅ **Suggestion Quality**: >80% of suggestions are helpful  
✅ **Performance**: <5 second compilation time for typical code  
✅ **User Satisfaction**: Intuitive and helpful error messages  

## 🔮 Future Enhancements

- **Incremental Compilation**: Only recompile changed parts
- **Parallel Compilation**: Use multiple cores for faster builds
- **Caching**: Cache compilation results for repeated code
- **IDE Integration**: LSP-like features for real-time feedback
- **Debugging Support**: Integrated debugging capabilities

---

**Your Shifty platform now supports the full spectrum of programming languages, from interpreted to compiled, with intelligent assistance every step of the way!** 🚀 