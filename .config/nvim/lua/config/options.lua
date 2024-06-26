-- this needs to be set early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autowrite = true -- enable auto write
-- [[ Setting options ]]
-- See `:help vim.o`

-- Set timeout for which-key
vim.o.timeout = true
vim.o.timeoutlen = 400

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Changing split direction
vim.o.splitbelow = true
vim.o.splitright = true

-- Highlight current line
vim.o.cursorline = true
-- vim.o.colorcolumn = "80"

-- Set colorscheme
vim.o.termguicolors = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- for neovide GUI
if vim.g.neovide then
    vim.o.guifont = "JetBrainsMono Nerd Font:h12"
    vim.g.neovide_cursor_animation_length = 0.06
    vim.g.neovide_cursor_trail_size = 0.4
    vim.g.neovide_remember_window_size = true
end

-- [[ Basic Keymaps ]]

-- Copy to system clipboard by default
vim.o.clipboard = 'unnamedplus'

vim.o.tabstop = 4 -- size of a hard tabstop (ts).
vim.o.shiftwidth = 4 -- size of an indentation (sw).
vim.o.expandtab = true -- always uses spaces instead of tab characters (et).
vim.o.softtabstop = 4 -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
