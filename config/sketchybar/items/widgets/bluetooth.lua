-- items/widgets/bluetooth.lua

local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

-- Helper function to trim whitespace from shell command output
local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- Try to find an absolute path to blueutil (SketchyBar often has a minimal PATH)
local function find_blueutil()
    -- Try which first
    local which_file = io.popen("/usr/bin/which blueutil 2>/dev/null")
    if which_file then
        local which_path = trim(which_file:read("*a") or "")
        which_file:close()
        if which_path ~= "" then return which_path end
    end

    -- Common Homebrew locations
    local candidates = {
        "/opt/homebrew/bin/blueutil", -- Apple Silicon
        "/usr/local/bin/blueutil"      -- Intel
    }
    for _, path in ipairs(candidates) do
        local f = io.open(path, "r")
        if f then f:close(); return path end
    end

    -- Fallback to assuming it's on PATH
    return "blueutil"
end

local BLUEUTIL = find_blueutil()

-- Function to get Bluetooth status from blueutil (sync helper)
local function get_bluetooth_status()
    local file = io.popen(BLUEUTIL .. " --power 2>/dev/null")
    local result = file:read("*a")
    file:close()
    return trim(result) == "1"
end

-- Create the Bluetooth item
local bluetooth_widget = sbar.add("item", "bluetooth", {
    position = "right",
    icon = {
        font = {
            family = settings.font.text,
            style = "Bold"
        },
        string = ""
    },
    label = {
        string = "",
        padding_left = 0
    },
    updates = "when_shown"
})

-- Background around the Bluetooth item (matching other widgets)
local bluetooth_bracket = sbar.add("bracket", "widgets.bluetooth.bracket", {bluetooth_widget.name}, {
    background = {
        color = colors.bg1,
        border_color = colors.rainbow[#colors.rainbow - 4],
        border_width = 1
    }
})

-- Group padding after the Bluetooth bracket to match spacing
sbar.add("item", {
    position = "right",
    width = settings.group_paddings
})

-- Update the widget's appearance based on status (async, uses sbar.exec)
local function update_bluetooth_status()
    sbar.exec(BLUEUTIL .. " --power 2>/dev/null", function(output)
        local is_on = trim(output) == "1"
        local color = is_on and colors.blue or colors.grey
        local label_string = is_on and "ON" or "OFF"
        bluetooth_widget:set({
            icon = { color = color },
            label = { string = label_string }
        })
    end)
end

-- Initial update
update_bluetooth_status()

-- Subscribe to clicks to toggle Bluetooth
bluetooth_widget:subscribe("mouse.clicked", function(env)
    sbar.exec(BLUEUTIL .. " --power toggle >/dev/null 2>&1", function()
        update_bluetooth_status()
    end)
end)

-- Also allow clicking anywhere on the bracket background to toggle
if bluetooth_bracket and bluetooth_bracket.name then
    bluetooth_bracket:subscribe("mouse.clicked", function(env)
        sbar.exec(BLUEUTIL .. " --power toggle >/dev/null 2>&1", function()
            update_bluetooth_status()
        end)
    end)
end