function backup-phone-storage
    set remote_rsync /data/data/com.termux/files/usr/bin/rsync

    if not ssh -p 8022 $PHONE_IP "test -x $remote_rsync"
        echo "backup-phone-storage: remote rsync is missing at $remote_rsync" >&2
        echo "backup-phone-storage: install it in Termux with: pkg install rsync" >&2
        return 1
    end

    echo "backup-phone-storage: rsync shows ETA plus xfr#/to-chk counters for completed and remaining items"

    rsync -L --no-inc-recursive \
        --info=progress2,name1,stats2 --human-readable --stats \
        --rsync-path="$remote_rsync" \
        -rave 'ssh -p 8022' \
        $PHONE_IP:/data/data/com.termux/files/home/storage/ \
        /mnt/linux-files-3/pixel-9
end
