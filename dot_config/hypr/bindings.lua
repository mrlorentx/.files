-- Personal keybinding overrides. Omarchy defaults load first (hyprland.lua),
-- so any key Omarchy already uses must be unbound before rebinding.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Apps ------------------------------------------------------------------------

-- Activity on SUPER+SHIFT+T (Omarchy puts it on SUPER+CTRL+T).
o.bind("SUPER + SHIFT + T", "Activity", { tui = "btop" })

hl.unbind("SUPER + SHIFT + S") -- was: Google Maps
o.bind("SUPER + SHIFT + S", "Sound", "omarchy-shell shell toggle omarchy.audio")

hl.unbind("SUPER + SHIFT + W") -- was: Omawrite
o.bind("SUPER + SHIFT + W", "Wifi", "omarchy-shell shell toggle omarchy.network")

hl.unbind("SUPER + SHIFT + C") -- was: Calendar (Hey webapp)
o.bind("SUPER + SHIFT + C", "Calendar", { launch = "rencal" })

hl.unbind("SUPER + SLASH") -- was: Monitor scaling up
o.bind("SUPER + SLASH", "Passwords (quick access)", { launch = "1password --quick-access" })

-- System ----------------------------------------------------------------------

o.bind("SUPER + Q", "Lock system", "omarchy-system-lock")

hl.unbind("SUPER + CTRL + code:13") -- was: Bar panel 4
o.bind("SUPER + CTRL + code:13", "Screenshot", "omarchy-capture-screenshot")
o.bind("SUPER + CTRL + ALT + code:13", "Screenrecording", "omarchy-capture-screenrecording")

-- Focus via vim-hypr-nav --------------------------------------------------------
-- Takes over J/K/L from Omarchy and drops arrow focus, matching the old setup.
-- The keybindings menu is still reachable from the SUPER+SPACE menu.

hl.unbind("SUPER + J") -- was: Toggle window split
hl.unbind("SUPER + K") -- was: Keybindings menu
hl.unbind("SUPER + L") -- was: Toggle workspace layout
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")

o.bind("SUPER + H", "Focus left", "vim-hypr-nav l")
o.bind("SUPER + J", "Focus down", "vim-hypr-nav d")
o.bind("SUPER + K", "Focus up", "vim-hypr-nav u")
o.bind("SUPER + L", "Focus right", "vim-hypr-nav r")

-- Move workspace between monitors ------------------------------------------------

hl.unbind("SUPER + CTRL + H") -- was: Hardware menu
hl.unbind("SUPER + CTRL + L") -- was: Lock system (now on SUPER+Q above)
o.bind("SUPER + CTRL + H", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + CTRL + L", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))

-- Workspaces ----------------------------------------------------------------------

hl.workspace_rule({
	workspace = "special:scratchpad",
	on_created_empty = '[float; size 1000 800; border 1; center] omarchy-launch-editor "+Obsidian today"',
	persistent = false,
})

-- Default apps per workspace (launched on first visit when the workspace is empty).
hl.workspace_rule({ workspace = "1", on_created_empty = "omarchy-launch-editor" })
hl.workspace_rule({ workspace = "2", on_created_empty = "omarchy-launch-browser" })
hl.workspace_rule({ workspace = "3", on_created_empty = o.launch_sole("slack", "slack") })
