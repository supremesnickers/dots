-- Boostrapping lazy.nvim
if vim.g.vscode then
	-- VSCode extension
	vim.keymap.set({ "n", "v" }, "gc", "<cmd>:'<,'>VSCodeCommentary<CR>")
	vim.keymap.set({ "n" }, "gcc", "<cmd>:VSCodeCommentary<CR>")
else
	-- Compile lua to bytecode if the nvim version supports it.
	if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then
		vim.loader.enable()
	end
	require("config.options")
	require("config.lazy")

	require("neogit").setup({})
	require("ibl").setup({})
	require("gitsigns").setup()

	-- [[ Configure Telescope ]]
	-- See `:help telescope` and `:help telescope.setup()`
	local actions = require("telescope.actions")
	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<C-u>"] = false,
					["<C-d>"] = false,
					["<esc>"] = actions.close,
				},
			},
			path_display = {
				"filename_first",
			},
		},
		extensions = {
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),
			},
			project = {
				theme = "dropdown",
				on_project_selected = function(prompt_bufnr)
					-- Do anything you want in here. For example:
					print(prompt_bufnr)
					-- project_actions.change_working_directory(prompt_bufnr, false)
				end,
			},
		},
	})
	-- Enable telescope fzf native, if installed
	pcall(require("telescope").load_extension, "fzf")
	require("telescope").load_extension("ui-select")
	require("telescope").load_extension("projects")
	require("telescope").load_extension("scope")

	-- Set names for the prefixes in the which key menu
	-- should be descriptive enough
	local wk = require("which-key")
	wk.add({
		{ "<leader>f", group = "+file" },
		{ "<leader>s", group = "+search" },
		{ "<leader>b", group = "+buffer" },
		{ "<leader>t", group = "+toggle" },
	})

	-- Setup neovim lua configuration
	require("neodev").setup()

	-- nvim-cmp supports additional completion capabilities
	-- Turn on lsp status information
	require("fidget").setup({})

	require("overseer").setup()
	require("cmake-tools").setup({})

	-- source the rest of the configuration
	require("autocmds")
	require("treesitter")
	-- require("completion")
	require("lsp")
	require("eviline")
	require("keymaps")
	-- require("dap-conf")
end
