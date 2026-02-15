return {
    
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    {
        "preservim/nerdtree",
        cmd = { "NERDTree", "NERDTreeToggle", "NERDTreeFind" },
        keys = {
            { "<F3>", ":NERDTreeToggle<cr>", desc = "Toggle NERDTree" },
            { "<C-n>", ":NERDTreeToggle<cr>", desc = "Toggle NERDTree" },
        },
    },
    {
        "johnstef99/vim-nerdtree-syntax-highlight",
        lazy = true,
        event = "FileType nerdtree",
    },
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { "moll/vim-bbye", cmd = "Bdelete" },
    { "sainnhe/sonokai", lazy = false, priority = 1000 },
    { "tiagovla/tokyodark.nvim", lazy = false, priority = 1000 },
    { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
    { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
    { "hrsh7th/cmp-buffer", event = "InsertEnter" },
    { "hrsh7th/cmp-path", event = "InsertEnter" },
    { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" },
    { "hrsh7th/nvim-cmp", event = "InsertEnter" },
    { "saadparwaiz1/cmp_luasnip", event = "InsertEnter" },
    { "L3MON4D3/LuaSnip", event = "InsertEnter" },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate", priority = 100 },
    { "onsails/lspkind-nvim", event = "LspAttach" },
    { "rafamadriz/friendly-snippets", event = "InsertEnter" },
    {
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
        opts = {},
    },
    { "lewis6991/gitsigns.nvim", tag = "release", event = { "BufReadPre", "BufNewFile" } },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { "simrat39/symbols-outline.nvim", cmd = "SymbolsOutline" },
    { "voldikss/vim-floaterm", cmd = "FloatermNew" },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<F9>", function() require'telescope.builtin'.find_files{} end, desc = "Find files" },
            { "<F10>", function() require'telescope.builtin'.git_files{} end, desc = "Git files" },
            { "<F11>", function() require'telescope.builtin'.buffers{} end, desc = "Buffers" },
            { "<C-p>", function() require'telescope.builtin'.registers{} end, mode = { "n", "i" }, desc = "Registers" },
        },
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    { "lukas-reineke/indent-blankline.nvim", event = "VeryLazy" },
    {
        "psf/black",
        branch = "stable",
        ft = "python",
        config = function()
            vim.g.black_use_virtualenv = 0
            vim.g.black_skip_string_normalization = 1
            vim.g.black_quiet = 1
        end,
        keys = {
            { "ff", ":Black<cr>", desc = "Format with Black", mode = "n" }
        }
    },
    { "fatih/vim-go", ft = "go" },
    { "preservim/tagbar", cmd = "TagbarToggle" },
    { "windwp/nvim-autopairs", event = "InsertEnter" },
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = "VeryLazy",
        config = function()
            local rainbow_delimiters = require('rainbow-delimiters')
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rainbow_delimiters.strategy['global'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    lua = 'rainbow-blocks',
                },
            }
        end
    },
    { "scrooloose/nerdcommenter", event = "VeryLazy" },
    {
        "ibhagwan/fzf-lua",
        event = "VeryLazy",
        keys = {
            { "<C-P>", function() require('fzf-lua').files() end, desc = "Fzf files" },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({})
            require("fzf-lua").register_ui_select()
        end
    },
    { "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gvdiffsplit" } },
    { "norcalli/nvim-colorizer.lua", cmd = "ColorizerToggle", ft = { "css", "html", "javascript", "typescript" } },
    { "easymotion/vim-easymotion", event = "VeryLazy" },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {}
    },
    { "junegunn/vim-easy-align", event = "VeryLazy" },
    { "neovim/nvim-lspconfig", event = { "BufReadPre", "BufNewFile" } },
    {
        "mason-org/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
        dependencies = {
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
            "neovim/nvim-lspconfig",
        }
    },
    { "kyazdani42/nvim-web-devicons", lazy = true },
    { "ryanoasis/vim-devicons", lazy = true },
    {
        "aikhe/wrapped.nvim",
        dependencies = { "nvzone/volt", "nvim-lua/plenary.nvim" },
        cmd = { "NvimWrapped" },
        opts = {},
    },
}
