local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Base window control
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Hyprland session control
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(app.sessionControl))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Launch basic apps
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(app.terminal))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(app.settingsWidget))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd(app.settingsWindow))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(app.fileManager))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(app.menu))
hl.bind("PRINT", hl.dsp.exec_cmd(app.captureScreen))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(app.windowSwitcher))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(app.lockScreen))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctaliaIPC .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctaliaIPC .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctaliaIPC .. "volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctaliaIPC .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctaliaIPC .. "brightness-down"))

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })