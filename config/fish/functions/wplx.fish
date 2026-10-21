function wplx --description "random wallpaper from ~/wallpapers-lx, right variant per screen"
    set -l dir ~/wallpapers-lx
    set -l name (path basename $dir/*-lg.jpg | string replace -r -- '-lg\.jpg$' '' | gshuf -n1)

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
        wallpaper set --screen $idx $dir/$name-$variant.jpg
    end
    echo $name
end
