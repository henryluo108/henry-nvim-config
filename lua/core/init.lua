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

vim.g.ale_disable_lsp = 1
vim.g.ale_use_language_server = 0
vim.g.ale_lsp_root = 'none'

require("core.keymaps")

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

-- Load Lazy.nvim plugin manager
require("configs.lazy").config()

require("core.theme")

vim.g.webdevicons_enable = 1

-- Load plugin configs
require("impatient")

require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})

--require("configs.autocomplete").config()
require("configs.nvim-cmp")
--require("configs.cmp")
--require("configs.git").config()
--require("configs.filetree").config()
require("configs.statusline").config()
require("configs.treesitter").config()
require("configs.outlinetree").config()
require("configs.bufferline").config()
require("configs.grammar").config()
require("configs.todo-comments").config()

require("configs.lsp").config()
--require("configs.startscreen").config()

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

vim.cmd [[augroup rainbow]]
vim.cmd [[	au BufEnter *     hi      TSPunctBracket NONE]]
vim.cmd [[	au BufEnter *     hi link TSPunctBracket nonexistenthl]]
vim.cmd [[	au BufEnter *.lua hi      TSConstructor  NONE]]
vim.cmd [[	au BufEnter *.lua hi link TSConstructor  nonexistenthl]]
vim.cmd [[augroup END]]

-- gitgutter
vim.g.gitgutter_preview_win_floating = 1
vim.g.gitgutter_highlight_lines = 1
vim.g.gitgutter_highlight_linenrs = 1

-- kawre/leetcode.nvim
