return {
  "EtiamNullam/deferred-clipboard.nvim",
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      "j-hui/fidget.nvim",

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
  },

  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  },

  { -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    "p00f/nvim-ts-rainbow",
  },

  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- Easy jumping to symbols
  {
    "phaazon/hop.nvim",
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require "hop".setup { keys = "etovxqpdygfblzhckisuran" }
    end
  },

  {
          "chrisgrieser/nvim-recorder",
          config = function() require("recorder").setup() end,
  },

  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "lewis6991/gitsigns.nvim",
  "mtikekar/vim-bsv",

  -- Themes
  "chriskempson/base16-vim",
  -- "navarasu/onedark.nvim" -- Theme inspired by Atom
  "kaicataldo/material.vim",
  { "catppuccin/nvim", name = "catppuccin" },
  "RRethy/nvim-base16",

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true }
  },
  "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
  "numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 },
}
