-- CachyOS Hyprland Configuration

-- 1. 共享基础（variables 必须最先加载：定义 SHELL、MONITOR* 等全局变量）
require("core.variables")
require("core.animations")
require("core.colors")
require("core.decorations")
require("core.environment")
require("core.inputs")
require("core.misc")
require("core.monitors")
require("core.windowrules")
require("core.workspaces")
-- require("core.binds") -- Bind definitions moved to keymap

-- 2. 按全局变量 SHELL（core/variables.lua 中定义）加载对应 shell 的 autostart
require("shells." .. SHELL .. ".autostart")

-- 3. keymap：v5 由 Noctalia Keymap 插件托管；v4 为手写适配版
-- BEGIN Keymap managed include
-- Noctalia Keymap 插件要求保留字面量 require("keymap")（见 writer_service.luau 的 hasExactLine）
if SHELL == "noctalia" then
    require("keymap")
else
    require("shells.noctalia-shell.keymap")
end
-- END Keymap managed include

