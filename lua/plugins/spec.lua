return {
    -- { "neoclide/coc.nvim",       branch = "release" },
    -- starup time optimise
    { "dstein64/vim-startuptime" },
    { "lewis6991/impatient.nvim" },
    -- buffer
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            'kyazdani42/nvim-web-devicons'
        }
    },
    { "moll/vim-bbye" }, -- for more sensible delete buffer cmd
    -- themes (disabled other themes to optimize startup time)
    { "sainnhe/sonokai" },
    { "tiagovla/tokyodark.nvim" },
    { "rebelot/kanagawa.nvim" },
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/vim-vsnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    -- { "dcampos/cmp-snippy" },
    -- { "dcampos/nvim-snippy" },
    { "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate" },
    { "onsails/lspkind-nvim" },
    { "rafamadriz/friendly-snippets" },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {
            -- cfg options
        },
    },
    { "lewis6991/gitsigns.nvim",      tag = "release" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },

    -- tagbar
    { "simrat39/symbols-outline.nvim" },
    { "voldikss/vim-floaterm" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    { "lukas-reineke/indent-blankline.nvim" },
    { "rhysd/vim-grammarous" },
    { "psf/black",                          branch = "stable" },
    { "fatih/vim-go" },

    -- Converted to Lazy.nvim format
    {
        "preservim/nerdtree"
    },

    {
        "preservim/tagbar",
    },

    {
        "windwp/nvim-autopairs",
    },

    {
        "luochen1990/rainbow",
    },

    {
        "scrooloose/nerdcommenter",
    },

    {
        "junegunn/fzf.vim",
    },

    {
        "junegunn/fzf",
    },

    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        -- or if using mini.icons/mini.nvim
        -- dependencies = { "echasnovski/mini.icons" },
        config = function()
            -- Call setup
            require("fzf-lua").setup({})
            -- Register as ui-select handler
            require("fzf-lua").register_ui_select()
        end
    },

    {
        "tpope/vim-fugitive",
    },

    {
        "norcalli/nvim-colorizer.lua",
    },

    {
        "ryanoasis/vim-devicons",
    },

    {
        "johnstef99/vim-nerdtree-syntax-highlight",
    },

    {
        "easymotion/vim-easymotion",
    },

    {
        "airblade/vim-gitgutter"
    },

    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {}
    },

    {
        "kshenoy/vim-signature",
    },

    {
        "honza/vim-snippets",
    },

    {
        "junegunn/vim-easy-align",
    },

    {
        "nvim-treesitter/playground"
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
    },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        }
    },
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "kawre/leetcode.nvim",
        lazy = true,
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
            "rcarriga/nvim-notify",
            "nvim-tree/nvim-web-devicons"
        }
    },

    {
        "kien/ctrlp.vim",
    },

    {
        'dense-analysis/ale',
        config = function()
            -- Configuration goes here.
            local g = vim.g

            g.ale_ruby_rubocop_auto_correct_all = 1

            g.ale_linters = {
                ruby = { 'rubocop', 'ruby' },
                lua = { 'lua_language_server' }
            }
        end
    }
}
