return {
    {
        -- LSP Configuration & Plugins
        "neovim/nvim-lspconfig",
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP
            "j-hui/fidget.nvim",

            -- Additional lua configuration, makes nvim stuff amazing
            "folke/neodev.nvim",
        },
    },

    { -- Autoformat
        'stevearc/conform.nvim',
        opts = {
            notify_on_error = false,
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                lua = { 'stylua' },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                --
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                -- javascript = { { "prettierd", "prettier" } },
            },
        },
        config = function()
            require('conform').setup()
        end,
    },

    {
        "folke/todo-comments.nvim",
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
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

    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            -- Enables colorization of hex color strings
            require("colorizer").setup {
                user_default_options = {
                    names = false
                }
            }
        end
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", opt = true }
    },

    {
        -- Autocompletion
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    },

    {
        "echasnovski/mini.nvim",
        config = function()
            -- Enable mini.nvim modules
            require("mini.comment").setup()
            require("mini.align").setup()
            require("mini.bracketed").setup()
            -- require("mini.animate").setup()
            require("mini.ai").setup { n_lines = 500 }
            require("mini.surround").setup()
            require("mini.files").setup()
            require("mini.pairs").setup()
            require("mini.basics").setup({
                options = {
                    -- extra_ui = true
                }
            })
            require("mini.move").setup()
            require("mini.cursorword").setup()
            -- require("mini.jump2d").setup({
            --   labels = "tnhesoaigybjwfrudpqcvmkxlxz",
            --   allowed_windows = { not_current = false },
            --   mappings = {
            --     start_jumping = "gss"
            --   }
            -- })

            -- Mini.Jump2d keybindings inspired by Doom Emacs
            -- local jump_opts = MiniJump2d.builtin_opts;
            -- local jump_word = jump_opts.word_start
            -- vim.keymap.set({ "n", "v" }, "gsf", function()
            --   MiniJump2d.start({
            --     spotter = jump_word.spotter,
            --     allowed_lines = { cursor_before = false, cursor_after = true },
            --   })
            -- end, { desc = "Jump to word after" })
            --
            -- vim.keymap.set({ "n", "v" }, "gsb", function()
            --   MiniJump2d.start({
            --     spotter = jump_word.spotter,
            --     allowed_lines = { cursor_before = true, cursor_after = false },
            --   })
            -- end, { desc = "Jump to word before" })

            -- local jump_lines = jump_opts.line_start
            -- vim.keymap.set({ "n", "v" }, "gs)", function()
            --   MiniJump2d.start({
            --     spotter = jump_lines.spotter,
            --     allowed_lines = { cursor_before = false, cursor_after = true },
            --   })
            -- end, { desc = "Jump to lines after" })
            --
            -- vim.keymap.set({ "n", "v" }, "gs(", function()
            --   MiniJump2d.start({
            --     spotter = jump_lines.spotter,
            --     allowed_lines = { cursor_before = true, cursor_after = false },
            --   })
            -- end, { desc = "Jump to lines before" })
        end,
    },

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
        opts = {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = { "c", "cpp", "lua", "python", "rust", "typescript" },

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection    = "<c-=>",
                    node_incremental  = "<c-=>",
                    scope_incremental = "<c-s>",
                    node_decremental  = "<c-_>",
                },
            },
            rainbow = {
                enable = true,
                -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                extended_mode = true,   -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                max_file_lines = 10000, -- Do not enable for files with more than n lines, int
                -- colors = {}, -- table of hex strings
                -- termcolors = {} -- table of colour name strings
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>sa"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>sA"] = "@parameter.inner",
                    },
                },
            },
        },
        build = function()
            pcall(require("nvim-treesitter.install").update { with_sync = true })
        end,
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
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

    'Civitasv/cmake-tools.nvim',

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

    -- {
    --   "folke/noice.nvim",
    --   config = function()
    --     require("noice").setup({
    --       presets = {
    --         bottom_search = true,
    --         command_palette = true,
    --       }
    --     })
    --   end,
    --   dependencies = {
    --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --     "MunifTanjim/nui.nvim",
    --     }
    -- },
    --
    {
        "folke/which-key.nvim",
        event = 'VimEnter',
    },
    -- Easy jumping to symbols
    {
        "smoka7/hop.nvim",
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
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

    {
        "TimUntersberger/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed, not both.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
        },
        config = true,
    },

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

    "rafcamlet/nvim-luapad",

    "lukas-reineke/indent-blankline.nvim", -- Add indentation guides even on blank lines

    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { 'nvim-telescope/telescope-ui-select.nvim' }
        },
    },
    {
        "tiagovla/scope.nvim",
        config = function()
            require("scope").setup({})
        end
    },
    "cbochs/portal.nvim",

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable "make" == 1 },

    {
        'stevearc/overseer.nvim',
        opts = {},
    },

    {
        "zbirenbaum/copilot.lua",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end
    },

    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end
    },


}
