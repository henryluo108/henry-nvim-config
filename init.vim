" 必须在 Lua 加载前设置 Python 路径
let g:python3_host_prog="/Users/henry/anaconda3/bin/python"

" GUI 字体设置（仅对 GUI 版本有效）
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font:h13

" 加载 Lua 配置
lua require('core.init')

" F5 编译运行功能（保留在 Vimscript 中便于维护）
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		exec "!g++ -std=c++17 -g % -o %:r && ./%:r"
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		exec "!/Users/henry/anaconda3/envs/tf/bin/python %"
	elseif &filetype == 'html'
		exec "!firefox % &"
	elseif &filetype == 'go'
		exec "!go run %"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl % > %.html &"
		exec "!firefox %.html &"
	endif
endfunc

" 系统词典（Unix 系统）
if has('unix')
	set thesaurus+=/usr/share/dict/words
endif