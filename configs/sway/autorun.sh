#!/usr/bin/env bash
run() {
	local delay="0.1s"
	if [[ "$1" =~ ^[0-9\.]+[smhd]?$ ]]; then
		delay=$1; shift
	fi
	if ! pidof $1 >/dev/null; then
		(sleep $delay && exec $@) &
	fi
}

run mako
run 1 seafile-applet
