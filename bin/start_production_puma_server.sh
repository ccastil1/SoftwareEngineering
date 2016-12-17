#!/bin/bash

SECRET_KEY_BASE=$(ruby -e 'require "securerandom"; print SecureRandom.hex(64) + "\n"')
export SECRET_KEY_BASE

usage() {
    cat <<EOF
usage: ./start_production_puma_server.sh [-he]

    -e  environment (production, file_node)
EOF
}

start_server() {
    bundle exec puma -b \
        'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/puma.sock' \
        -e "$ENVIRONMENT" --control \
        'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/pumactl.sock' \
        -S /home/ubuntu/apps/se_filesystem/shared/tmp/pids/puma.state
}

while getopts "he:" arg; do
    case $arg in
        h) usage  && exit 0;;
        e) ENVIRONMENT=$OPTARG ;;
        *) usage ;;
    esac
done

if [[ "$ENVIRONMENT" == "" ]]; then
    usage
    exit 1
else
    start_server
fi
