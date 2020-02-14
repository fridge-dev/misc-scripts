#!/bin/sh

###
# Run any **script** asynchronously with built in logging! Runs the async command in a new process group, 
# so it won't be terminated if your SSH session ends. How cool!
#
# EXAMPLE: async.sh sleep-awake.sh
# EXAMPLE: async.sh my-script.sh -arg foo -arg2 bar
#
# Can't successfully run arbitrary shell code nor aliases asynchronously. Probably won't be motivated to
# figure it out. Work around is to create your commands in a .sh file and run that. See delayed.sh as an
# example. Example of failing alias: `async.sh ll` (alias ll='ls -l')
###

if [ $# -lt 1 ]; then
    echo "Provide some script (with optional args) to run"
    exit 1
fi

LOG=/tmp/async-helper-$(date '+%Y%m%d-%s').log

# setsid is really cool.
setsid async-log-wrapper.sh "$@" &> $LOG < /dev/null &

echo -e "\n\t> tail -f $LOG\n"
tail -f $LOG
