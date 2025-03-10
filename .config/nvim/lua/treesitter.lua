-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Treesitter context
require("treesitter-context").setup()

require("nvim-treesitter.configs").setup({
	autotag = {
		enable = true,
	},
	ensure_installed = {
		"svelte",
		"javascript",
		"typescript",
		"tsx",
		"css",
		"html",
		"python",
		"json",
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			node_incremental = "v",
			node_decremental = "V",
		},
	},
})
