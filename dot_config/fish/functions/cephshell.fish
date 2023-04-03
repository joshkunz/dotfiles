function cephshell
    sudo cephadm \
        --image quay.io/ceph/ceph:v16 \
        shell \
        --fsid e6849e6e-4ab7-11ed-83fb-ac1f6b7737d2 \
        --config /etc/ceph/ceph.conf \
        --keyring /etc/ceph/ceph.client.admin.keyring \
        $argv
end
