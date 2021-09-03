#!/bin/bash

if [ ! -n "$1" ];
then
	echo 'process num not specified! Usage: ./generate.sh <process_id>/all'
	redis-cli -h 10.0.0.10 info | grep process_id
	exit
elif [ "$1"x == "all"x ];
then
	echo Capturing overall stack samples...
	sudo perf record -F 99 -a -g -- sleep 10
else
	echo Capturing stack samples in process $1...
	sudo perf record -F 99 -p $1 -g -- sleep 10
fi

sudo perf script > out.perf
echo 'out.perf generated.'

./stackcollapse-perf.pl out.perf > out.folded
echo 'Samples folded.'


./flamegraph.pl out.folded > out.svg
echo 'FlameImage out.svg generated!'




