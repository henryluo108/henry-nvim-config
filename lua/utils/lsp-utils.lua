------------------------------------------------------------------------
--                              lsp-utils                             --
--         Utility functions for LSP deduplication and handlers       --
------------------------------------------------------------------------

local M = {}

--- Deduplicated code action function
-- Prevents duplicate code actions from multiple LSP servers
function M.deduplicated_code_action()
    local context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }
    local params = vim.lsp.util.make_range_params()
    params.context = context

    local seen_actions = {}
    local unique_actions = {}

    vim.lsp.buf_request_all(0, 'textDocument/codeAction', params, function(results)
        if not results then
            vim.notify('No code action results from any LSP server', vim.log.levels.WARN)
            return
        end

        -- Debug: log which clients responded
        local client_count = 0
        for client_id, result in pairs(results) do
            client_count = client_count + 1
            local client = vim.lsp.get_client_by_id(client_id)
            local client_name = client and client.name or 'unknown'
            if result and result.result then
                vim.notify(string.format('Client %s (%s) provided %d code actions',
                    client_name, client_id, #result.result), vim.log.levels.INFO)
                -- Also log the action titles for debugging
                for i, action in ipairs(result.result) do
                    vim.notify(string.format('  [%d] %s (kind: %s)', i, action.title, action.kind or 'none'), vim.log.levels.INFO)
                end
            else
                vim.notify(string.format('Client %s (%s) returned no code actions',
                    client_name, client_id), vim.log.levels.INFO)
            end
        end

        vim.notify(string.format('Total %d LSP clients responded', client_count), vim.log.levels.INFO)

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
                    vim.notify(string.format('Selected code action: "%s" (kind: %s)',
                        choice.title, choice.kind or 'unknown'), vim.log.levels.INFO)

                    -- Handle different action formats
                    if choice.edit then
                        vim.notify('Applying direct WorkspaceEdit', vim.log.levels.DEBUG)
                        vim.lsp.util.apply_workspace_edit(choice.edit, 'UTF-8')
                    elseif choice.command then
                        vim.notify('Executing command: ' .. (choice.command.command or 'unknown'), vim.log.levels.DEBUG)
                        vim.lsp.buf.execute_command(choice)
                    elseif choice.data then
                        vim.notify('Action requires resolution (likely Ruff format)', vim.log.levels.DEBUG)
                        -- Need to resolve the action first (Ruff format)
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
                                    vim.notify('Applying resolved WorkspaceEdit', vim.log.levels.DEBUG)
                                    vim.lsp.util.apply_workspace_edit(resolved.edit, 'UTF-8')
                                elseif resolved and resolved.command then
                                    vim.notify('Executing resolved command', vim.log.levels.DEBUG)
                                    vim.lsp.buf.execute_command(resolved)
                                else
                                    vim.notify('Resolved action has no edit or command', vim.log.levels.WARN)
                                end
                            end, 0)
                        else
                            vim.notify('Ruff client not found', vim.log.levels.ERROR)
                        end
                    else
                        vim.notify('Unknown action format', vim.log.levels.WARN)
                    end
                else
                    vim.notify('No code action selected', vim.log.levels.DEBUG)
                end
            end)
        else
            vim.notify('No code actions available', vim.log.levels.INFO)
        end
    end)
end

--- Custom 'gd' handler with deduplication
-- Eliminates duplicate definition prompts from multiple LSP servers
function M.go_to_definition_deduplicated()
    -- Use the built-in make_position_params but without the second parameter that caused the error
    local params = vim.lsp.util.make_position_params()
    
    -- Table to store unique definition locations
    local unique_locations = {}
    local unique_results = {}
    
    -- Send the request to all attached LSP servers
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err then
            vim.api.nvim_err_writeln("LSP Error: " .. tostring(err))
            return
        end

        if not result or vim.tbl_isempty(result) then
            vim.api.nvim_echo({{'No definition found', 'WarningMsg'}}, false, {})
            return
        end

        -- Normalize result to table format if needed
        if type(result) == 'table' and result[1] == nil and (result.uri or result.targetUri) then
            result = {result}
        end

        if type(result) == 'table' then
            for _, location in ipairs(result) do
                if location then
                    -- Get URI and range for this location
                    local uri = location.uri or location.targetUri
                    local range = location.range or location.targetRange
                    
                    if uri and range then
                        -- Create a unique key based on URI and position
                        local position_key = uri .. "#" .. 
                            range.start.line .. "," .. 
                            range.start.character
                        
                        -- Only add this location if we haven't seen it before
                        if not unique_locations[position_key] then
                            unique_locations[position_key] = true
                            table.insert(unique_results, location)
                        end
                    end
                end
            end
        end

        -- Now handle the unique results
        if #unique_results == 0 then
            vim.api.nvim_echo({{'No definition found', 'WarningMsg'}}, false, {})
        elseif #unique_results == 1 then
            -- Jump directly to the single unique result
            local location = unique_results[1]
            local uri = location.uri or location.targetUri
            local range = location.range or location.targetRange
            if uri and range then
                local bufnr = vim.uri_to_bufnr(uri)
                -- Load the buffer if it's not already loaded
                if not vim.api.nvim_buf_is_loaded(bufnr) then
                    vim.fn.bufload(bufnr)
                end
                vim.api.nvim_win_set_buf(0, bufnr)
                local line = range.start.line + 1
                local col = range.start.character + 1
                vim.api.nvim_win_set_cursor(0, {line, col})
            end
        else
            -- Show selection for multiple unique results
            vim.lsp.handlers['textDocument/definition'](nil, unique_results, ctx)
        end
    end)
end

return M
