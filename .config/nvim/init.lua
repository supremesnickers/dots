-- Boostrapping lazy.nvim
if vim.g.vscode then
    -- VSCode extension
else
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    -- this needs to be set early
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    require("lazy").setup("plugins", {})
    require("config.options")
    require('conform').setup {}
    require("neogit").setup {}
    require("ibl").setup {}
    require("gitsigns").setup()

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    local actions = require("telescope.actions")
    require("telescope").setup {
        defaults = {
            mappings = {
                i = {
                    ["<C-u>"] = false,
                    ["<C-d>"] = false,
                    ["<esc>"] = actions.close,
                },
            },
        },
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown {
                    -- even more opts
                }
            }
        }
    }
    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
    require("telescope").load_extension("ui-select")
    require("telescope").load_extension("projects")

    -- settings up autocmds
    -- [[ Highlight on yank ]]
    local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = "*",
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
            require("conform").format({ bufnr = args.buf })
        end,
    })

    -- Set names for the prefixes in the which key menu
    -- should be descriptive enough
    local wk = require("which-key")
    wk.register({
        ["<leader>f"] = { name = "+file" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>t"] = { name = "+toggle" },
    })

    -- Setup neovim lua configuration
    require("neodev").setup()

    -- nvim-cmp supports additional completion capabilities
    -- Turn on lsp status information
    require("fidget").setup {}

    require("overseer").setup()
    require("cmake-tools").setup({})

    -- source the rest of the configuration
    require("treesitter")
    require("completion")
    require("lsp")
    require("eviline")
    require("keymaps")
end
