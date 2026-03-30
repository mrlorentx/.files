---@diagnostic disable: missing-fields

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.ignorecase = true
vim.opt.scrolloff = 10
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.confirm = true
vim.opt.showmode = false

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true

vim.opt.signcolumn = "yes"

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.hlsearch = true

vim.opt.breakindent = true

vim.opt.wrap = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80

vim.opt.cmdheight = 0

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
	virtual_text = true, -- show inline diagnostics
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- INFO: colorscheme (loaded early to avoid flicker)
vim.pack.add({ "https://github.com/folke/tokyonight.nvim" }, { confirm = false })
vim.cmd.colorscheme("tokyonight-night")

-- INFO: formatting and syntax highlighting
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" }, { confirm = false })

-- uncomment to enable automatic plugin updates
-- vim.pack.update()
