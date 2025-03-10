return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",

	-- example using `opts` for defining servers
	opts = {
		servers = {
			lua_ls = {},
			clangd = {},
			svelte = {},
			rust_analyzer = {},
		},
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end
	end,

	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP
		"j-hui/fidget.nvim",

		-- Additional lua configuration, makes nvim stuff amazing
		"folke/neodev.nvim",

		-- "saghen/blink.cmp",
	},
}
