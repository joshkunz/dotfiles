function beets-shell
    docker run --rm -it \
        -v /tank/music/library:/tank/music \
        -v /tank/music/db:/data \
        -v /tank/music-import:/import \
        --entrypoint /usr/bin/fish \
        --group-add sudo \
        us-docker.pkg.dev/jkz-hub/yggdrasil/beets:latest
end
