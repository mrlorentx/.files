vim.pack.add(
	{ "https://github.com/stevearc/conform.nvim", "https://github.com/zapling/mason-conform.nvim" },
	{ confirm = false }
)

require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		local disable_filetypes = { c = true, cpp = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		end
		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		go = { "goimports", "gofumpt" },
		toml = { "taplo" },
	},
})

require("mason-conform").setup()

vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
