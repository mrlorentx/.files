-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Ctrl-hjkl split/pane navigation is owned by vim-tmux-navigator (see navigation.lua).
-- Outside tmux it degrades to plain :wincmd, matching the old behavior.

-- Write buffer with less annoying commands
vim.keymap.set("n", "<leader>ww", vim.cmd.w, { noremap = true, silent = true, desc = "Save Current Buffer" })
vim.keymap.set("n", "<leader>wa", vim.cmd.wa, { noremap = true, silent = true, desc = "Save All Buffers" })
vim.keymap.set("n", "<leader>wq", vim.cmd.wq, { noremap = true, silent = true, desc = "Save and Close Current Buffer" })

-- Close buffer with less annoying commands
vim.keymap.set("n", "zz", "<cmd>silent x<cr>", { noremap = true, silent = true, desc = "Close Current Buffer" })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et
