return {
    { "dstein64/vim-startuptime" },
    { "lewis6991/impatient.nvim" },
    { "kyazdani42/nvim-web-devicons" },
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { "moll/vim-bbye" },
    { "sainnhe/sonokai" },
    { "tiagovla/tokyodark.nvim" },
    { "rebelot/kanagawa.nvim" },
    {
        "preservim/nerdtree"
    },
    { "ryanoasis/vim-devicons" },
    {
        "johnstef99/vim-nerdtree-syntax-highlight",
    },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/nvim-cmp" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "nvim-treesitter/nvim-treesitter", branch = "master", lazy = false, build = ":TSUpdate" },
    { "onsails/lspkind-nvim" },
    { "rafamadriz/friendly-snippets" },
    {
        "ray-x/lsp_signature.nvim",
        event = "InsertEnter",
        opts = {},
    },
    { "lewis6991/gitsigns.nvim", tag = "release" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "kyazdani42/nvim-web-devicons"
        }
    },
    { "simrat39/symbols-outline.nvim" },
    { "voldikss/vim-floaterm" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },
    { "lukas-reineke/indent-blankline.nvim" },
    { "psf/black", branch = "stable" },
    { "fatih/vim-go" },
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
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({})
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
        "junegunn/vim-easy-align",
    },
    {
        "nvim-treesitter/playground"
    },
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
}
