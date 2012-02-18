#!/bin/sh
###############################################################################
#
## LIFLG Startup Script
#
# Copyright (C) 2004-2010  Team LIFLG http://www.liflg.org/
#
#
# This script is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
###############################################################################
#
# The game binary
GAME_BINARY="shogosrv"

# Subdirectory
SUBDIR="."

# Library directory
LIBDIR="lib/"

# Additional commandline options for mods etc.
CMD_ARGS=""

# Directory for Loki-Compat libs
LOKICOMPATDIR="Loki_Compat"

# Prevent failures with hardware acceleration
# only for use with Loki-Compat libs
#DISABLE_SDL_VIDEO_YUV_HWACCEL="true"

# http://www.libsdl.org/faq.php?action=listentries&category=3#32
#ENABLE_SDL_DSP_NOSELECT ="true"

# Set the sdl audio driver (default: oss)
# More at http://icculus.org/lgfaq/#setthatdriver
#SDL_AUDIODRIVER="alsa"

# Use US keyboard layout
#USLAYOUT="true"

# Set gamma for the game
#GAMMA="1.000"

###############################################################################
## DO NOT EDIT BELOW THIS LINE
###############################################################################
export LANG="POSIX"

test -n "${SDL_AUDIODRIVER}" && export SDL_AUDIODRIVER

# readlink replacement for older bash versions
readlink() {
	path=$1
 
	if [ -L "$path" ]
	then
		ls -l "$path" | sed 's/^.*-> //'
	else
		return 1
	fi
}

setuslayout() {
	setxkbmap -model pc101 us -print | xkbcomp - ${DISPLAY} 2>/dev/null
}
trap setxkbmap EXIT

resetgamma() {
	if [ -n "${XGAMMA}" ]
	then
		exec ${XGAMMA}
	fi
}
trap resetgamma EXIT

SCRIPT="$0"
SCRIPTDIR=$(dirname "${0}")
COUNT=0
while [ -L "${SCRIPT}" ]
do
	SCRIPT=$(readlink ${SCRIPT})
	COUNT=$(expr ${COUNT} + 1)
	if [ ${COUNT} -gt 100 ]
	then
		echo "Too many symbolic links"
		exit 1
	fi
done
GAMEDIR=$(dirname "${SCRIPT}")

#games are better played with us keyboard layout
if [ "${USLAYOUT}" = "true" ]; then
	setuslayout
fi

# save gamma value and set wanted
if [ -n "${GAMMA}" ]; then
	XGAMMA=$(xgamma 2>&1 | sed -e "s/.*Red \(.*\), Green \(.*\), Blue \(.*\)/xgamma -rgamma\1 -ggamma\2 -bgamma\3/")
	xgamma -gamma ${GAMMA}
fi

if [ "x${SCRIPTDIR}" != "x${GAMEDIR}" ]
then
	cd "${SCRIPTDIR}"
fi

cd "${GAMEDIR}"
cd "${SUBDIR}"

# export game library directory
test -n "${LIBDIR}" && export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${LIBDIR}"

# start the game

if [ "${ENABLE_SDL_DSP_NOSELECT}" = "true" ]
then
	export SDL_DSP_NOSELECT=1
fi

	
if [ "${DISABLE_SDL_VIDEO_YUV_HWACCEL}" = "true" ]
then
	export SDL_VIDEO_YUV_HWACCEL=0
fi

#detect if loki-compat libs are installed
if [ -d "$LOKICOMPATDIR" ]
then
	echo "Running WITH lokicompat libs!"
	LD_LIBRARY_PATH="$LOKICOMPATDIR" "$LOKICOMPATDIR"/ld-linux.so.2 ./${GAME_BINARY} ${CMD_ARGS} "$@"
else
	./${GAME_BINARY} ${CMD_ARGS} "$@"
fi

EXITCODE="$?"

if [ "${USLAYOUT}" = "true" ]; then
	# reset kb layout
	setxkbmap >/dev/null 2>&1

	# reset xmodmap
	test -r ${HOME}/.Xmodmap && xmodmap ${HOME}/.Xmodmap >/dev/null 2>&1
fi

# reset gamma - which is done by the trap call - see line 83

exit ${EXITCODE}
