vim.pack.add({ "https://github.com/nuchs/vim-hypr-nav" }, { confirm = false })

-- Seamless Ctrl-hjkl across nvim splits + tmux panes (forge / SSH workflow).
-- Outside tmux the plugin falls back to plain :wincmd, so it's safe to load unconditionally.
vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" }, { confirm = false })
