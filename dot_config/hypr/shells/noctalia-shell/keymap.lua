-- v4 适配版 keymap（noctalia-shell / quickshell）
-- 手动维护：与根目录 keymap.lua（v5 托管版）的绑定一一对应
-- 差异点：v5 走 `noctalia msg` IPC，v4 走 `qs ipc -c noctalia-shell call` IPC
-- 根 keymap.lua 被 Noctalia Keymap 插件改写时，请同步更新本文件的对应绑定

-- 1. Panel

local mainMod = "SUPER"
local shellCall = "qs ipc -c noctalia-shell call "
local launchPrefix = "uwsm app -- "

-- 2. Window Management
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"),              { description = "exit Hyprland" })
hl.bind(mainMod .. " + Q",           hl.dsp.window.close(),                        { description = "close window" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }),   { description = "toggle float" })
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }),       { description = "toggle fullscreen (maximize)" })
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen(),                   { description = "toggle fullscreen" })
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"),                 { description = "toggle split layout" })
hl.bind(mainMod .. " + Left",        hl.dsp.focus({ direction = "left" }),         { description = "focus left" })
hl.bind(mainMod .. " + Right",       hl.dsp.focus({ direction = "right" }),        { description = "focus right" })
hl.bind(mainMod .. " + Up",          hl.dsp.focus({ direction = "up" }),           { description = "focus up" })
hl.bind(mainMod .. " + Down",        hl.dsp.focus({ direction = "down" }),         { description = "focus down" })
hl.bind("ALT + Tab",                 hl.dsp.window.cycle_next(),                   { description = "cycle next window" })
hl.bind(mainMod .. " + Tab",         hl.dsp.exec_cmd(shellCall .. "launcher windows"), { description = "window switcher" })
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }),           { description = "move window up" })
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }),           { description = "move window right" })
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }),           { description = "move window left" })
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }),           { description = "move window down" })
hl.bind(mainMod .. " + SHIFT + 1",                    hl.dsp.window.move({ monitor = MONITOR1 }),        { description = "move window to monitor 1" })
hl.bind(mainMod .. " + SHIFT + 2",                    hl.dsp.window.move({ monitor = MONITOR2 }),        { description = "move window to monitor 2" })
hl.bind(mainMod .. " + SHIFT + 3",                    hl.dsp.window.move({ monitor = MONITOR3 }),        { description = "move window to monitor 3" })
hl.bind(mainMod .. " + SHIFT + mouse_up",             hl.dsp.window.move({ monitor = "-1" }),            { description = "move window to prev monitor" })
hl.bind(mainMod .. " + SHIFT + mouse_down",           hl.dsp.window.move({ monitor = "+1" }),            { description = "move window to next monitor" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "m+1" }),         { description = "move window to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "m-1" }),         { description = "move window to prev workspace" })
-- hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_up",   hl.dsp.window.move({ workspace = "m-1" }),         { description = "move window to prev workspace" })
-- hl.bind(mainMod .. " + CONTROL + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "m+1" }),         { description = "move window to next workspace" })
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + CONTROL + " .. key, hl.dsp.window.move({ workspace = "m~" .. i }), { description = "move window to workspace " .. i })
end
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { description = "drag window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "resize window" })

local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus",    function() zoomfunction(-0.3) end, { description = "zoom out",     repeating = true })
hl.bind(mainMod .. " + Plus",     function() zoomfunction(0.3) end,  { description = "zoom in",      repeating = true })
hl.bind(mainMod .. " + code:82",  function() zoomfunction(-0.3) end, { description = "zoom out (kp)", repeating = true })
hl.bind(mainMod .. " + code:86",  function() zoomfunction(0.3) end,  { description = "zoom in (kp)",  repeating = true })
-- 3. Launcher
hl.bind(mainMod .. " + Return",             hl.dsp.exec_cmd(launchPrefix .. TERMINAL),              { description = "open terminal" })
hl.bind(mainMod .. " + E",                  hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER),          { description = "open file manager" })
hl.bind(mainMod .. " + T",                  hl.dsp.exec_cmd(launchPrefix .. EDITOR),                { description = "open editor" })
hl.bind(mainMod .. " + C",                  hl.dsp.exec_cmd(launchPrefix .. CALCULATOR),            { description = "open calculator" })
hl.bind(mainMod .. " + W",                  hl.dsp.exec_cmd(launchPrefix .. BROWSER),               { description = "open browser" })
hl.bind("CONTROL + SHIFT + Escape",         hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"),{ description = "open system monitor" })
hl.bind(mainMod .. " + Z",                  hl.dsp.exec_cmd(shellCall .. "settings toggle"),        { description = "toggle settings" })
hl.bind(mainMod .. " + X",                  hl.dsp.exec_cmd(shellCall .. "controlCenter toggle"),   { description = "toggle control center" })
hl.bind(mainMod .. " + Space",              hl.dsp.exec_cmd(shellCall .. "launcher toggle"),        { description = "toggle launcher" })
hl.bind(mainMod .. " + period",             hl.dsp.exec_cmd(shellCall .. "launcher emoji"),         { description = "toggle emoji picker" })
hl.bind(mainMod .. " + L",                  hl.dsp.exec_cmd(shellCall .. "lockScreen lock"),        { description = "lock session" })
hl.bind(mainMod .. " + ALT + C",            hl.dsp.exec_cmd(shellCall .. "sessionMenu toggle"),     { description = "toggle session panel" })
-- 4. Hardware Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(shellCall .. "volume increase"),   { description = "raise volume",     locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(shellCall .. "volume decrease"),   { description = "lower volume",     locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(shellCall .. "volume muteOutput"), { description = "mute volume",      locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(shellCall .. "volume muteInput"),  { description = "mute microphone",  locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(shellCall .. "media playPause"),   { description = "toggle playback",  locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd(shellCall .. "media playPause"),   { description = "toggle playback",  locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(shellCall .. "media next"),        { description = "next track",       locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(shellCall .. "media previous"),    { description = "previous track",   locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(shellCall .. "brightness increase"), { description = "raise brightness", locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(shellCall .. "brightness decrease"), { description = "lower brightness", locked = true, repeating = true })
-- 5. Utilities
hl.bind("SUPER + K", hl.dsp.exec_cmd(shellCall .. "plugin:keybind-cheatsheet toggle"), { description = "launcher settings mode" })
hl.bind(mainMod .. " + P",             hl.dsp.exec_cmd("hyprpicker -a -n"),                     { description = "color picker" })
-- v4 无内置截图，走 grim + satty（与 noctalia 截图管道一致：satty -f -）
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd([[grim - | satty -f -]]),                 { description = "screenshot fullscreen" })
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | satty -f -]]),   { description = "screenshot region" })
hl.bind(mainMod .. " + SHIFT + W",     hl.dsp.exec_cmd(shellCall .. "wallpaper toggle"),        { description = "toggle wallpaper panel" })
hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd(shellCall .. "launcher clipboard"),       { description = "toggle clipboard" })
hl.bind(mainMod .. " + A",             hl.dsp.exec_cmd(shellCall .. "notifications toggleHistory"), { description = "toggle notifications" })
-- 6. Workspaces & Monitors
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.focus({ workspace = i }), { description = "focus workspace " .. i })
end
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = "m~" .. i }), { description = "focus relative workspace " .. i })
end
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }),     { description = "focus next workspace" })
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }),     { description = "focus prev workspace" })
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }),  { description = "focus empty workspace" })
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }),      { description = "focus prev workspace" })
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }),      { description = "focus next workspace" })
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }),      { description = "focus prev workspace" })
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }),      { description = "focus next workspace" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }),       { description = "move to scratchpad" })
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special(),                   { description = "toggle scratchpad" })
