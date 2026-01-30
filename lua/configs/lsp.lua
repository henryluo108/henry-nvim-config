------------------------------------------------------------------------
--                                lsp                                 --
------------------------------------------------------------------------
local M = {}
function M.config()
    -- Configure diagnostic display before setting up LSP
    vim.diagnostic.config({
        virtual_text = {
            prefix = "•",
            spacing = 2,
            severity = { min = vim.diagnostic.severity.ERROR },
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "✗",
                [vim.diagnostic.severity.WARN] = "⚠",
                [vim.diagnostic.severity.INFO] = "ℹ",
                [vim.diagnostic.severity.HINT] = "⚡",
            },
        },
        underline = true,
        float = {
            show_header = true,
            source = "if_many",
            border = "rounded",
            focusable = false,
        },
        update_in_insert = false,
        severity_sort = true,
    })

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    -- Add LSP capabilities for nvim-cmp
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    mason.setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
    mason_lspconfig.setup({
        ensure_installed = {
            "lua_ls",
            "bashls",
            "pyright",
            "ruff",
            "jsonls",
            "yamlls",
            "gopls",
            "ts_ls",
        },
        automatic_installation = true,
        automatic_detection = false,  -- Disable auto-detection to prevent pylsp from starting
    })
    

    -- Setup language servers with proper configurations
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Disable capabilities for servers that shouldn't handle certain features
        -- This prevents duplicate definitions from multiple LSP servers
        local filetype = vim.bo[bufnr].filetype

        -- For Python files, only allow pyright to handle definitions and completion
        if filetype == 'python' then
            -- Disable pylsp (python-lsp-server) entirely for Python files
            if client.name == 'pylsp' then
                vim.lsp.disable(client.id)
                return
            end
            if client.name ~= 'pyright' then
                -- Disable all capabilities for non-pyright servers in Python files
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.declarationProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                client.server_capabilities.referencesProvider = false
                client.server_capabilities.completionProvider = false
                client.server_capabilities.codeActionProvider = false
            end
        elseif filetype == 'lua' then
            if client.name ~= 'lua_ls' then
                -- For Lua files, only allow lua_ls to provide definitions
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.declarationProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                client.server_capabilities.referencesProvider = false
            end
        elseif filetype == 'typescript' or filetype == 'javascript' or filetype == 'typescriptreact' or filetype == 'javascriptreact' then
            if client.name ~= 'ts_ls' then
                -- For TS/JS files, only allow ts_ls to provide definitions
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.declarationProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                client.server_capabilities.referencesProvider = false
            end
        elseif filetype == 'go' then
            -- For Go files, ensure only gopls provides definitions (not vim-go and gopls both)
            if client.name ~= 'gopls' then
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.declarationProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                client.server_capabilities.referencesProvider = false
            end
        end

        -- Set up buffer-local keymaps for LSP functionality
        -- NOTE: Avoid setting 'gd' here to prevent duplicate keymaps with the global one
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

        -- Use deduplicated code action from utils module
        vim.keymap.set('n', '<leader>ca', function()
            require('utils.lsp-utils').deduplicated_code_action()
        end, opts)
        -- Do not add 'gd' or 'gD' mappings here to prevent conflicts with global mappings
    end

    -- Setup language servers individually with proper conflict resolution
    local servers = {
        'lua_ls',
        'bashls',
        'pyright',
        'ruff',
        'jsonls',
        'yamlls',
        'gopls',
        'ts_ls'
    }

    for _, server_name in ipairs(servers) do
        local server_config = {
            on_attach = on_attach,
            capabilities = capabilities,
        }

        -- Add server-specific configurations
        if server_name == 'lua_ls' then
            server_config.settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.stdpath('config') .. '/lua'] = true,
                        }
                    }
                }
            }
        elseif server_name == 'pyright' then
            server_config.settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true
                    }
                }
            }
        elseif server_name == 'ts_ls' then
            -- root_dir will be auto-detected by vim.lsp.config
        elseif server_name == 'gopls' then
            server_config.cmd = {"gopls"}
            server_config.settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            }
        elseif server_name == 'ruff' then
            server_config.init_options = {
                settings = {
                    organizeImports = true,
                }
            }
            server_config.single_file_support = true
            server_config.offset_encoding = 'utf-16'
            server_config.capabilities = {
                completionProvider = false,
            }
        end

        vim.lsp.config(server_name, server_config)
        
        -- Auto-start language servers for certain filetypes
        if server_name == 'pyright' then
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"python"},
                callback = function()
                    if not vim.lsp.get_clients({ name = server_name })[1] then
                        vim.lsp.enable(server_name)
                    end
                end,
            })
        elseif server_name == 'lua_ls' then
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"lua"},
                callback = function()
                    if not vim.lsp.get_clients({ name = server_name })[1] then
                        vim.lsp.enable(server_name)
                    end
                end,
            })
        else
            vim.lsp.enable(server_name)
        end
    end
end

return M
