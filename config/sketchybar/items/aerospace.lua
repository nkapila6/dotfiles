-- Helper function to trim leading/trailing whitespace and newlines
function trim(s)
    return s:match("^%s*(.-)%s*$")
end

-- ... (all your existing functions like dump, explode, etc. are fine as they are) ...

function parse_string_to_table(s)
    local result = {}
    for line in s:gmatch("([^\n]+)") do
        table.insert(result, trim(line)) -- Trim each line
    end
    return result
end

function get_workspaces()
    local file = io.popen("aerospace list-workspaces --all")
    local result = file:read("*a")
    file:close()
    return parse_string_to_table(result)
end

function get_current_workspace()
    local file = io.popen("aerospace list-workspaces --focused")
    local result = file:read("*a")
    file:close()
    local parsed = parse_string_to_table(result)
    return parsed[1] -- The trimming is already done inside parse_string_to_table
end

function get_monitors()
    local file = io.popen("aerospace list-monitors | awk '{print $1}'")
    local result = file:read("*a")
    file:close()
    return parse_string_to_table(result)
end

function get_workspaces_on_monitor(monitor)
    local file = io.popen("aerospace list-workspaces --monitor " .. monitor)
    local result = file:read("*a")
    file:close()
    return parse_string_to_table(result) -- The trimming is already done here
end

function get_visible_workspace_on_monitor(monitor)
    local file = io.popen("aerospace list-workspaces --monitor " .. monitor .. " --visible")
    local result = file:read("*a")
    file:close()
    local parsed = parse_string_to_table(result)
    return parsed[1] -- The trimming is already done
end

function is_workspace_selected(workspace)
    local available_monitors = get_monitors()
    for _, monitor in ipairs(available_monitors) do
        local visible_workspace = get_visible_workspace_on_monitor(monitor)
        if visible_workspace == workspace then
            return true
        end
    end
    return false
end