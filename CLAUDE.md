# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal Neovim configuration built on the lazy.nvim plugin manager. The configuration includes a custom "Shifty" multi-language REPL system that transforms markdown files into interactive development environments, similar to Jupyter notebooks but for any programming language.

## Architecture

### Core Structure
```
lua/andrew/
├── core/               # Core Neovim configuration
│   ├── init.lua       # Loads options and keymaps
│   ├── keymaps.lua    # Custom keybindings
│   └── options.lua    # Neovim settings
├── lazy.lua           # lazy.nvim setup
├── plugins/           # Plugin configurations
│   ├── lsp/           # LSP-related plugins
│   └── *.lua          # Individual plugin configs
└── ftplugin/          # Filetype-specific configurations

colors/                # Custom colorscheme system
├── mytheme.lua        # Main colorscheme
└── hqos/              # Advanced colorscheme variants

init.lua               # Entry point - loads core, lazy, and colorscheme
```

### Key Components

1. **Plugin Management**: Uses lazy.nvim for plugin management with modular plugin configurations
2. **LSP Configuration**: Dedicated LSP directory with mason.lua, lspconfig.lua for language server setup
3. **Custom Colorschemes**: Multiple colorscheme variants including a custom "mytheme" and "hqos" themes
4. **Shifty System**: Multi-language REPL platform that executes code blocks in markdown files

## Common Commands

### Plugin Management
- `:Lazy` - Open lazy.nvim interface
- `:Lazy sync` - Update all plugins
- `:Lazy clean` - Remove unused plugins

### Development
- No specific test commands (this is a Neovim config, not a development project)
- Configuration changes take effect on restart or `:source %`

## Key Mappings (Leader: `<space>`)

### File Navigation
- `<leader>ff` - Find files (Telescope)
- `<leader>fr` - Find recent files
- `<leader>fs` - Live grep search
- `<leader>fc` - Find string under cursor

### Window Management
- `<leader>sv` - Split vertically
- `<leader>sh` - Split horizontally
- `<leader>se` - Equal split sizes
- `<leader>sc` - Close split

### Terminal (Floating Terminal Plugin)
- `<leader>tt` - Toggle terminal
- `<leader>tf` - Toggle focus between terminal and editor
- `<leader>tr/tl/tb/tc` - Move terminal (right/left/bottom/center)

### Oil File Explorer
- `<space>-` - Open Oil file explorer in parent directory

## Shifty Multi-Language REPL

The Shifty system is a sophisticated multi-language REPL that allows executing code blocks in markdown files:

### Architecture
- **Registry System**: Runtime discovery and registration of language modules
- **Proxy System**: Language-agnostic request routing with lazy loading
- **Base Interface**: Consistent API across all supported languages
- **Modular Languages**: Each language (Lua, Python, JavaScript, compiled languages) has its own module

### Supported Languages
- **Lua**: Native execution with Neovim integration
- **Python**: Subprocess execution with venv support
- **JavaScript**: Node.js execution
- **Compiled Languages**: Full compilation pipeline with semantic validation (C, Java, Go, OCaml support)

### Configuration Location
Shifty configurations would be in `lua/andrew/plugins/custom/shifty/` (if implemented)

## Colorscheme System

The configuration includes multiple colorscheme options:
- **mytheme**: Custom colorscheme with purple/green theme
- **hqos variants**: Dark and light palette options in `colors/hqos/`

## Development Notes

### Adding New Plugins
1. Create a new file in `lua/andrew/plugins/`
2. Follow the lazy.nvim specification
3. Plugin will be auto-loaded via the lazy.setup import pattern

### Modifying LSP Configuration
- Edit files in `lua/andrew/plugins/lsp/`
- `lspconfig.lua` for server configurations
- `mason.lua` for language server installation

### Custom Keymaps
- Add to `lua/andrew/core/keymaps.lua`
- Follow existing patterns with descriptive names

### Colorscheme Modifications
- Edit `colors/mytheme.lua` for the main theme
- Modify `colors/hqos/` files for advanced palette options