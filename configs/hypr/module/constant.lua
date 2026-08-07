global noctaliaIPC = "noctalia msg "
global app = {
    terminal = "foot",
    fileManager = "thunar",
    menu = noctaliaIPC .. "panel-toggle launcher",
    settingsWidget = noctaliaIPC .. "panel-toggle control-center",
    settingsWindow = noctaliaIPC .. "settings-toggle",
    windowSwitcher = noctaliaIPC .. "window-switcher",
    captureScreen = noctaliaIPC .. "screenshot-region",
    lockScreen = noctaliaIPC .. "session lock",
    sessionControl = noctaliaIPC .. "panel-toggle session"
}

return app