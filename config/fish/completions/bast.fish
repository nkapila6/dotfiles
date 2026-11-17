function __bast_complete
    set -l args (commandline -opc)
    set -l current (commandline -ct)
    if test (count $args) -eq 0
        return
    end
    set -l bin $args[1]
    set -e args[1]
    set -l out
    if test -z "$current"
        set out (command $bin __complete -- $args '' 2>/dev/null)
    else
        set out (command $bin __complete -- $args $current 2>/dev/null)
    end
    set -l directive nofiles
    set -l values
    for line in $out
        if string match -q ':*' -- $line
            set directive (string sub -s 2 -- $line)
            continue
        end
        set -l value (string split -m 1 \t -- $line)[1]
        if test -n "$value"
            set values $values $value
        end
    end
    if test "$directive" = files
        __fish_complete_path $current
        return
    end
    if test "$directive" = dirs
        __fish_complete_directories $current
        return
    end
    for value in $values
        printf '%s\n' $value
    end
end

complete -c bast -f -a '(__bast_complete)'
