-- Shared dependencies — loaded first (00- prefix ensures alphabetical priority)
vim.pack.add({
	-- mason ecosystem (needed by lsp, conform, etc.)
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

	-- telescope + deps (needed by notes, todo-comments, etc.)
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
}, { confirm = false })

require("mason").setup()
