function ocsesh --description "List and resume OpenCode sessions"
    set -l db ~/.local/share/opencode/opencode.db
    set -l sessions (sqlite3 -separator '|' $db \
        "SELECT id, title, directory FROM session ORDER BY time_updated DESC;")

    if test (count $sessions) -eq 0
        echo "No sessions found."
        return
    end

    # Print numbered table
    printf "%-3s  %-32s  %-45s  %s\n" "#" "SESSION ID" "TITLE" "PATH"
    printf "%s\n" (string repeat --count 120 '=')
    set -l ids
    for i in (seq (count $sessions))
        set -l parts (string split '|' -- $sessions[$i])
        set -l sid $parts[1]
        set -l title $parts[2]
        set -l path $parts[3]
        set ids $ids $sid
        # Truncate title and path for display
        test (string length -- $title) -gt 45; and set title (string sub --length 42 -- $title)"..."
        test (string length -- $path) -gt 35; and set path (string sub --length 32 -- $path)"..."
        printf "%-3d  %-32s  %-45s  %s\n" $i $sid $title $path
    end

    # If an argument is given, resume that session
    if set -q argv[1]
        if test $argv[1] -ge 1 -a $argv[1] -le (count $ids)
            set -l sid $ids[$argv[1]]
            echo ""
            echo "Resuming session $sid..."
            opencode -s $sid
        else
            echo "Invalid number: $argv[1] (must be 1-"(count $ids)")"
            return 1
        end
    end
end