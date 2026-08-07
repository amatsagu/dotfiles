-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- "Smart gaps" / "No gaps when only"
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size = { 810, 690 },
})

hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

hl.window_rule({
  name = "foot",
  match = {
    namespace = "foot",
    class = "foot",
  },
  opacity = 0.9,
})

-- File Roller (floating by initial class and dynamic title)
hl.window_rule({
    match = { 
        class = "org.gnome.FileRoller",
        initial_class = "org.gnome.FileRoller"
    },
    float = true,
    size = { 952, 625 },
    center = true,
})

-- Thunar File Operations (Matches "File Operation Progress", "Copying...", "Moving...", etc.)
hl.window_rule({
    match = { 
        class = "thunar",
        title = ".*(Progress|Copying|Moving|Deleting|Conflict|Properties).*"
    },
    float = true,
    size = { 952, 625 },
    center = true,
})
