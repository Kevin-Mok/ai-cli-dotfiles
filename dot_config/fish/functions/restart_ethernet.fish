function restart_ethernet --description 'Restart a NetworkManager ethernet connection'
    set -l connection_name netplan-enp42s0

    if test (count $argv) -ge 1
        set connection_name $argv[1]
    end

    if not command -sq nmcli
        echo "restart_ethernet: nmcli is not installed" >&2
        return 127
    end

    sudo nmcli connection down "$connection_name"
    or return $status

    sudo nmcli connection up "$connection_name"
end
