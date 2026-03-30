vim.pack.add({ "https://github.com/folke/zen-mode.nvim" }, { confirm = false })

vim.keymap.set("n", "<leader>zt", function()
	require("zen-mode").toggle({
		window = { width = 0.65 },
		plugins = { tmux = { enabled = true } },
	})
end, { desc = "Toggle Zen mode" })
