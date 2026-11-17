-- AeroSpace keybinds ported from nkapila6/dotfiles config/aerospace/aerospace.toml
-- macOS `alt` -> SUPER. Displaced CachyOS binds moved to SUPER+CONTROL (see binds.lua).

local mainMod = "SUPER"
local noctCall = "noctalia msg "

-- Monitors. desc: matches a prefix of the description from `hyprctl monitors`.
-- The external ones are guesses: check them with `hyprctl monitors` once plugged in.
local MON_BUILTIN = "eDP-1"
local MON_LG      = "desc:LG Electronics LG FHD"
local MON_BENQ    = "desc:BNQ BenQ GW2490T"

-- key -> workspace. Letters get the IDs after the numbers (A = 5, B = 6, ...) with the
-- letter as display name, so bars that sort by ID show 1-4 first. (name:A would get a
-- negative ID and sort before 1.)
local workspaces = { "1", "2", "3", "4", "A", "B", "D", "O", "P", "S", "T", "V" }
local wsId = {}
for i, name in ipairs(workspaces) do wsId[name] = i end

local function ws(name)
    return wsId[name]
end

-- AZERTY-safe digit binding, same trick as binds.lua
local function key(name)
    local d = tonumber(name)
    if d then return "code:" .. (d == 0 and 19 or (9 + d)) end
    return name
end

-- Run several dispatchers from one key, then leave the submap
local function andReset(...)
    local dsps = { ... }
    return function()
        for _, d in ipairs(dsps) do hl.dispatch(d) end
        hl.dispatch(hl.dsp.submap("reset"))
    end
end

------------------
---- SETTINGS ----
------------------

-- gaps 0, like aerospace [gaps]
hl.config({ general = { gaps_in = 0, gaps_out = 0 } })

-- focus h/l walks through a group's tabs before leaving it, like aerospace accordion
hl.config({ binds = { movefocus_cycles_groupfirst = true } })

-- persistent-workspaces + workspace-to-monitor-force-assignment
for _, name in ipairs(workspaces) do
    hl.workspace_rule({ workspace = tostring(ws(name)), default_name = name, persistent = true })
end
-- default_name isn't applied to persistent workspaces, so rename them ourselves
local function applyNames()
    for _, w in ipairs(hl.get_workspaces()) do
        local name = workspaces[w.id]
        if name and w.name ~= name then
            hl.dispatch(hl.dsp.workspace.rename({ workspace = w.id, name = name }))
        end
    end
end
hl.on("hyprland.start",    applyNames)
hl.on("config.reloaded",   applyNames)
hl.on("workspace.created", applyNames)

hl.workspace_rule({ workspace = tostring(ws("1")), monitor = MON_LG,      default = true })
hl.workspace_rule({ workspace = tostring(ws("O")), monitor = MON_BUILTIN, default = true })
hl.workspace_rule({ workspace = tostring(ws("P")), monitor = MON_BENQ,    default = true })

------------------------
---- MAIN BINDINGS ----
------------------------

-- Layout: tiles orientation -> dwindle togglesplit, accordion -> group (tabbed)
hl.bind(mainMod .. " + slash", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + comma", hl.dsp.group.toggle())

-- Focus / move (hyprland crosses monitors by default, like --boundaries all-monitors-outer-frame)
local dirs = { H = "l", J = "d", K = "u", L = "r" }
for k, d in pairs(dirs) do
    hl.bind(mainMod .. " + " .. k,             hl.dsp.focus({ direction = d }))
    hl.bind(mainMod .. " + SHIFT + " .. k,     hl.dsp.window.move({ direction = d }))
end

-- Resize (aerospace "resize smart")
hl.bind(mainMod .. " + Minus", hl.dsp.window.resize({ x = -50, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + Equal", hl.dsp.window.resize({ x = 50,  y = 50,  relative = true }), { repeating = true })

-- Workspaces: switch, and move window + follow
for _, name in ipairs(workspaces) do
    hl.bind(mainMod .. " + " .. key(name),         hl.dsp.focus({ workspace = ws(name) }))
    hl.bind(mainMod .. " + SHIFT + " .. key(name), hl.dsp.window.move({ workspace = ws(name) }))
end

-- alt-0 screencapture -i -c
hl.bind(mainMod .. " + " .. key("0"), hl.dsp.exec_cmd(noctCall .. "screenshot-region"))

-- alt-shift-w wallpaper script -> noctalia wallpaper panel, already SUPER+SHIFT+W in binds.lua

hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())

-- Monitors
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.workspace.move({ monitor = "+1" }))
hl.bind(mainMod .. " + U",           hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + I",           hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + U",   hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + I",   hl.dsp.workspace.move({ monitor = "r" }))

-- Modes
hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.submap("service"))

----------------------
---- SERVICE MODE ----
----------------------

-- Per-workspace layout switch: a runtime workspace rule, replacing the previous one.
-- Lasts until the config is reloaded.
local layoutRules = {}
local function setLayout(layout)
    return function()
        local w = hl.get_active_workspace()
        if w then
            if layoutRules[w.id] then layoutRules[w.id]:set_enabled(false) end
            -- the new rule drops persistence unless repeated here
            layoutRules[w.id] = hl.workspace_rule({
                workspace = tostring(w.id), layout = layout, persistent = workspaces[w.id] ~= nil,
            })
            hl.dispatch(hl.dsp.exec_cmd("notify-send -t 1500 'Layout' '" .. w.name .. ": " .. layout .. "'"))
        end
        hl.dispatch(hl.dsp.submap("reset"))
    end
end

hl.define_submap("service", function()
    hl.bind(key("1"), setLayout("dwindle"))
    hl.bind(key("2"), setLayout("master"))
    hl.bind(key("3"), setLayout("scrolling"))
    hl.bind(key("4"), setLayout("monocle"))

    hl.bind("escape", function()
        hl.dispatch(hl.dsp.submap("reset"))
        hl.dispatch(hl.dsp.exec_cmd("hyprctl reload"))
    end)
    -- r (flatten-workspace-tree) has no hyprland equivalent, skipped
    hl.bind("T", hl.dsp.submap("tuios"))
    hl.bind("P", hl.dsp.submap("passthrough")) -- manual entry; aerospace did this automatically for Parallels
    hl.bind("F", andReset(hl.dsp.window.float({ action = "toggle" })))

    -- close-all-windows-but-current
    hl.bind("BackSpace", function()
        local active = hl.get_active_window()
        if active and active.workspace then
            for _, w in ipairs(hl.get_workspace_windows(active.workspace)) do
                if w.address ~= active.address then
                    hl.dispatch(hl.dsp.window.close({ window = w }))
                end
            end
        end
        hl.dispatch(hl.dsp.submap("reset"))
    end)

    -- join-with -> move into (or create) a group in that direction
    for k, d in pairs(dirs) do
        hl.bind(mainMod .. " + SHIFT + " .. k, andReset(hl.dsp.window.move({ into_or_create_group = d })))
    end

    hl.bind("Down",         hl.dsp.exec_cmd(noctCall .. "volume-down"), { repeating = true })
    hl.bind("Up",           hl.dsp.exec_cmd(noctCall .. "volume-up"),   { repeating = true })
    hl.bind("SHIFT + Down", andReset(hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0")))
end)

-- Passthrough: nothing bound except the exit key, so everything reaches the app
hl.define_submap("passthrough", function()
    hl.bind("CONTROL + escape", hl.dsp.submap("reset"))
end)

-- tuios: only the exit key is bound, so SUPER-* reaches tuios
hl.define_submap("tuios", function()
    hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.submap("reset"))
end)

----------------------
---- WINDOW RULES ----
----------------------

-- on-window-detected move-node-to-workspace (aerospace doesn't follow, hence silent)
hl.window_rule({ match = { class = "^(kitty|com\\.mitchellh\\.ghostty)$" }, workspace = ws("T") .. " silent" })
hl.window_rule({ match = { class = "^([Dd]iscord|vesktop)$" },             workspace = ws("D") .. " silent" })
hl.window_rule({ match = { class = "^([Bb]eeper)$" },                      workspace = ws("B") .. " silent" })

-- layout floating
hl.window_rule({ match = { class = "^(org\\.kde\\.dolphin)$" },                                     float = true })
hl.window_rule({ match = { class = "^(com\\.rtosta\\.zapzap|whatsapp.*|WhatsApp.*)$" },             float = true })
hl.window_rule({ match = { class = "^(com\\.github\\.th-ch\\.youtube-music|YouTube Music)$" },      float = true })
