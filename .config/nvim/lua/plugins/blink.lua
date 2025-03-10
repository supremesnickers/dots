return {
	"saghen/blink.cmp",
	version = "*",
	build = "cargo build --release",
	opts = {
		keymap = { preset = "super-tab", ["<CR>"] = { "accept", "fallback" } },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			cmdline = {},
		},
	},
	opts_extend = { "sources.default" },
}
