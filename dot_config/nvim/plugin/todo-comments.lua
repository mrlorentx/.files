vim.pack.add({ "https://github.com/folke/todo-comments.nvim" }, { confirm = false })

require("todo-comments").setup({ signs = false })

vim.keymap.set("n", "<leader>tdl", "<cmd>TodoTelescope<cr>", { desc = "Search Todos" })
