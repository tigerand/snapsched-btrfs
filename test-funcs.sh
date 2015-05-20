#!/bin/bash

. ~/lib/snapsched/snapsched-funcs

ETCDIR=~/lib/snapsched
CFGFILE=$ETCDIR/test-config
CRONTAB=$ETCDIR/test-snapsched

TESTFUNCs="$1"
shift

for F in $TESTFUNCs ; do
	echo "testing func: '$F'"
	echo
	case $F in
		add_source)
			SSCHED_UBER=y
			eval ssched_$F flartabartblast 0 0 0 0 mysql || echo failure! && echo success!
			eval ssched_$F root_14.04_20140616/ 0 0 0 0 mysql || echo failure! && echo success!
			;;
		*)
			if [ ${F#_} != "$F" ] ; then
				$F "$@" || echo failure!
			else
				eval ssched_$F "$@" || echo failure!
			fi
			;;
	esac
	echo
done
