vim.pack.add({ "https://github.com/nuchs/vim-hypr-nav" }, { confirm = false })

-- Hyprland's Lua config (Omarchy 4 / Quattro) evaluates `hyprctl dispatch`
-- arguments as Lua, so the plugin's `hyprctl dispatch movefocus <dir>` no longer
-- parses -- Super+hjkl moves between splits but can't leave Neovim. Redefine the
-- entry point the helper script calls over --remote-expr, keeping the plugin's
-- logic on the current dispatch syntax. Overridden here rather than patched in
-- place so vim.pack.update() can't quietly revert it.
vim.cmd([[
function! VimHyprNav(dir) abort
  let l:flag = get({"l": "h", "d": "j", "u": "k", "r": "l"}, a:dir)
  if empty(l:flag)
    return
  endif
  if winnr(l:flag) == winnr()
    call jobstart(["hyprctl", "dispatch", 'hl.dsp.focus({direction="' . a:dir . '"})'])
  else
    execute "wincmd " . l:flag
  endif
endfunction
]])

-- Seamless Ctrl-hjkl across nvim splits + tmux panes (forge / SSH workflow).
-- Outside tmux the plugin falls back to plain :wincmd, so it's safe to load unconditionally.
vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" }, { confirm = false })
