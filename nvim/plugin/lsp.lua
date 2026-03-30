local lsp_servers = {
	lua_ls = {
		-- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
		Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) } },
	},
	ts_ls = {},
	eslint = {},
	gopls = {},
	jsonls = {},
	terraformls = {},
	marksman = {},
}

local tools = {
	"golangci-lint",
	"golangci-lint-langserver",
	"gofumpt",
	"stylua",
	"prettier",
	"yq",
}

-- mason is already set up in 00-deps.lua
require("mason-lspconfig").setup()
local ensure_installed = vim.tbl_keys(lsp_servers)
vim.list_extend(ensure_installed, tools)
require("mason-tool-installer").setup({
	ensure_installed = ensure_installed,
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
	vim.lsp.config(server, {
		settings = config,
	})
end

vim.lsp.enable(vim.tbl_keys(lsp_servers))
