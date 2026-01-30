local M = {}

function M.config()
    -- Grammarous configuration (Vimscript plugin)
    vim.g["grammarous#languagetool_cmd"] = "languagetool"
    vim.g["grammarous#disabled_rules"] = {
        ["*"] = {
            "WHITESPACE_RULE", "EN_QUOTES", "ARROWS", "SENTENCE_WHITESPACE",
            "WORD_CONTAINS_UNDERSCORE", "COMMA_PARENTHESIS_WHITESPACE",
            "EN_UNPAIRED_BRACKETS", "UPPERCASE_SENTENCE_START",
            "ENGLISH_WORD_REPEAT_BEGINNING_RULE", "DASH_RULE", "PLUS_MINUS",
            "PUNCTUATION_PARAGRAPH_END", "MULTIPLICATION_SIGN", "PRP_CHECKOUT",
            "CAN_CHECKOUT", "SOME_OF_THE", "DOUBLE_PUNCTUATION", "HELL",
            "CURRENCY", "POSSESSIVE_APOSTROPHE", "ENGLISH_WORD_REPEAT_RULE",
            "NON_STANDARD_WORD",
        },
    }

    -- Keymaps for grammarous (using vim.cmd for <Plug> mappings)
    vim.keymap.set("n", "<leader>ec", "<cmd>GrammarousCheck<cr>")
    vim.keymap.set("n", "<leader>eR", "<cmd>GrammarousReset<cr>")

    -- <Plug> mappings need to be set via vim.cmd
    vim.cmd([[
        nmap <leader>er <Plug>(grammarous-reset)
        nmap <leader>eo <Plug>(grammarous-open-info-window)
        nmap <leader>ex <Plug>(grammarous-close-info-window)
        nmap <leader>ef <Plug>(grammarous-fixit)
        nmap <leader>en <Plug>(grammarous-move-to-next-error)
        nmap <leader>ep <Plug>(grammarous-move-to-previous-error)
    ]])
end

return M
