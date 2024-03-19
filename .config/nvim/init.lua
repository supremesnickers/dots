-- Boostrapping lazy.nvim
if vim.g.vscode then
    -- VSCode extension
else
    -- Compile lua to bytecode if the nvim version supports it.
    if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end
    require("config.options")

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

    require("lazy").setup("plugins", {})
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
    require("telescope").load_extension("scope")

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
    require("autocmds")
    require("treesitter")
    require("completion")
    require("lsp")
    require("eviline")
    require("keymaps")
end
