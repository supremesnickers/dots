vim.o.autowrite = true -- enable auto write
-- [[ Setting options ]]
-- See `:help vim.o`

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

-- [[ Basic Keymaps ]]

-- Copy to system clipboard by default
vim.o.clipboard = 'unnamedplus'

vim.o.tabstop = 4 -- size of a hard tabstop (ts).
vim.o.shiftwidth = 4 -- size of an indentation (sw).
vim.o.expandtab = true -- always uses spaces instead of tab characters (et).
vim.o.softtabstop = 4 -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
