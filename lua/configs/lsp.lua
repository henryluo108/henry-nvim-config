------------------------------------------------------------------------
--                                lsp                                 --
------------------------------------------------------------------------
local M = {}
function M.config()
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
            "pylsp",
            "jsonls",
            "yamlls",
            "gopls",
            "ts_ls",
        },
        automatic_installation = true
    })
    

    -- Setup language servers with proper configurations
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Disable capabilities for servers that shouldn't handle certain features
        -- This prevents duplicate definitions from multiple LSP servers
        local filetype = vim.bo[bufnr].filetype

        -- For Python files, only allow pyright to handle definitions
        if filetype == 'python' then
            if client.name ~= 'pyright' then
                -- Disable definition capabilities for all servers except pyright in Python files
                client.server_capabilities.definitionProvider = false
                client.server_capabilities.declarationProvider = false
                client.server_capabilities.implementationProvider = false
                client.server_capabilities.typeDefinitionProvider = false
                client.server_capabilities.referencesProvider = false
            end
            -- Allow multiple LSP servers to handle code actions for Python files
            -- Ruff handles import organization and linting fixes
            -- Pyright handles type checking
            -- Pylsp provides comprehensive code actions including adding missing imports
            if client.name ~= 'ruff' and client.name ~= 'pyright' and client.name ~= 'pylsp' then
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

        -- Use the global deduplicated code action function for all file types
        vim.keymap.set('n', '<leader>ca', function()
            -- Use the deduplicated code action function from keymaps.lua
            local success, keymaps_module = pcall(require, 'core.keymaps')
            if success and keymaps_module.deduplicated_code_action then
                keymaps_module.deduplicated_code_action()
            else
                -- Fallback to default code action
                vim.lsp.buf.code_action()
            end
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
        elseif server_name == 'pylsp' then
            server_config.settings = {
                pylsp = {
                    plugins = {
                        -- 启用自动导入
                        jedi_completion = {
                            enabled = true,
                        },
                        -- 禁用所有 linting/formatting 插件，使用 Ruff 替代
                        autopep8 = {
                            enabled = false,
                        },
                        flake8 = {
                            enabled = false,
                        },
                        pycodestyle = {
                            enabled = false,
                        },
                        pydocstyle = {
                            enabled = false,
                        },
                        pylint = {
                            enabled = false,
                        },
                        pyflakes = {
                            enabled = false,  -- 禁用 pyflakes 以避免兼容性问题
                        },
                        mccabe = {
                            enabled = false,
                        },
                        -- 启用 rope 以获得更好的重构功能
                        rope_completion = {
                            enabled = true,
                        },
                        rope_autoimport = {
                            enabled = true,  -- 自动导入
                            memory = true,
                        },
                        yapf = {
                            enabled = false,
                        },
                        -- 启用其他有用的插件
                        jedi_definition = {
                            enabled = true,
                        },
                        jedi_hover = {
                            enabled = true,
                        },
                        jedi_references = {
                            enabled = true,
                        },
                        jedi_signature_help = {
                            enabled = true,
                        },
                        jedi_symbols = {
                            enabled = true,
                        },
                    }
                }
            }
        end

        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
    end

    -- Ruff is already handled in the main loop with proper capability restrictions
    -- The main server loop already includes 'ruff' and handles capability disabling in the on_attach function
    -- No need for a separate ruff setup as it would duplicate the server connection
end

return M
