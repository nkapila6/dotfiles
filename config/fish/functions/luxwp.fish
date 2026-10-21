function luxwp --description "set a luxtron wallpaper on every screen, cropped per screen"
    # luxwp [corner] [name], e.g. luxwp bottom-left corridor. no args = random
    set -l dir ~/Downloads/luxtron-backgrounds/screens
    set -l corner $argv[1]
    set -l name $argv[2]
    test -n "$corner"; or set corner (path basename $dir/* | gshuf -n1)
    test -n "$name"; or set name (path basename $dir/$corner/*-lg.jpg | string replace -r '^luxtron-|-lg\.jpg$' '' | gshuf -n1)

    # screen indices shift when displays get plugged in, so go by name
    for line in (wallpaper screens)
        set -l idx (string split -m1 ' - ' $line)[1]
        set -l screen (string split -m1 ' - ' $line)[2]
        set -l variant lg
        switch $screen
            case 'Built-in*'
                set variant macbook
            case 'BenQ*'
                set variant benq
        end
        wallpaper set --screen $idx $dir/$corner/luxtron-$name-$variant.jpg
    end
    echo "$corner $name"
end
