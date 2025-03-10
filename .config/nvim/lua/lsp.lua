local t_builtin = require("telescope.builtin")
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		cpp = { "clang-format" },
		rust = { "rustfmt" },
	},
})

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

	nmap("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
	nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

	nmap("gr", t_builtin.lsp_references, "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("gd", vim.lsp.buf.definition, "[G]oto [d]efinition")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

	nmap("<leader>cD", vim.lsp.buf.type_definition, "Type [D]efinition")
	nmap("<leader>cS", t_builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>cw", t_builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

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

	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})

	nmap("<leader>bf", vim.lsp.buf.format, "[F]ormat this [b]uffer")
end

-- -- LSP servers and clients are able to communicate to each other what features they support.
-- --  By default, Neovim doesn't support everything that is in the LSP Specification.
-- --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
-- --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--
-- -- Enable the following language servers
-- -- Feel free to add/remove any LSPs that you want here. They will automatically be installed
-- local servers = {
--     -- "rust_analyzer",
--     -- "pyright",
--     lua_ls = {
--         settings = {
--             Lua = {
--                 runtime = {
--                     -- Tell the language server which version of Lua you"re using (most likely LuaJIT)
--                     version = "LuaJIT",
--                 },
--                 diagnostics = {
--                     globals = { "vim" },
--                 },
--                 workspace = {
--                     library = vim.api.nvim_get_runtime_file("", true),
--                     checkThirdParty = false,
--                 },
--                 -- Do not send telemetry data containing a randomized but unique identifier
--                 telemetry = { enable = false },
--             },
--         },
--     },
--     clangd = {},
--     emmet_language_server = {},
--     gopls = {
--         -- root_dir = function(fname)
--         --   local Path = require "plenary.path"
--         --
--         --   local absolute_cwd = Path:new(vim.loop.cwd()):absolute()
--         --   local absolute_fname = Path:new(fname):absolute()
--         --
--         --   if string.find(absolute_cwd, "/cmd/", 1, true) and string.find(absolute_fname, absolute_cwd, 1, true) then
--         --     return absolute_cwd
--         --   end
--         --
--         --   return lspconfig_util.root_pattern("go.mod", ".git")(fname)
--         -- end,
--
--         settings = {
--             gopls = {
--                 codelenses = { test = true },
--                 hints = inlays and {
--                     assignVariableTypes = true,
--                     compositeLiteralFields = true,
--                     compositeLiteralTypes = true,
--                     constantValues = true,
--                     functionTypeParameters = true,
--                     parameterNames = true,
--                     rangeVariableTypes = true,
--                 } or nil,
--             },
--         },
--
--         flags = {
--             debounce_text_changes = 200,
--         },
--     },
-- }

local servers = {}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
	"stylua", -- Used to format lua code
})

-- Setup mason so it can manage external tooling
require("mason").setup()

require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
-- Ensure the servers above are installed
-- require("mason-lspconfig").setup {
--     handlers = {
--         function(server_name)
--             local server = servers[server_name] or {}
--             server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--             server.on_attach = on_attach
--             require('lspconfig')[server_name].setup(server)
--         end
--     }
-- }
