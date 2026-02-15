------------------------------------------------------------------------
--                              lsp-utils                             --
--         Utility functions for LSP deduplication and handlers       --
------------------------------------------------------------------------

local M = {}

function M.deduplicated_code_action()
    local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    local params = vim.lsp.util.make_range_params()
    params.context = context

    local seen_actions = {}
    local unique_actions = {}

    vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, function(results)
        if not results then
            return
        end

        for client_id, result in pairs(results) do
            if result and result.result then
                for _, action in ipairs(result.result) do
                    local key = action.title .. (action.kind or '')
                    if not seen_actions[key] then
                        seen_actions[key] = true
                        table.insert(unique_actions, action)
                    end
                end
            end
        end

        if #unique_actions > 0 then
            vim.ui.select(unique_actions, {
                prompt = 'Code Actions:',
                format_item = function(item)
                    return item.title
                end
            }, function(choice)
                if choice then
                    if choice.edit then
                        vim.lsp.util.apply_workspace_edit(choice.edit, 'UTF-8')
                    elseif choice.command then
                        vim.lsp.buf.execute_command(choice)
                    elseif choice.data then
                        local clients = vim.lsp.get_active_clients()
                        local ruff_client = nil
                        for _, client in ipairs(clients) do
                            if client.name == "ruff" or client.name == "ruff_lsp" then
                                ruff_client = client
                                break
                            end
                        end

                        if ruff_client then
                            ruff_client.request('codeAction/resolve', choice, function(err, resolved)
                                if err then
                                    vim.notify('Failed to resolve code action: ' .. tostring(err), vim.log.levels.ERROR)
                                    return
                                end

                                if resolved and resolved.edit then
                                    vim.lsp.util.apply_workspace_edit(resolved.edit, 'UTF-8')
                                elseif resolved and resolved.command then
                                    vim.lsp.buf.execute_command(resolved)
                                end
                            end, 0)
                        end
                    end
                end
            end)
        end
    end)
end

function M.go_to_definition_deduplicated()
    local params = vim.lsp.util.make_position_params()
    
    local unique_locations = {}
    local unique_results = {}
    
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err then
            vim.api.nvim_err_writeln("LSP Error: " .. tostring(err))
            return
        end

        if not result or vim.tbl_isempty(result) then
            vim.api.nvim_echo({{'No definition found', 'WarningMsg'}}, false, {})
            return
        end

        if type(result) == 'table' and result[1] == nil and (result.uri or result.targetUri) then
            result = {result}
        end

        if type(result) == 'table' then
            for _, location in ipairs(result) do
                if location then
                    local uri = location.uri or location.targetUri
                    local range = location.range or location.targetRange
                    
                    if uri and range then
                        local position_key = uri .. "#" .. 
                            range.start.line .. "," .. 
                            range.start.character
                        
                        if not unique_locations[position_key] then
                            unique_locations[position_key] = true
                            table.insert(unique_results, location)
                        end
                    end
                end
            end
        end

        if #unique_results == 0 then
            vim.api.nvim_echo({{'No definition found', 'WarningMsg'}}, false, {})
        elseif #unique_results == 1 then
            local location = unique_results[1]
            local uri = location.uri or location.targetUri
            local range = location.range or location.targetRange
            if uri and range then
                local bufnr = vim.uri_to_bufnr(uri)
                if not vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.fn.bufload(bufnr)
                end
                vim.api.nvim_win_set_buf(0, bufnr)
                local line = range.start.line + 1
                local col = range.start.character + 1
                vim.api.nvim_win_set_cursor(0, {line, col})
            end
        else
            vim.lsp.handlers['textDocument/definition'](nil, unique_results, ctx)
        end
    end)
end

return M
