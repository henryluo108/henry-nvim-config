# AGENTS.md

This document provides guidelines and commands for agentic coding agents working in this Neovim configuration repository.

## Repository Context

This is a personal Neovim configuration using **lazy.nvim** as the plugin manager. The configuration is written in Lua (`lua/` directory) with a modular architecture designed for performance and conflict-free multi-LSP server support.

**User:** Henry (Chinese conversation, English code)

## Build/Lint/Test Commands

### Neovim Configuration Testing
```bash
# Test Neovim configuration startup
nvim --clean -c "lua require('core.init')" +qa

# Check for configuration errors
nvim --headless "+checkhealth" +qa

# Test plugin loading
nvim --headless "+Lazy! show" +qa

# Profile startup performance
nvim --headless "+StartupTime" +qa
```

### Plugin Management
```bash
# Install/update all plugins
nvim --headless "+Lazy! sync" +qa

# Clean unused plugins
nvim --headless "+Lazy! clean" +qa

# Check plugin status
nvim --headless "+Lazy! show" +qa
```

### LSP and Language Server Management
```vim
" Inside Neovim:
:LspInfo                  " Check LSP server status
:Mason                    " Open Mason package manager
:LspInstall <server>      " Install specific LSP server
:checkhealth lsp         " LSP health check
```

### Treesitter Management
```vim
:TSInstall <language>     " Install syntax parser
:TSUpdate                 " Update all parsers
:TSPlaygroundToggle       " Open syntax playground
```

## Code Style Guidelines

### File Organization
- **Entry point**: `init.lua` sets up Python path, F5 runner, then loads `lua/core/init.lua`
- **Core modules**: `lua/core/` for fundamental functionality (settings, keymaps)
- **Plugin configs**: `lua/configs/` for individual plugin setups
- **Plugin specs**: `lua/plugins/spec.lua` for lazy.nvim plugin definitions
- **LSP utilities**: `lua/utils/lsp-utils.lua` for deduplication handlers

### Lua Coding Conventions

#### Imports and Modules
```lua
-- Use local module variables
local M = {}
local utils = require("core.utils")

-- Use explicit returns
return M
```

#### Configuration Pattern
```lua
-- Use consistent module pattern for configs
local M = {}
function M.config()
    -- Plugin configuration here
end
return M
```

#### Naming Conventions
- **Files**: kebab-case (`nvim-cmp.lua`, `treesitter.lua`)
- **Variables**: snake_case (`local capabilities`, `local on_attach`)
- **Functions**: snake_case for internal, `M.config()` for module exports
- **Constants**: UPPER_SNAKE_CASE for true constants
- **Keymaps**: descriptive names like `<leader>lf` for format

#### Error Handling
```lua
-- Use pcall for safe module loading
local success, keymaps_module = pcall(require, 'core.keymaps')
if success then
    keymaps_module.deduplicated_code_action()
else
    -- Fallback behavior
    vim.lsp.buf.code_action()
end
```

### LSP Configuration Standards

#### Multi-Server Management
- Each filetype has a designated primary LSP server
- Secondary servers have capabilities disabled to prevent conflicts
- Use `on_attach` function to manage capability conflicts

#### Primary/Secondary Server Mapping
- **Python**: pyright (primary), ruff (linting/formatting)
- **Lua**: lua_ls (primary)
- **TypeScript/JavaScript**: ts_ls (primary)
- **Go**: gopls (primary)
- **Bash**: bashls (primary)

#### LSP Keymap Standards
- **Global deduplicated mappings**: Use custom `gd` handler to eliminate duplicates
- **Leader mappings**: `<leader>l*` prefix for LSP operations
- **Buffer-local**: Set only non-conflicting keymaps in `on_attach`

### Plugin Management

#### Lazy.nvim Configuration
```lua
-- Plugin spec format in lua/plugins/spec.lua
{
    "plugin/name",
    config = function()
        require("configs.plugin-name").config()
    end,
    lazy = true,  -- Enable lazy loading when possible
    dependencies = { "dependency/plugin" }
}
```

#### Version Pinning
- Use `lazy-lock.json` for reproducible plugin versions
- Update plugins with `Lazy! sync` to maintain consistency

### Keymap Architecture

#### Leader Key Organization
- `<leader>c*`: File operations (create, write, quit, edit)
- `<leader>w*`: Window management (splits, navigation, resize)
- `<leader>b*`: Buffer management (next, prev, delete)
- `<leader>l*`: LSP operations (hover, rename, format, code action)
- `<leader>h*`: Git operations (hunks, blame, diff)
- `<leader>s*`: Search operations
- `<leader>t*`: Terminal operations
- `<leader>g*`: Diagnostic navigation

#### Function Key Mappings
- `<F2>`: Terminal toggle
- `<F3>`/`<C-n>`: File tree toggle
- `<F4>`: Symbols outline
- `<F8>`: Tagbar
- `<F9>`: Telescope find files
- `<F10>`: Telescope git files
- `<F11>`: Telescope buffers

### Language-Specific Configurations

#### Python Environment
- **Python path**: `/Users/henry/anaconda3/bin/python`
- **Formatter**: Black (via `ff` keymap or `<leader>lf`)
- **Runner**: F5 uses `/Users/henry/anaconda3/bin/python3`

#### Go Configuration
- **LSP**: gopls with vim-go integration
- **Conflict prevention**: Disable vim-go's default `gd` mapping
- **Runner**: F5 executes `go run %`

#### JavaScript/TypeScript
- **Root detection**: package.json, tsconfig.json, jsconfig.json
- **LSP**: ts_ls with proper configuration

### Best Practices

#### Performance Optimization
- Disable unused standard plugins in `lua/core/init.lua`
- Use lazy loading for non-essential plugins
- Profile startup with `:StartupTime`

#### Conflict Resolution
- Prevent LSP capability conflicts in `on_attach`
- Use deduplicated handlers for multiple LSP servers
- Disable conflicting plugin keymaps (e.g., vim-go `gd`)

#### Modular Design
- Keep configuration files focused and small
- Use consistent `M.config()` pattern across all config modules
- Group related functionality in appropriate directories

#### Testing and Validation
- Always test Neovim startup after changes
- Check LSP health with `:checkhealth lsp`
- Verify plugin loading with `:Lazy`
- Test keymaps after LSP configuration changes

## Important Notes

- **Clipboard**: System clipboard configured (`unnamedplus`)
- **Encoding**: UTF-8 with Chinese text support
- **File handling**: Backup and swap files disabled
- **Multi-LSP**: Custom handlers prevent duplicate prompts
- **Python**: Anaconda environment path must exist
- **Git**: Integration with gitsigns and fugitive