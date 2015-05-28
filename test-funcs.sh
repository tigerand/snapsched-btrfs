#!/bin/bash

. ./snapsched-funcs

ETC=testdir/etc
ETCDIR=$ETC/snapsched
CFGFILE=$ETC/test-config
CRONTAB=$ETC/test-snapsched


mkdir -p $ETCDIR
mkdir -p $ETC/cron.{dai,hour,month,week}ly

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
#set -x
				eval ssched_$F "$@" || echo failure!
			fi
			;;
	esac
	echo
done
