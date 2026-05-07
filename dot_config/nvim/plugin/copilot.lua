vim.pack.add({
	"https://github.com/zbirenbaum/copilot.lua",
	"https://github.com/copilotlsp-nvim/copilot-lsp", -- LSP for NES + native inline completion (used by sidekick)
	"https://github.com/giuxtaposition/blink-cmp-copilot", -- bridges copilot suggestions into blink.cmp
}, { confirm = false })

require("copilot").setup({
	suggestion = { enabled = false }, -- let blink.cmp render suggestions
	panel = { enabled = false },
})

-- enable LSP-driven inline ghost-text completions when copilot-lsp attaches.
-- <Tab> already accepts these via the blink keymap chain
-- (vim.lsp.inline_completion.get() is in the chain).
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client.name == "copilot" then
			vim.lsp.inline_completion.enable(true, { bufnr = ev.buf })
		end
	end,
})
