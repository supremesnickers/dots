local imap = function(tbl)
    vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

local nmap = function(tbl)
    vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

local nvmap = function(tbl)
    vim.keymap.set({ "n", "v" }, tbl[1], tbl[2], tbl[3])
end

local neogit = require("neogit")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- Remove the space keymap to avoid conflicts
nvmap { "<Space>", "<Nop>", { silent = true } }

-- Remap for dealing with word wrap
nmap { "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true } }
nmap { "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true } }

-- Telescope
local t = require("telescope")
local t_builtin = require("telescope.builtin")
local t_utils = require("telescope.utils")
local t_simple_dropdown = require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
}

nmap { "<leader>pp", require "telescope".extensions.projects.projects, { desc = "Open recent project" } }
nmap { "<leader>bb",
    function()
        t.extensions.scope.buffers(t_simple_dropdown)
    end,
    { desc = "Switch between [b]uffers" } }

nmap { "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    t_builtin.current_buffer_fuzzy_find(t_simple_dropdown)
end, { desc = "[/] Fuzzily search in current buffer]" } }

nmap { "<leader><leader>", function()
    local in_git_dir = os.execute("git rev-parse --is-inside-work-tree") == 0

    if in_git_dir then
        t_builtin.git_files()
    else
        t_builtin.find_files()
    end
end, { desc = "[F]ind [F]iles" } }

nmap { "<leader>fd", function()
    t_builtin.find_files({
        cwd = t_utils.buffer_dir(),
    })
end, { desc = "[F]ind in current [d]irectory" } }
nmap { "<leader>ff", t_builtin.find_files, { desc = "[F]ind [F]iles" } }
nmap { "<leader>fr", t_builtin.oldfiles, { desc = "Find [r]ecently opened files" } }
nmap { "<leader>fc", function()
    t_builtin.find_files(require("telescope.themes").get_dropdown {
        previewer = false,
        cwd = "~/.config/nvim/",
        no_ignore = true,
        prompt_title = "Find Neovim config files"
    })
end, { desc = "[F]ind in [c]onfig" } }
nmap { "<leader>fF", "<cmd>:Format<cr>", { desc = "Format file" } }

nmap { "<leader>sh", t_builtin.help_tags, { desc = "[S]earch [H]elp" } }

nmap { "<leader>sw", t_builtin.grep_string, { desc = "[S]earch current [W]ord" } }
nmap { "<leader>ss", t_builtin.live_grep, { desc = "[S]earch by [G]rep" } }
nmap { "<leader>sd", t_builtin.diagnostics, { desc = "[S]earch [D]iagnostics" } }
nmap { "<leader>sG", t_builtin.git_files, { desc = "[S]earch [G]it files" } }

nmap { "<leader>ht", t_builtin.colorscheme, { desc = "Change [t]heme" } }
nmap { "<leader>hk", t_builtin.keymaps, { desc = "Show keymaps" } }

-- hop.nvim
local hop = require("hop")
local directions = require("hop.hint").HintDirection
nvmap { "gss", hop.hint_char2, { remap = true, desc = "Hop 2 characters" } }

nvmap { "gs(", function() hop.hint_lines({ direction = directions.BEFORE_CURSOR }) end,
    { remap = true, desc = "Hop lines backwards" } }

nvmap { "gs)", function()
    hop.hint_lines({ direction = directions.AFTER_CURSOR })
end, { remap = true, desc = "Hop lines forwards" } }

-- Neogit
nmap { "<leader>gg", neogit.open, { desc = "Open Neogit" } }

nmap { "<leader>hl", "<cmd>:Lazy<cr>", { desc = "Open Lazy" } }
nmap { "<leader>hm", "<cmd>:Mason<cr>", { desc = "Open Mason" } }

nmap { "<leader>tc", require("barbecue.ui").toggle, { desc = "Toggle Barbecue context" } }
nmap { "<leader>tt", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble list" } }

nmap { "<leader>o", function() require("portal.builtin").jumplist.tunnel_backward() end }
nmap { "<leader>i", function() require("portal.builtin").jumplist.tunnel_forward() end }

-- luapad
nmap { "<leader>x", require("luapad").init, { desc = "Open Lua scratchpad" } }

-- Diagnostic keymaps
nmap { "[d", vim.diagnostic.goto_prev }
nmap { "]d", vim.diagnostic.goto_next }
nmap { "<leader>e", vim.diagnostic.open_float }
nmap { "<leader>q", vim.diagnostic.setloclist }

nmap { "<leader>rl", "<cmd>:.SnipRun<cr>", { desc = "Run current line" } }
vim.keymap.set("v", "<leader>rs", "<cmd>'<, '>SnipRun<cr>", { desc = "Run selection" })
