-- Hyprland default apps

TERMINAL     = "kitty"
FILE_MANAGER = "kitty yazi"
BROWSER      = "zen-browser"
EDITOR       = "kitty micro"
CALCULATOR   = "gnome-calculator"

-- Monitors
MONITOR1 = ""
MONITOR2 = ""
MONITOR3 = ""
PRIMARY_MONITOR = MONITOR1

-- zoom factor
ZOOM_MAX        = 5.0
ZOOM_MIN        = 1.0

-- Workspaces
NUM_WPM = 5 -- Number of workspaces per monitor (Max 10)

-- SHELLS

-- 选择启用的 shell（hyprland.lua 根据此全局变量加载对应 profile）
-- SHELL = "noctalia-shell"  -- v4 quickshell（默认）
SHELL = "noctalia"       -- v5 守护进程
