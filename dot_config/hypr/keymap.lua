-- Managed by Noctalia Keymap.
-- Existing entries are preserved; new entries are appended.
-- 1. Panel

local mainMod = "SUPER"
local noctCall = "noctalia msg "
local launchPrefix = "uwsm app -- "
-- 2. Window Management
hl.bind(mainMod .. " + Escape",      hl.dsp.exec_cmd("hyprctl kill"),              { description = "exit Hyprland" })
hl.bind(mainMod .. " + Q",           hl.dsp.window.close(),                        { description = "close window" })
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }),   { description = "toggle float" })
hl.bind(mainMod .. " + D",           hl.dsp.window.fullscreen({ mode = 1 }),       { description = "toggle fullscreen (maximize)" })
hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen(),                   { description = "toggle fullscreen" })
hl.bind("SUPER + p",                 hl.dsp.window.pin(),                          { description = "toggle pinned" })
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"),                 { description = "toggle split layout" })
hl.bind(mainMod .. " + Left",        hl.dsp.focus({ direction = "left" }),         { description = "focus left" })
hl.bind(mainMod .. " + Right",       hl.dsp.focus({ direction = "right" }),        { description = "focus right" })
hl.bind(mainMod .. " + Up",          hl.dsp.focus({ direction = "up" }),           { description = "focus up" })
hl.bind(mainMod .. " + Down",        hl.dsp.focus({ direction = "down" }),         { description = "focus down" })
hl.bind("ALT + Tab",                 hl.dsp.window.cycle_next(),                   { description = "cycle next window" })
hl.bind(mainMod .. " + Tab",         hl.dsp.exec_cmd(noctCall .. "window-switcher"), { description = "window switcher" })
hl.bind(mainMod .. " + SHIFT + Up",                   hl.dsp.window.move({ direction = "u" }),           { description = "move window up" })
hl.bind(mainMod .. " + SHIFT + Right",                hl.dsp.window.move({ direction = "r" }),           { description = "move window right" })
hl.bind(mainMod .. " + SHIFT + Left",                 hl.dsp.window.move({ direction = "l" }),           { description = "move window left" })
hl.bind(mainMod .. " + SHIFT + Down",                 hl.dsp.window.move({ direction = "d" }),           { description = "move window down" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Right",      hl.dsp.window.move({ workspace = "+1" }),         { description = "move window to next workspace" })
hl.bind(mainMod .. " + CONTROL + SHIFT + Left",       hl.dsp.window.move({ workspace = "-1" }),         { description = "move window to prev workspace" })
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace =  i }), { description = "move window to workspace " .. i })
end
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { description = "drag window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { description = "resize window" })


-- 3. Launcher
hl.bind(mainMod .. " + Return",             hl.dsp.exec_cmd(launchPrefix .. TERMINAL),              { description = "open terminal" })
hl.bind(mainMod .. " + E",                  hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER),          { description = "open file manager" })
hl.bind(mainMod .. " + T",                  hl.dsp.exec_cmd(launchPrefix .. TERMINAL, { float = true }),   { description = "open terminal (floating)" })
hl.bind(mainMod .. " + C",                  hl.dsp.exec_cmd(launchPrefix .. CALCULATOR, { float = true }), { description = "open calculator (floating)" })
-- Keymap hidden v1 begin 6094f58d 14b9008b
-- Keymap hidden v1 data 686c2e62696e6428225846383643616c63756c61746f72222c20202020202020202020202020202020202020686c2e64
-- Keymap hidden v1 data 73702e657865635f636d64286c61756e6368507265666978202e2e2043414c43554c41544f52292c2020202020202020
-- Keymap hidden v1 data 202020207b206465736372697074696f6e203d20226f70656e2063616c63756c61746f7222207d29
-- Keymap hidden v1 end 6094f58d
hl.bind(mainMod .. " + W",                  hl.dsp.exec_cmd(launchPrefix .. BROWSER),               { description = "open browser" })
hl.bind("CONTROL + SHIFT + Escape",         hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " -e btop"),{ description = "open system monitor" })
hl.bind(mainMod .. " + Z",                  hl.dsp.exec_cmd(noctCall .. "settings-toggle"),         { description = "toggle settings" })
hl.bind(mainMod .. " + X",                  hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center"), { description = "toggle control center" })
hl.bind(mainMod .. " + Space",              hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher"),   { description = "toggle launcher" })
hl.bind(mainMod .. " + period",             hl.dsp.exec_cmd(noctCall .. "panel-toggle launcher /emo"), { description = "toggle emoji picker" })
hl.bind(mainMod .. " + L",                  hl.dsp.exec_cmd(noctCall .. "session lock"),            { description = "lock session" })
hl.bind(mainMod .. " + ALT + C",            hl.dsp.exec_cmd(noctCall .. "panel-toggle session"),    { description = "toggle session panel" })
-- 4. Hardware Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctCall .. "volume-up"),      { description = "raise volume",     locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctCall .. "volume-down"),    { description = "lower volume",     locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(noctCall .. "volume-mute"),    { description = "mute volume",      locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(noctCall .. "mic-mute"),       { description = "mute microphone",  locked = true })
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(noctCall .. "media toggle"),   { description = "toggle playback",  locked = true })
hl.bind("XF86AudioPause",       hl.dsp.exec_cmd(noctCall .. "media toggle"),   { description = "toggle playback",  locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(noctCall .. "media next"),     { description = "next track",       locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(noctCall .. "media previous"), { description = "previous track",   locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(noctCall .. "brightness-up"),   { description = "raise brightness", locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctCall .. "brightness-down"), { description = "lower brightness", locked = true, repeating = true })
-- 5. Utilities
-- Keymap bind-category: Utilities
hl.bind("SUPER + K", hl.dsp.exec_cmd([[noctalia msg panel-toggle blackbartblues/keymap:panel]]), { description = "show keybinds" })
hl.bind(mainMod .. "+ SHIFT + P",      hl.dsp.exec_cmd("hyprpicker -a -n"),                     { description = "color picker" })
hl.bind("Print",                       hl.dsp.exec_cmd(noctCall .. "screenshot-region"),        { description = "screenshot region" })
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd(noctCall .. "screenshot-fullscreen"),    { description = "screenshot fullscreen" })
hl.bind(mainMod .. " + SHIFT + W",     hl.dsp.exec_cmd(noctCall .. "panel-toggle wallpaper"),   { description = "toggle wallpaper panel" })
hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd(noctCall .. "panel-toggle clipboard"),   { description = "toggle clipboard" })
hl.bind(mainMod .. " + A",             hl.dsp.exec_cmd(noctCall .. "panel-toggle control-center notifications"), { description = "toggle notifications" })
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > ZOOM_MAX then
        hl.config({ cursor = { zoom_factor = ZOOM_MAX } })
    elseif (zoomvalue + value) < ZOOM_MIN then
        hl.config({ cursor = { zoom_factor = ZOOM_MIN } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(mainMod .. " + Minus",    function() zoomfunction(-0.3) end, { description = "zoom out",     repeating = true })
hl.bind(mainMod .. " + Plus",     function() zoomfunction(0.3) end,  { description = "zoom in",      repeating = true })
hl.bind(mainMod .. " + code:82",  function() zoomfunction(-0.3) end, { description = "zoom out (kp)", repeating = true })
hl.bind(mainMod .. " + code:86",  function() zoomfunction(0.3) end,  { description = "zoom in (kp)",  repeating = true })
-- 6. Workspaces & Monitors
for i = 1, NUM_WPM do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "focus workspace " .. i })
end
-- for i = 1, NUM_WPM do
--     local key = i % 10
--     hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = "m~" .. i }), { description = "focus relative workspace " .. i })
-- end
hl.bind(mainMod .. " + CONTROL + Right",       hl.dsp.focus({ workspace = "m+1" }),     { description = "focus next workspace" })
hl.bind(mainMod .. " + CONTROL + Left",        hl.dsp.focus({ workspace = "m-1" }),     { description = "focus prev workspace" })
hl.bind(mainMod .. " + CONTROL + Down",        hl.dsp.focus({ workspace = "emptym" }),  { description = "focus empty workspace" })
hl.bind(mainMod .. " + mouse_down",           hl.dsp.focus({ workspace = "m-1" }),      { description = "focus prev workspace" })
hl.bind(mainMod .. " + mouse_up",             hl.dsp.focus({ workspace = "m+1" }),      { description = "focus next workspace" })
hl.bind(mainMod .. " + CONTROL + mouse_up",   hl.dsp.focus({ workspace = "m-1" }),      { description = "focus prev workspace" })
hl.bind(mainMod .. " + CONTROL + mouse_down", hl.dsp.focus({ workspace = "m+1" }),      { description = "focus next workspace" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special" }),       { description = "move to scratchpad" })
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special(),                   { description = "toggle scratchpad" })
