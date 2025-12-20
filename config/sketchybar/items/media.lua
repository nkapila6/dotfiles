local icons = require("icons")
local colors = require("colors")

-- Toggle to show/hide album artwork while keeping popup functionality
local SHOW_ALBUM_ART = false

-- not being used
-- local whitelist = {
--     ["Spotify"] = true,
--     ["Music"] = true,
--     ["YouTube Music"] = true
-- };

local media_cover = sbar.add("item", {
    position = "right",
    background = {
        image = {
            string = "media.artwork",
            scale = 0.85
        },
        color = colors.transparent
    },
    label = {
        drawing = false
    },
    icon = {
        drawing = false
    },
    drawing = false,
    updates = true,
    popup = {
        align = "center",
        horizontal = true
    }
})

local media_artist = sbar.add("item", {
    position = "right",
    drawing = true,
    padding_left = 3,
    padding_right = 0,
    width = 0,
    icon = {
        drawing = false
    },
    label = {
        width = "dynamic",
        font = {
            size = 9
        },
        color = colors.with_alpha(colors.white, 0.6),
        max_chars = 18,
        y_offset = 6,
        string = "No media"
    }
})

local media_title = sbar.add("item", {
    position = "right",
    drawing = true,
    padding_left = 3,
    padding_right = 0,
    icon = {
        drawing = false
    },
    label = {
        font = {
            size = 11
        },
        width = "dynamic",
        max_chars = 16,
        y_offset = -5
    }
})

sbar.add("item", {
    position = "popup." .. media_cover.name,
    icon = {
        string = icons.media.back
    },
    label = {
        drawing = false
    },
    click_script = "media-control send 5"
})
sbar.add("item", {
    position = "popup." .. media_cover.name,
    icon = {
        string = icons.media.play_pause
    },
    label = {
        drawing = false
    },
    click_script = "media-control send 2"
})
sbar.add("item", {
    position = "popup." .. media_cover.name,
    icon = {
        string = icons.media.forward
    },
    label = {
        drawing = false
    },
    click_script = "media-control send 4"
})

local interrupt = 0
local function animate_detail(detail)
    if (not detail) then
        interrupt = interrupt - 1
    end
    if interrupt > 0 and (not detail) then
        return
    end

    sbar.animate("tanh", 30, function()
        media_artist:set({
            label = {
                width = detail and "dynamic" or 0
            }
        })
        media_title:set({
            label = {
                width = detail and "dynamic" or 0
            }
        })
    end)
end

media_cover:subscribe("media_change", function(env)
    -- if whitelist[env.INFO.app] then
    local playing = (env.INFO.state == "playing")
    local artist = env.INFO.artist or ""
    local title = env.INFO.title or ""

    if playing then
        media_artist:set({ drawing = true, label = (artist ~= "" and artist or "No media") })
        media_title:set({ drawing = true, label = title })
        media_cover:set({ drawing = SHOW_ALBUM_ART })
        animate_detail(true)
        interrupt = interrupt + 1
        sbar.delay(5, animate_detail)
    else
        media_artist:set({ drawing = true, label = "No media" })
        media_title:set({ drawing = true, label = "" })
        media_cover:set({ drawing = false })
        media_cover:set({ popup = { drawing = false } })
        interrupt = 0
        animate_detail(false)
    end
    -- end
end)

media_cover:subscribe("mouse.entered", function(env)
    interrupt = interrupt + 1
    animate_detail(true)
end)

media_cover:subscribe("mouse.exited", function(env)
    animate_detail(false)
end)

media_cover:subscribe("mouse.clicked", function(env)
    media_cover:set({
        popup = {
            drawing = "toggle"
        }
    })
end)

media_artist:subscribe("mouse.clicked", function(env)
    media_cover:set({
        popup = {
            drawing = "toggle"
        }
    })
end)

media_title:subscribe("mouse.clicked", function(env)
    media_cover:set({
        popup = {
            drawing = "toggle"
        }
    })
end)

media_title:subscribe("mouse.exited.global", function(env)
    media_cover:set({
        popup = {
            drawing = false
        }
    })
end)

-- media-control integration (polling fallback for newer macOS)
local function split_lines(str)
    local t = {}
    for line in string.gmatch(str or "", "([^\n]+)") do
        table.insert(t, line)
    end
    return t
end

local function poll_media_control()
    local cmd = [[media-control get --now | jq -r 'if .==null then "null" else (.title//""),(.artist//""),(.playing|tostring),(.bundleIdentifier//"") end']]
    sbar.exec(cmd, function(output)
        local lines = split_lines(output)
        if #lines == 0 or lines[1] == "null" then
            media_artist:set({ drawing = true, label = "No media" })
            media_title:set({ drawing = true, label = "" })
            media_cover:set({ drawing = false, popup = { drawing = false } })
            sbar.delay(1.0, poll_media_control)
            return
        end

        local title = lines[1] or ""
        local artist = lines[2] or ""
        local playing_str = lines[3] or "false"
        local playing = (playing_str == "true")

        if playing then
            media_artist:set({ drawing = true, label = (artist ~= "" and artist or "No media") })
            media_title:set({ drawing = true, label = title })
            media_cover:set({ drawing = SHOW_ALBUM_ART })
            animate_detail(true)
            interrupt = interrupt + 1
            -- sbar.delay(5, animate_detail)
        else
            media_artist:set({ drawing = true, label = "No media" })
            media_title:set({ drawing = true, label = "" })
            media_cover:set({ drawing = false, popup = { drawing = false } })
            interrupt = 0
            animate_detail(false)
        end

        sbar.delay(1.0, poll_media_control)
    end)
end

-- Start polling loop (non-blocking)
poll_media_control()
