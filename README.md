# Henry's Personal Neovim Configuration

A modern, feature-rich Neovim configuration using **lazy.nvim** as the plugin manager with comprehensive LSP support, multiple language servers, and a carefully curated set of plugins for productive development.

## Architecture

### File Structure
```
~/.config/nvim/
├── init.vim                    # Entry point, Vimscript settings, autocommands
├── lazy-lock.json             # Plugin version pinning
├── lua/
│   ├── core/
│   │   ├── init.lua           # Main Lua entry, basic settings
│   │   ├── keymaps.lua        # All key mappings (deduplicated LSP handlers)
│   │   └── theme.lua          # Colorscheme configuration (kanagawa)
│   ├── configs/
│   │   ├── lsp.lua            # LSP server setup (mason, lspconfig, multi-server)
│   │   ├── nvim-cmp.lua       # Autocompletion configuration
│   │   ├── treesitter.lua     # Treesitter syntax highlighting
│   │   ├── statusline.lua     # lualine configuration
│   │   ├── bufferline.lua     # Buffer tabs
│   │   ├── outlinetree.lua    # Symbols outline
│   │   ├── filetree.lua       # File explorer (nvim-tree)
│   │   ├── git.lua            # Git integration (gitsigns)
│   │   ├── todo-comments.lua  # TODO comment highlighting
│   │   ├── grammar.lua        # Grammar checking
│   │   ├── lazy.lua           # Plugin manager bootstrap
│   │   └── startscreen.lua    # Startup screen (disabled)
│   └── plugins/
│       └── spec.lua           # Plugin specifications for lazy.nvim
└── README.md                  # This file
```

## Quick Start

### Prerequisites
- **Neovim v0.9+** (latest version recommended)
- **Git** (for plugin installation)
- **Ripgrep** (for fuzzy finding and todo-comments)
- **LanguageTool** (for grammar checking, optional)

### Installation
```bash
# Clone configuration
git clone https://github.com/pikachuuu108/henry-nvim-config.git ~/.config/nvim

# Start Neovim - plugins will auto-install
nvim

# Install LSP servers (if not auto-installed)
:LspInstall <server>      # Inside Neovim
# or use Mason UI:
:Mason                    # Open Mason package manager
```

### Environment Setup
```vim
" Python environment (configured in init.vim)
let g:python3_host_prog="/Users/henry/anaconda3/bin/python"

" F5 runner uses conda tf environment for Python:
" /Users/henry/anaconda3/envs/tf/bin/python
```

## Key Features

### 1. **Advanced LSP Configuration**
- **Multi-server support**: Configures multiple LSP servers per language
- **Conflict prevention**: Smart capability disabling to avoid duplicate definitions
- **Deduplicated handlers**: Custom `gd` and code action functions eliminate duplicate prompts
- **Supported LSP servers**:
  - **Python**: pyright (primary), ruff (linting/formatting), pylsp (code actions)
  - **Lua**: lua_ls
  - **TypeScript/JavaScript**: ts_ls
  - **Go**: gopls
  - **Bash**: bashls
  - **JSON**: jsonls
  - **YAML**: yamlls

### 2. **Intelligent Code Actions**
- **Deduplicated code actions**: Aggregates actions from multiple LSP servers
- **Ruff format support**: Special handling for Ruff's resolve-based actions
- **Visual feedback**: Logs which servers provide which actions

### 3. **Plugin Manager**
- **lazy.nvim**: Fast, modern plugin manager with lazy loading
- **Version pinning**: `lazy-lock.json` ensures reproducible setups
- **Startup optimization**: Disabled standard plugins for faster boot

### 4. **UI Components**
- **Status line**: Custom bubbles theme with `lualine.nvim`
- **Buffer tabs**: `bufferline.nvim` with diagnostics indicators
- **File explorer**: `NERDTree` (primary) + `nvim-tree` (configured)
- **Symbols outline**: `symbols-outline.nvim` for code navigation
- **Theme**: `kanagawa.nvim` (configurable: sonokai, tokyodark available)

### 5. **Development Tools**
- **Git integration**: `gitsigns.nvim` + `vim-fugitive` + `vim-gitgutter`
- **TODO comments**: `todo-comments.nvim` with FIX, TODO, HACK, WARN, PERF, NOTE, TEST
- **Grammar checking**: `vim-grammarous` for writing assistance
- **Autopairs**: `nvim-autopairs` for automatic bracket/quote completion
- **Rainbow brackets**: Custom treesitter-based rainbow highlighting
- **Colorizer**: `nvim-colorizer.lua` for hex/rgb color preview

### 6. **Fuzzy Finding**
- **Telescope**: `telescope.nvim` for files, git files, buffers, registers
- **fzf-lua**: `fzf-lua` with UI-select integration for code actions
- **ctrlp**: `ctrlp.vim` as backup

### 7. **Language-Specific Features**
- **Python**: Black formatter, multiple LSP servers, conda environment
- **Go**: vim-go integration (with disabled `gd` to prevent conflicts)
- **JavaScript/TypeScript**: ts_ls with proper root detection
- **Shell**: F5 runner with bash execution
- **C/C++**: F5 runner with g++ and C++17 support

## Key Mappings

### Leader Mappings (Space)
| Category | Prefix | Examples |
|----------|--------|----------|
| **File Operations** | `<leader>c*` | `cw` (save), `cq` (quit), `ce` (edit) |
| **Window Management** | `<leader>w*` | `w2` (split), `w3` (vsplit), `wh/j/k/l` (navigation) |
| **Buffer Management** | `<leader>b*` | `bn` (next), `bp` (prev), `d` (delete) |
| **LSP Operations** | `<leader>l*` | `lk` (hover), `lr` (rename), `la` (code action), `lf` (format) |
| **Git Operations** | `<leader>h*` | `hn` (next hunk), `hb` (blame), `hd` (diff) |
| **Search** | `<leader>s*` | `ss` (search), `sw` (word search) |
| **Terminal** | `<leader>t*` | `tt` (toggle), `tn` (new) |
| **Diagnostics** | `<leader>g*` | `gp` (prev), `gn` (next), `gr` (references) |

### Global Keymaps
| Key | Function | Notes |
|-----|----------|-------|
| **`gd`** | Go to Definition (deduplicated) | Eliminates duplicate prompts from multiple LSP servers |
| **`gD`** | Go to Declaration | |
| **`gi`** | Go to Implementation | |
| **`gt`** | Go to Type Definition | |
| **`gr`** | Go to References | |
| **`K`** | Hover documentation | |
| **`<F2>`** | Terminal toggle (Floaterm) | |
| **`<F3>` / `<C-n>`** | File tree toggle (NERDTree) | |
| **`<F4>`** | Symbols outline | |
| **`<F8>`** | Tagbar toggle | |
| **`<F9>`** | Telescope find files | |
| **`<F10>`** | Telescope git files | |
| **`<F11>`** | Telescope buffers | |
| **`<C-p>`** | Telescope registers | |
| **`<C-P>`** | fzf-lua files | |
| **`ff`** | Black format (Python) | |
| **`t` / `T`** | EasyMotion f/F motions | |
| **`ga`** | EasyAlign | |

### Completion (nvim-cmp)
| Key | Action |
|-----|--------|
| **`<C-n>/<C-p>`** | Navigate suggestions |
| **`<Tab>`** | Confirm/select |
| **`<C-Space>`** | Trigger completion |
| **`<C-e>`** | Close completion |
| **`<C-b>/<C-f>`** | Scroll docs |

### F5 Runner (File Type Specific)
| File Type | Command |
|-----------|---------|
| **Python** | `/Users/henry/anaconda3/envs/tf/bin/python %` |
| **Go** | `go run %` |
| **C/C++** | `g++ -std=c++17 -g % -o %:r && ./%:r` |
| **Shell** | `bash %` |
| **Java** | `javac % && java %<` |
| **HTML** | Open in Firefox |

## Language-Specific Configurations

### Python
- **Primary LSP**: pyright (type checking)
- **Linting/Formatting**: ruff (fast, modern)
- **Code Actions**: pylsp (comprehensive, including auto-imports)
- **Formatter**: Black (`<leader>lf` or `ff`)
- **Python Path**: Anaconda at `/Users/henry/anaconda3/bin/python`
- **Runner**: F5 uses conda tf environment

### Go
- **LSP**: gopls
- **vim-go**: Disabled default `gd` mapping to prevent LSP conflicts
- **Runner**: F5 runs with `go run %`

### JavaScript/TypeScript
- **LSP**: ts_ls
- **Root detection**: package.json, tsconfig.json, jsconfig.json

### Lua
- **LSP**: lua_ls
- **Globals**: `vim` added to diagnostics

### Shell
- **Runner**: F5 executes with `bash %`

## Plugin List (Key Highlights)

### Core
- **lazy.nvim**: Plugin manager
- **impatient.nvim**: Startup optimization
- **nvim-lspconfig**: LSP configuration
- **mason.nvim**: LSP server management

### UI
- **kanagawa.nvim**: Colorscheme
- **lualine.nvim**: Status line
- **bufferline.nvim**: Buffer tabs
- **nvim-web-devicons**: Icons

### LSP & Completion
- **nvim-cmp**: Autocompletion engine
- **cmp-nvim-lsp**: LSP integration
- **LuaSnip**: Snippet engine
- **friendly-snippets**: Snippet collection
- **lspkind.nvim**: Completion icons
- **lsp_signature.nvim**: Function signatures

### Snippets Configuration
- **LuaSnip** is configured with:
  - VSCode format snippets from `friendly-snippets`
  - Custom Lua format snippets from `snippets/lua/python.lua`
  - Auto-expansion enabled
  - History tracking enabled
- **Key mappings**:
  - `<Tab>`: Expand snippet or jump to next placeholder
  - `<S-Tab>`: Jump to previous placeholder
  - `<leader>se`: Manual snippet expand
  - `<leader>sj`: Jump forward
  - `<leader>sk`: Jump backward
  - `<leader>sl`: List choices (for choice nodes)
  - `<leader>sr`: Refresh snippets
  - `<leader>ss`: Open snippets directory
- **Custom Python snippets** in `snippets/lua/python.lua`:
  - `main`: Main function template
  - `cl`: Class with docstring
  - `func`: Function with docstring
  - `ifm`, `if`, `ife`, `ifel`: If statements
  - `for`, `fore`: For loops
  - `while`: While loop
  - `try`, `trye`: Try-except blocks
  - `with`: Context manager
  - `imp`, `from`: Import statements
  - `log`: Logging setup
  - `deco`, `decos`: Decorators
  - `type`, `tvar`, `tfun`: Type hints

### Navigation & Search
- **telescope.nvim**: Fuzzy finder
- **fzf-lua**: Alternative fuzzy finder with UI-select
- **nvim-tree.lua**: File explorer
- **NERDTree**: Classic file tree
- **symbols-outline.nvim**: Code outline
- **tagbar**: Tag browser

### Git
- **gitsigns.nvim**: Git gutter signs
- **vim-fugitive**: Git commands
- **vim-gitgutter**: Git diff markers

### Development Tools
- **nvim-treesitter**: Syntax highlighting
- **nvim-autopairs**: Auto-pair insertion
- **todo-comments.nvim**: TODO comment highlighting
- **vim-grammarous**: Grammar checking
- **black**: Python formatter
- **vim-go**: Go development
- **ale**: Async linting (limited use)

### Motion & Editing
- **vim-easymotion**: Jump to any position
- **vim-easy-align**: Easy alignment
- **nerdcommenter**: Comment management
- **rainbow**: Rainbow brackets

### Terminal & Utilities
- **vim-floaterm**: Floating terminal
- **nvim-notify**: Notification system
- **ctrlp.vim**: Fuzzy finder backup

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

# Clean unused plugins
nvim --headless "+Lazy! clean" +qa
```

### Performance
```vim
:Lazy                       " Check plugin load times
:StartupTime                " Profile startup
```

### Common Issues
- **Multiple definition prompts**: The custom `gd` handler eliminates duplicates
- **Code action duplicates**: Deduplicated code action function aggregates from all servers
- **Python environment**: Ensure conda environments exist

## Customizations

### Theme Options
The configuration supports multiple themes (configured in `lua/core/theme.lua`):
- **kanagawa** (default): Elegant Japanese-inspired theme
- **sonokai**: Vibrant colors
- **tokyodark**: Dark theme

### Disabling Features
Some features can be disabled by commenting out lines in `lua/core/init.lua`:
- Start screen (already disabled)
- Colorizer (already disabled)
- lc (language client, already disabled)

## Development Workflow

### Adding New Language Support
1. Install LSP server: `:LspInstall <server>`
2. Add to `lua/configs/lsp.lua` server list
3. Configure in `on_attach` function if needed
4. Add keymaps if required

### Updating Plugins
```bash
# Update all plugins
nvim --headless "+Lazy! sync" +qa

# Check for updates
nvim --headless "+Lazy! show" +qa
```

## Notes

- **Clipboard**: Configured for system clipboard (`unnamedplus`)
- **Encoding**: UTF-8 with Chinese text support
- **Backup**: Disabled (nobackup, nowritebackup, noswapfile)
- **Multiple LSP Servers**: Handled via capability disabling in `on_attach`
- **Deduplication**: Custom handlers for `gd` and code actions prevent duplicates

## License
MIT