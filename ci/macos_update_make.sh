#!/bin/sh -x
# Updates GNU make to newest version.
# This is required on MacOs since it only provides version 3.81, which has a bug when using the ´--touch' flag.
# If the machine is not MacOs, nothing is done.
set -e

# Loads variables
. ci/config.sh

if [ $MACOS == 1 ]; then
	brew install make
	/usr/local/opt/make/libexec/gnubin/make --version
fi
