-- Wezterm config file
local M = {}

-- Common
local wezterm = require('wezterm')

-- Fonts
M.font = wezterm.font_with_fallback({
    {
        family = 'JetBrains Mono',
        harfbuzz_features = { 'zero', 'calt=0', 'clig=0', 'liga=0', },
    },
    {
        family = 'M PLUS 1 Code',
        weight = 'Medium',
        scale = 0.92
    },
})
M.font_size = 11.5

-- Padding
M.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Maximize window
wezterm.on('gui-startup', function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- Window decorations
M.window_decorations = 'RESIZE'

-- Colors
M.colors = {
    ansi = {
        "#0D0015",
        "#EE827C",
        "#93CA76",
        "#F8B862",
        "#84A2D4",
        "#A59ACA",
        "#84B9CB",
        "#9EA1A3",
    },
    brights = {
        "#474A4D",
        "#EEBBCB",
        "#C1D8AC",
        "#F8E58C",
        "#A0D8EF",
        "#DBD0E6",
        "#A2D7DD",
        "#F8FBF8",
    },
    foreground = "#F8FBF8",
    background = "#0D0015",
    cursor_bg = "rgba(50% 50% 50% 50%)",
    cursor_fg = "rgba(0 0 0 0)"
}

-- Tab
M.enable_tab_bar = false
M.tab_bar_at_bottom = false
M.use_fancy_tab_bar = false
M.show_new_tab_button_in_tab_bar = false

-- Scroll
M.enable_scroll_bar = false
M.scrollback_lines = 10000

-- Shell
M.default_prog = { 'pwsh', '-nologo' }

-- Background
M.window_background_opacity = 0.75

-- Key binding
M.keys = {}
table.insert(M.keys, {
    key = 'p',
    mods = 'ALT',
    action = wezterm.action.PasteFrom('Clipboard'),
})
table.insert(M.keys, {
    key = 'y',
    mods = 'ALT',
    action = wezterm.action.CopyTo('Clipboard'),
})
table.insert(M.keys, {
    key = 'f',
    mods = 'ALT',
    action = wezterm.action.ToggleFullScreen
})
table.insert(M.keys, {
    key = 't',
    mods = 'ALT',
    action = wezterm.action.PromptInputLine({
        description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window,_,line)
            if line then
                window:active_tab():set_title(line)
            end
        end),
    }),
})
table.insert(M.keys, {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action.CloseCurrentTab({confirm = false}),
})
table.insert(M.keys, {
    key = 'n',
    mods = 'ALT',
    action = wezterm.action.SpawnTab('CurrentPaneDomain'),
})
table.insert(M.keys, {
    key = 'h',
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(-1),
})
table.insert(M.keys, {
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ActivateTabRelative(1),
})
table.insert(M.keys, {
    key = 'h',
    mods = 'SHIFT|ALT',
    action = wezterm.action.MoveTabRelative(-1),
})
table.insert(M.keys, {
    key = 'l',
    mods = 'SHIFT|ALT',
    action = wezterm.action.MoveTabRelative(1),
})
table.insert(M.keys, {
    key = 'b',
    mods = 'ALT',
    action = wezterm.action_callback(function(window,_)
        local overrides = window:get_config_overrides() or {}
        overrides.enable_tab_bar = not overrides.enable_tab_bar
        window:set_config_overrides(overrides)
    end),
})

return M
