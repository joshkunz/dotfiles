function cephmount --argument vol mount_path
    set ceph_path /
    if string match -e / $vol > /dev/null
        set ceph_vol (echo $vol | cut -d/ -f1)
        set ceph_subvol (echo $vol | cut -d/ -f2-)
        set ceph_path (cephshell -- ceph fs subvolume getpath $ceph_vol $ceph_subvol)
        or return
    end
    sudo mount \
        -t ceph 10.0.0.11:6789:$ceph_path $mount_path -o fs=tank,name=fs
end
