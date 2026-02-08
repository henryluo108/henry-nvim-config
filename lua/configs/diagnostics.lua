local M = {}

function M.config()
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
end

return M
