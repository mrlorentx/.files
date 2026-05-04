-- enable treesitter highlighting for all buffers
-- (nvim-treesitter in 0.12 is just a parser installer, highlighting is built-in)
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- the initial buffer's FileType fires before plugin/ loads, so start it now
pcall(vim.treesitter.start)
