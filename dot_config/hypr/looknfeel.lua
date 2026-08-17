-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
    -- Minimal gaps between windows, none around the edge.
    gaps_in = 2,
    gaps_out = 0,
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    -- Square window corners.
    rounding = 0,

    blur = {
      size = 3,
      passes = 3,
      ignore_opacity = true,
      contrast = 0.8916,
      noise = 0.0117,
      xray = false,
      new_optimizations = true,
    },
  },
})
