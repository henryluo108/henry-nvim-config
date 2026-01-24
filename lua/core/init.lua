-- basics
vim.cmd('syntax on')
vim.cmd('filetype plugin indent on')
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.termguicolors  = true
vim.opt.shiftround     = true
vim.opt.updatetime     = 100
vim.opt.cursorline     = true
vim.opt.autowrite      = true
if (vim.fn.has('termguicolors') == 1) then
    vim.opt.termguicolors = true
end
vim.opt.filetype    = "on"
-- tabs
vim.opt.autoindent  = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.expandtab   = true

-- 基础选项（从 init.vim 迁移）
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.mouse = "a"
vim.opt.swapfile = false
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.backspace = "indent,eol,start"
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.cmdheight = 2
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.shortmess = "c"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.smartindent = true
vim.opt.hlsearch = true

-- 编码设置（中文支持）
vim.opt.langmenu = "zh_CN.UTF-8"
vim.opt.fileencodings = "ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1"
vim.opt.fileencoding = "utf-8"
vim.opt.encoding = "utf-8"

-- ESC 清除搜索高亮
vim.keymap.set('n', '<silent> <ESC>', ':nohlsearch<CR>', { silent = true })

vim.g.ale_disable_lsp = 1
vim.g.ale_use_language_server = 0
vim.g.ale_lsp_root = 'none'

-- Disable pylsp (python-lsp-server) to avoid conflicts with pyright
vim.api.nvim_create_augroup('DisablePylsp', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = 'DisablePylsp',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'pylsp' then
      vim.lsp.stop_client(client.id)
    end
  end,
})

-- disable some useless standard plugins to save startup time
-- these features have been better covered by plugins
vim.g.loaded_matchparen        = 1
vim.g.loaded_matchit           = 1
vim.g.loaded_logiPat           = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_shada_plugin      = 1
vim.g.loaded_spellfile_plugin  = 1
vim.g.loaded_netrw             = 1
vim.g.loaded_netrwPlugin       = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins    = 1
vim.g.loaded_perl_provider     = 0
vim.g.loaded_ruby_provider     = 0

-- 插件全局变量配置（从 init.vim 迁移）
vim.g.NERDTreeLimitedSyntax = 1
vim.g.ale_fixers = { cpp = { 'astyle' } }
vim.g.go_def_mapping_enabled = 0
vim.g.rainbow_active = 1

-- Load Lazy.nvim plugin manager
require("configs.lazy").config()

require("core.theme")

vim.g.webdevicons_enable = 1

require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

require("configs.nvim-cmp")
require("configs.statusline").config()
require("configs.treesitter").config()
require("configs.outlinetree").config()
require("configs.bufferline").config()
require("configs.grammar").config()
require("configs.todo-comments").config()

require("configs.lsp").config()

-- Load keymaps after plugins are loaded (so :Black command exists)
require("core.keymaps")

-- Ensure diagnostic signs are visible
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "⚡", texthl = "DiagnosticSignHint" })

-- Auto show diagnostic on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "if_many",
            prefix = " ",
            scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})

vim.api.nvim_set_keymap('n', '<c-P>',
    "<cmd>lua require('fzf-lua').files()<CR>",
    { noremap = true, silent = true })

--require 'colorizer'.setup()
--require 'colorizer'.setup {
    --'python',
    --html = {
        --mode = 'foreground'
    --}
--}
--require("configs.lc").config()
--require("configs.coc-nvim").config()

-- Rainbow 自动命令（从 init.vim 迁移）
local rainbow_group = vim.api.nvim_create_augroup('RainbowHighlight', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = rainbow_group,
  pattern = '*',
  callback = function()
    vim.cmd('hi TSPunctBracket NONE')
    vim.cmd('hi link TSPunctBracket nonexistenthl')
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = rainbow_group,
  pattern = '*.lua',
  callback = function()
    vim.cmd('hi TSConstructor NONE')
    vim.cmd('hi link TSConstructor nonexistenthl')
  end,
})

-- gitgutter
vim.g.gitgutter_preview_win_floating = 1
vim.g.gitgutter_highlight_lines = 1
vim.g.gitgutter_highlight_linenrs = 1

-- NERDTree 自动命令（从 init.vim 迁移）
local nerdtree_group = vim.api.nvim_create_augroup('NERDTreeGroup', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = nerdtree_group,
  callback = function()
    -- Don't open NERDTree in headless mode or when opening a specific file
    if not vim.api.nvim_get_option_value('headless', {}) and vim.fn.argc() == 0 then
      vim.cmd('NERDTree | wincmd p')
    end
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = nerdtree_group,
  callback = function()
    if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 then
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft == 'nerdtree' then
        vim.cmd('quit')
      end
    end
  end,
})

-- Markdown 拼写检查
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.spell = true
  end,
})

-- kawre/leetcode.nvim
