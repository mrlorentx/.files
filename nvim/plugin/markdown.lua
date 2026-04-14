local loaded = false
local function ensure_loaded()
	if loaded then
		return
	end
	loaded = true
	vim.api.nvim_del_user_command("MarkdownPreview")
	vim.api.nvim_del_user_command("MarkdownPreviewStop")
	vim.api.nvim_del_user_command("MarkdownPreviewRefresh")
	vim.pack.add({
		"https://github.com/selimacerbas/live-server.nvim",
		"https://github.com/selimacerbas/markdown-preview.nvim",
	}, { confirm = false })
	require("markdown_preview").setup({})
end

vim.api.nvim_create_user_command("MarkdownPreview", function()
	ensure_loaded()
	vim.cmd("MarkdownPreview")
end, {})
vim.api.nvim_create_user_command("MarkdownPreviewStop", function()
	ensure_loaded()
	vim.cmd("MarkdownPreviewStop")
end, {})
vim.api.nvim_create_user_command("MarkdownPreviewRefresh", function()
	ensure_loaded()
	vim.cmd("MarkdownPreviewRefresh")
end, {})

vim.keymap.set("n", "<leader>mps", "<cmd>MarkdownPreview<cr>", { desc = "Markdown: Start preview" })
vim.keymap.set("n", "<leader>mpS", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown: Stop preview" })
vim.keymap.set("n", "<leader>mpr", "<cmd>MarkdownPreviewRefresh<cr>", { desc = "Markdown: Refresh preview" })
