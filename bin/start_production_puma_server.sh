#!/bin/sh

export SECRET_KEY_BASE=$(ruby -e 'require "securerandom"; print SecureRandom.hex(64) + "\n"')
bundle exec puma -b \
	'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/puma.sock' \
	-e production --control \
	'unix:///home/ubuntu/apps/se_filesystem/shared/tmp/sockets/pumactl.sock' \
	-S /home/ubuntu/apps/se_filesystem/shared/tmp/pids/puma.state
