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
-- nvim-lspconfig provides default cmd/filetypes/root_markers for servers
vim.cmd.packadd("nvim-lspconfig")
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

-- LSP keymaps (set on attach)
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("gD", vim.lsp.buf.declaration, "Go to declaration")
		map("grr", vim.lsp.buf.references, "References")
		map("gri", vim.lsp.buf.implementation, "Implementation")
		map("grn", vim.lsp.buf.rename, "Rename")
		map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }))
		end, "Toggle inlay hints")
	end,
})
