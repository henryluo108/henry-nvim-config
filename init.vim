lua require('core.init')
"let $PYTHONPATH="/Users/henry/anaconda3/envs/tf/bin/python"
let g:python3_host_prog="/Users/henry/anaconda3/bin/python"

set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font:h13
set clipboard^=unnamed,unnamedplus

if has('unix')
	set thesaurus+=/usr/share/dict/words
endif

autocmd FileType markdown setlocal spell

set mouse+=a

set langmenu=zh_CN.UTF-8 " 设置打开文件的编码格式
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
set encoding=utf-8

set noswapfile

set completeopt=menu,menuone,noselect

set backspace=indent,eol,start

set ruler

set hidden

"set clipboard+=unnamed
set clipboard+=unnamedplus

set cmdheight=2

set nobackup
set nowritebackup

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if

" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch
set smartindent

" Highlight the matched text while searching
set hlsearch

let mapleader="\<space>"

" Clear search highlight with ESC key
nnoremap <silent> <ESC> :nohlsearch<CR>

map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		"exec "!g++ % -o %<"
        "exec "!clang % -o %<"
        exec "!g++ -std=c++17 -g % -o %:r && ./%:r"
		"exec "!time ./%<"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		"exec "!clear"
		"exec "!time python3 %"
        exec "!/Users/henry/anaconda3/envs/tf/bin/python %"
        "exec "!/Users/henry.luohr/opt/anaconda3/envs/tf1.15/bin/python %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		" exec "!go build %<"
		exec "!go run %"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl % > %.html &"
		exec "!firefox %.html &"
	endif
endfunc

" =============================== Black ==============================
" Black is managed by lazy.nvim plugin manager
" Configure Black to use the correct Python executable
let g:black_use_virtualenv = 0
let g:black_skip_string_normalization = 1
let g:black_quiet = 1


nnoremap ff :Black<cr>

" NERDTree
augroup Group2
	autocmd!
	" NERDTree setting
	autocmd VimEnter * NERDTree | wincmd p
	" close VIM automatically when NERDTree is the last window
	autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |  quit | endif
augroup END

" Native LSP is now configured through nvim-lspconfig and nvim-cmp

let g:devicons_enable = 1
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1
" test highlight just the glyph (icons) in nerdtree:
"autocmd filetype nerdtree highlight haskell_icon ctermbg=none ctermfg=Red guifg=#ffa500
"autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=Red guifg=#ffa500
"autoccmd filetype nerdtree highlight go_icon ctermbg=none ctermfg=Red guifg=#ffa500

"autocmd filetype nerdtree syn match haskell_icon ## containedin=NERDTreeFlags
" if you are using another syn highlight for a given line (e.g.
" NERDTreeHighlightFile) need to give that name in the 'containedin' for this
" other highlight to work with it
"autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFlags,html
"autocmd filetype nerdtree syn match go_icon ## containedin=NERDTreeFlags

let g:NERDTreeLimitedSyntax = 1


" ================================= ale ================================
let b:ale_fixers = {'cpp': ['astyle']}

" ================================= vim-go ================================
" Disable vim-go's default gd mapping to prevent conflicts with LSP
let g:go_def_mapping_enabled = 0

" ================================= rainbow ================================
let g:rainbow_active = 1
"let g:rainbow_conf = {
"\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
"\	'guis': [''],
"\	'cterms': [''],
"\	'operators': '_,_',
"\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
"\	'separately': {
"\		'*': {},
"\		'markdown': {
"\			'parentheses_options': 'containedin=markdownCode contained', "enable rainbow for code blocks only
"\		},
"\		'lisp': {
"\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'], "lisp needs more colors for parentheses :)
"\		},
"\		'haskell': {
"\			'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/\v\{\ze[^-]/ end=/}/ fold'], "the haskell lang pragmas should be excluded
"\		},
"\		'vim': {
"\			'parentheses_options': 'containedin=vimFuncBody', "enable rainbow inside vim function body
"\		},
"\		'perl': {
"\			'syn_name_prefix': 'perlBlockFoldRainbow', "solve the [perl indent-depending-on-syntax problem](https://github.com/luochen1990/rainbow/issues/20)
"\		},
"\		'stylus': {
"\			'parentheses': ['start=/{/ end=/}/ fold contains=@colorableGroup'], "[vim css color](https://github.com/ap/vim-css-color) compatibility
"\		},
"\		'css': 0, "disable this plugin for css files
"\	}
"\}
"
