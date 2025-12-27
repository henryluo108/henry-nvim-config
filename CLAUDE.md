# CLAUDE.md

## Overview

This is a personal Neovim configuration using **lazy.nvim** as the plugin manager. The configuration is split between traditional Vimscript (`init.vim`) and Lua (`lua/` directory) with a modular architecture.

## Architecture

### File Structure
```
~/.config/nvim/
├── init.vim                    # Entry point, Vimscript settings, autocommands
├── lazy-lock.json             # Plugin version pinning
├── lua/
│   ├── core/
│   │   ├── init.lua           # Main Lua entry, loads all configs
│   │   ├── keymaps.lua        # All key mappings
│   │   └── theme.lua          # Colorscheme configuration
│   ├── configs/
│   │   ├── lsp.lua            # LSP server setup (mason, lspconfig)
│   │   ├── nvim-cmp.lua       # Autocompletion configuration
│   │   ├── treesitter.lua     # Treesitter syntax highlighting
│   │   ├── statusline.lua     # lualine configuration
│   │   ├── bufferline.lua     # Buffer tabs
│   │   ├── outlinetree.lua    # Symbols outline
│   │   ├── filetree.lua       # File explorer (nvim-tree)
│   │   ├── git.lua            # Git integration
│   │   ├── todo-comments.lua  # TODO comment highlighting
│   │   ├── grammar.lua        # Grammar checking
│   │   ├── lazy.lua           # Plugin manager bootstrap
│   │   └── lc.lua             # Language client (unused)
│   └── plugins/
│       └── spec.lua           # Plugin specifications for lazy.nvim
└── README.md                  # User documentation
```

### Key Design Decisions
1. **Dual Entry Point**: `init.vim` loads `lua/core/init.lua`
2. **Lazy Loading**: Uses lazy.nvim for plugin management with `lazy-lock.json` for version pinning
3. **LSP-First**: Native LSP via nvim-lspconfig + mason for server management
4. **Conflict Prevention**: Custom `gd` mapping with deduplication to handle multiple LSP servers
5. **Language-Specific LSP**: Configures specific LSP servers per filetype to prevent conflicts

## Common Development Tasks

### Plugin Management
```bash
# Install/update plugins
nvim --headless "+Lazy! sync" +qa

# Check plugin status
nvim --headless "+Lazy! show" +qa

# Clean unused plugins
nvim --headless "+Lazy! clean" +qa
```

### LSP Management
```vim
" Inside Neovim:
:LspInstall <server>      " Install LSP server
:LspInfo                  " Check LSP status
:Mason                    " Open Mason UI
```

### Treesitter Management
```vim
:TSInstall <language>     " Install parser
:TSUpdate                 " Update all parsers
:TSPlaygroundToggle       " Open syntax playground
```

### Testing Configuration
```bash
# Test Neovim config
nvim --clean -c "lua require('core.init')"

# Check for errors
nvim --headless "+checkhealth" +qa
```

## Key Mapping Categories

### Leader Mappings (Space)
- **File Operations**: `<leader>c*` (save, quit, edit)
- **Window Management**: `<leader>w*` (splits, resize)
- **Buffer Managemenp**: `<leader>b*` (navigation, delete)
- **LSP Operations**: `<leader>l*` (hover, rename, format, code actions)
- **Git Operations**: `<leader>h*` (hunks, blame, diff)
- **Search**: `<leader>s*` (search, grep)
- **Terminal**: `<leader>t*` (floaterm)

### LSP Keymaps
- **Global**: `gd` (deduplicated definition), `gD` (declaration), `gr` (references), `gt` (type definition), `gi` (implementation)
- **Leader**: `<leader>lr` (rename), `<leader>lk` (hover), `<leader>la` (code action), `<leader>lf` (format)

### Navigation
- **F-keys**:
  - `<F2>`: Terminal toggle
  - `<F3>`/`<C-n>`: File tree
  - `<F4>`: Symbols outline
  - `<F8>`: Tagbar
  - `<F9-F11>`: Telescope (files, git files, buffers)
- **EasyMotion**: `t`/`T` for f/F motions
- **Align**: `ga` for easy-align

### Completion (nvim-cmp)
- `<C-n>/<C-p>`: Navigate suggestions
- `<Tab>`: Confirm/select 
- `<C-Space>`: Trigger completion
- `<C-e>`: Close completion
- `<C-b>/<C-f>`: Scroll docs

## Language-Specific Configurations

### Python
- **LSP**: pyright
- **Formatter**: Black (`<leader>lf` or `ff`)
- **Python Path**: Uses Anaconda at `/Users/henry/anaconda3/bin/python`
- **Runner**: F5 uses conda tf environment

### Go
- **LSP**: gopls
- **vim-go**: Disabled default `gd` mapping (`g:go_def_mapping_enabled = 0`)
- **Runner**: F5 runs with `go run %`

### JavaScript/TypeScript
- **LSP**: ts_ls
- **Root detection**: package.json, tsconfig.json, jsconfig.json

### Lua
- **LSP**: lua_ls
- **Globals**: `vim` added to diagnostics

### Shell
- **Runner**: F5 executes with `bash %`

## Troubleshooting

### LSP Issues
```vim
:LspInfo                    " Check server status
:Mason                      " Verify installed servers
:checkhealth lsp           " LSP health check
```

### Plugin Issues
```bash
# Check lazy.nvim logs
nvim ~/.local/share/nvim/lazy/lazy.nvim/log
```

### Performance
```vim
:Lazy                       " Check plugin load times
:StartupTime                " Profile startup
```

## Important Notes

1. **Multiple LSP Servers**: The config handles multiple LSP servers per filetype by disabling capabilities for non-primary servers in `on_attach`
2. **Python Environment**: Uses Anaconda - ensure environment exists
3. **Clipboard**: Configured for system clipboard (`unnamedplus`)
4. **File Encoding**: UTF-8 with fallbacks for Chinese text
5. **Backup**: Disabled (nobackup, nowritebackup, noswapfile)

## Customizations

- **Theme**: Uses kanagawa/tokyodark/sonokai (configurable in `core/theme.lua`)
- **Rainbow Brackets**: Enabled via treesitter + custom highlighting
- **Git Integration**: gitsigns + vim-fugitive + vim-gitgutter
- **Terminal**: Floaterm for floating terminal windows
- **Grammar**: vim-grammarous for writing assistance
