return {
  {
    -- LSP Configuration & Plugins
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

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },

  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end
  },

  "NvChad/nvim-colorizer.lua",

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  },

  { "echasnovski/mini.nvim", version = false },

  {
    "utilyre/sentiment.nvim",
    name = "sentiment",
    version = "*",
    opts = {
      -- config
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update { with_sync = true })
    end,
  },

  "nvim-treesitter/nvim-treesitter-context",

  {
    -- Project management
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  { -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    "p00f/nvim-ts-rainbow",
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        presets = {
          bottom_search = true,
          command_palette = true,
        }
      })
    end,
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      }
  },

  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 400
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
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
    "ggandor/leap.nvim"
  },

  {
    "chrisgrieser/nvim-recorder",
    config = function() require("recorder").setup({}) end,
  },

  -- Git related plugins
  "tpope/vim-fugitive",
  "TimUntersberger/neogit",
  "sindrets/diffview.nvim",
  "tpope/vim-rhubarb",

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
    config = function()
      require("gitsigns").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end
  },

  -- Themes
  -- "chriskempson/base16-vim",
  -- "navarasu/onedark.nvim" -- Theme inspired by Atom
  -- "kaicataldo/material.vim",
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        term_colors = true,
        transparent_background = false,
        no_italic = false,
        no_bold = false,
        styles = {
          comments = {},
          conditionals = {},
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
        },
        color_overrides = {
          mocha = {
            base = "#121212",
            mantle = "#282833",
            crust = "#282833",
          },
        },
        highlight_overrides = {
          mocha = function(C)
            return {
              TabLineSel = { bg = C.pink, fg = C.base },
              CmpBorder = { fg = C.surface2 },
              Pmenu = { bg = C.none },
              TelescopeBorder = { link = "FloatBorder" },
            }
          end,
        },
      }

      vim.cmd.colorscheme "catppuccin"
    end,
  },
  -- "RRethy/nvim-base16",

  -- {
  --     "kylechui/nvim-surround",
  --     version = "*", -- Use for stability; omit to use `main` branch for the latest features
  --     config = function()
  --  require("nvim-surround").setup({
  --      -- Configuration here, or leave empty to use defaults
  --  })
  --     end
  -- },

  "rafcamlet/nvim-luapad",

  -- Run blocks of code as REPL
  { "michaelb/sniprun",      build = "bash ./install.sh" },


  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", opt = true }
  },

  "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines
  -- "numToStr/Comment.nvim", -- "gc" to comment visual regions/lines
  -- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  { "nvim-telescope/telescope.nvim",            branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  "cbochs/portal.nvim",

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make",     cond = vim.fn.executable "make" == 1 },
}
