require("./module/*")

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    input = {
        kb_layout = "pl",
        kb_options = "",
    },

    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 2,

        -- col = {
        --     active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
        --     inactive_border = "rgba(595959aa)",
        -- },

        snap = {
            enabled = true,
            respect_gaps = true,
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 3,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = false,
            new_optimizations = true,
            size      = 3,
            passes    = 2,
            vibrancy  = 0.1696,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- You probably want this
    },

    master = {
        new_status = "master",
    },

    scrolling = {
        fullscreen_on_one_column = true,
    },

    misc = {
        force_default_wallpaper = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})
-- For Noctalia Color templates
require("noctalia").apply_theme()
