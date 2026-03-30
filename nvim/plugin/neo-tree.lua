-- plenary and nvim-web-devicons already in 00-deps.lua
vim.pack.add({
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
}, { confirm = false })

require("neo-tree").setup({
	close_if_last_window = true,
	filtered_items = {
		visible = true,
		hide_dotfiles = false,
	},
	filesystem = {
		window = {
			mappings = {
				["\\"] = "close_window",
			},
		},
	},
})

vim.keymap.set("n", "\\", "<cmd>Neotree reveal right<cr>", { desc = "NeoTree reveal", silent = true })
