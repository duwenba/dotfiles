-- Auto-start config（noctalia-shell v4 / quickshell，默认）
-- 切换：修改 core/variables.lua 中的 SHELL = "noctalia"
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart
-- polkit 密码弹窗：v4 无内置 agent，启动 hyprpolkitagent；noctalia v5 已内置，故不放其 autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("qs -c noctalia-shell")
    hl.exec_cmd("xhost +SI:localuser:root")
end)
