-- Look and feel configuration

hl.config({
    general = {
        gaps_in = 1,
        gaps_out = 2,
        border_size = 2,
        extend_border_grab_area = 10,
        resize_on_border = true,
        col = {
            active_border = CACHYTEAL,
            inactive_border = CACHYGRAY,
        },
    },
    group = {
        col = {
            border_active = CACHYLBLUE,
            border_inactive = CACHYGRAY,
            border_locked_active = CACHYDBLUE,
            border_locked_inactive = CACHYGRAY,
        },
        groupbar = {
            col = {
                active = CACHYLGREEN,
                inactive = CACHYGRAY,
                locked_active = CACHYDBLUE,
                locked_inactive = CACHYGRAY,
            },
        },
    },
    decoration = {
        dim_special = 0.3,
        rounding = 2,
        blur = {
            enabled = true,
            xray = true,
            size = 10,
            passes = 4,
            special = true,
        },
        shadow = {
            enabled = false,
        },
    },
})
