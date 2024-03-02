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

-- ordinary Neovim
local opts = {
    ui = {
        icons = {
            cmd     = "⌘",
            config  = "🛠",
            event   = "📅",
            ft      = "📂",
            init    = "⚙",
            keys    = "🗝",
            plugin  = "🔌",
            runtime = "💻",
            source  = "📄",
            start   = "🚀",
            task    = "📌",
        },
    },
}

require("lazy").setup("plugins", {})

-- require("leap")

require("config.options")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Set lualine as statusline
-- See `:help lualine.txt`
-- require("lualine").setup {
--   options = {
--     icons_enabled = true,
--     theme = "catppuccin",
--     component_separators = "|",
--     section_separators = "",
--   },
--   sections = {
--     lualine_y = {
--       { require("recorder").displaySlots },
--     },
--     lualine_z = {
--       { require("recorder").recordingStatus },
--     },
--   },
--   inactive_sections = {
--     lualine_x = { "encoding", "fileformat" },
--   }
-- }

require("eviline")

-- Enable mini.nvim modules
require("mini.comment").setup()
require("mini.align").setup()
require("mini.bracketed").setup()
-- require("mini.animate").setup()
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

-- vim.keymap.set("n", "<leader>sG", require("telescope.builtin").git_files, { desc = "[S]earch [G]it files" })

-- hop.nvim config
local hop = require("hop")
local directions = require("hop.hint").HintDirection

vim.keymap.set({ "n", "v" }, "gss", hop.hint_char2, { remap = true, desc = "Hop 2 characters" })

vim.keymap.set({ "n", "v" }, "gs(", function()
    hop.hint_lines({ direction = directions.BEFORE_CURSOR })
end, { remap = true, desc = "Hop lines backwards" })

vim.keymap.set({ "n", "v" }, "gs)", function()
    hop.hint_lines({ direction = directions.AFTER_CURSOR })
end, { remap = true, desc = "Hop lines forwards" })

-- Enable Comment.nvim
-- require("Comment").setup()

local neogit = require("neogit")
neogit.setup {}

vim.keymap.set("n", "<leader>gg", neogit.open, { desc = "Open Neogit" })

-- Enables colorization of hex color strings
require("colorizer").setup {
    user_default_options = {
        names = false
    }
}

-- Enable `lukas-reineke/indent-blankline.nvim`
require("ibl").setup {}

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup()

local actions = require("telescope.actions")

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
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
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

require("telescope").load_extension("projects")

vim.keymap.set("n", "<leader>pr", require "telescope".extensions.projects.projects, { desc = "Open recent project" })

local t_builtin = require("telescope.builtin")
local t_utils = require("telescope.utils")
local t_simple_dropdown = require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
}

-- Main keybinding section

-- Set names for the prefixes in the which key menu
-- should be descriptive enough
local wk = require("which-key")
wk.register({
    ["<leader>f"] = { name = "+file" },
    ["<leader>s"] = { name = "+search" },
    ["<leader>b"] = { name = "+buffer" },
    ["<leader>t"] = { name = "+toggle" },
})

-- See `:help telescope.builtin`
-- Setting keymaps
vim.keymap.set("n", "<leader>bb", function()
    t_builtin.buffers(t_simple_dropdown)
end, { desc = "Switch between [b]uffers" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    t_builtin.current_buffer_fuzzy_find(t_simple_dropdown)
end, { desc = "[/] Fuzzily search in current buffer]" })

vim.keymap.set("n", "<leader><leader>", t_builtin.find_files, { desc = "[F]ind [F]iles" })

vim.keymap.set("n", "<leader>fd", function()
    t_builtin.find_files({
        cwd = t_utils.buffer_dir(),
    })
end, { desc = "[F]ind in current [d]irectory"})
vim.keymap.set("n", "<leader>ff", t_builtin.find_files,       { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fr", t_builtin.oldfiles, { desc = "Find [r]ecently opened files" })
vim.keymap.set("n", "<leader>fc", function()
    t_builtin.find_files(require("telescope.themes").get_dropdown {
        previewer = false,
        cwd = "~/.config/nvim/",
        no_ignore = true,
        prompt_title = "Find Neovim config files"
    })
end, { desc = "[F]ind in [c]onfig" })
vim.keymap.set("n", "<leader>fF", "<cmd>:Format<cr>", { desc = "Format file" })

vim.keymap.set("n", "<leader>sh", t_builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", t_builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>ss", t_builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", t_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sG", t_builtin.git_files, { desc = "[S]earch [G]it files" })

vim.keymap.set("n", "<leader>ht", t_builtin.colorscheme, { desc = "Change [t]heme" })
vim.keymap.set("n", "<leader>hl", "<cmd>:Lazy<cr>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>hk", t_builtin.keymaps, { desc = "Show keymaps" })
vim.keymap.set("n", "<leader>hm", "<cmd>:Mason<cr>", { desc = "Open Mason" })

vim.keymap.set("n", "<leader>tc", require("barbecue.ui").toggle, { desc = "Toggle Barbecue context" })
vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble list" })

vim.keymap.set("n", "<leader>o", function() require("portal.builtin").jumplist.tunnel_backward() end)
vim.keymap.set("n", "<leader>i", function() require("portal.builtin").jumplist.tunnel_forward() end)

-- luapad
vim.keymap.set("n", "<leader>x", require("luapad").init, { desc = "Open Lua scratchpad" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.keymap.set("n", "<leader>rl", "<cmd>:.SnipRun<cr>", { desc = "Run current line" })
vim.keymap.set("v", "<leader>rs", "<cmd>'<, '>SnipRun<cr>", { desc = "Run selection" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup {
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
}

-- Treesitter context
require("treesitter-context").setup()

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don"t have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", t_builtin.lsp_references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", t_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", t_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("<C-k>", vim.lsp.buf.hover, "Hover Documentation")
    nmap("K", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
        if vim.lsp.buf.format then
            vim.lsp.buf.format()
        elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
        end
    end, { desc = "Format current buffer with LSP" })

    nmap("<leader>bf", vim.lsp.buf.format, "[F]ormat this [b]uffer")
end

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = {
    -- "rust_analyzer",
    -- "pyright",
    "lua_ls",
    "clangd",
    "emmet_language_server",
}

-- Ensure the servers above are installed
require("mason-lspconfig").setup {
    ensure_installed = servers,
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
    require("lspconfig")[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

-- Turn on lsp status information
require("fidget").setup()

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ";", {})
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you"re using (most likely LuaJIT)
                version = "LuaJIT",
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
        },
    },
}

-- nvim-cmp setup
local cmp = require "cmp"
local luasnip = require "luasnip"

cmp.setup {
    experimental = {
        ghost_text = true
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
                local copilot = require 'copilot.suggestion'
                if copilot.is_visible() then
                    copilot.accept()
                elseif cmp.visible() then
                    local entry = cmp.get_selected_entry()
                    if not entry then
                        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                    else
                        cmp.confirm()
                    end
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item(){ behavior = cmp.SelectBehavior.Insert }
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "path", group_index = 2 },
        { name = "luasnip" },
    },
}

require('overseer').setup()

require("cmake-tools").setup({})
end
