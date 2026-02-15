vim.g.python3_host_prog = vim.fn.expand("$HOME/anaconda3/bin/python")

vim.g.gui_font = "Droid Sans Mono for Powerline Nerd Font:h13"
vim.opt.guifont = vim.g.gui_font

require('core.init')

vim.api.nvim_create_user_command('CompileRunGcc', function()
    vim.cmd('w')
    local ft = vim.bo.filetype
    local cmd
    if ft == 'c' then
        cmd = '!g++ % -o %< && time ./%<'
    elseif ft == 'cpp' then
        cmd = '!g++ -std=c++17 -g % -o %:r && ./%:r'
    elseif ft == 'java' then
        cmd = '!javac % && time java %<'
    elseif ft == 'sh' then
        cmd = '!time bash %'
    elseif ft == 'python' then
        cmd = '!/Users/henry/anaconda3/bin/python3 %'
    elseif ft == 'html' then
        cmd = '!firefox % &'
    elseif ft == 'go' then
        cmd = '!go run %'
    elseif ft == 'mkd' then
        cmd = '!~/.vim/markdown.pl % > %.html && firefox %.html &'
    else
        vim.notify('No compile/run command for filetype: ' .. ft, vim.log.levels.WARN)
        return
    end
    vim.cmd(cmd)
end, {})

vim.keymap.set('n', '<F5>', ':CompileRunGcc<CR>', { desc = 'Compile and run' })

if vim.fn.has('unix') == 1 then
    vim.opt.thesaurus:append('/usr/share/dict/words')
end
