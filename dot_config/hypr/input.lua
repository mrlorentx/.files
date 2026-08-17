-- Personal input overrides. These replace Omarchy's defaults.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    kb_layout = "us,se",
    kb_options = "ctrl:nocaps,grp:alt_space_toggle",

    repeat_rate = 15,
    repeat_delay = 200,

    touchpad = {
      -- Control the speed of your scrolling.
      scroll_factor = 0.4,
    },
  },
})

-- Scroll nicely in the terminal.
o.window("(Alacritty|kitty)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
