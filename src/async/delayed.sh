#!/bin/sh

###
# Script to delay execution of something. Basically equivalent to `sleep $1 && ${@:2}`,
# but needed as one script to be used by async.sh.
#
# EXAMPLE: delayed.sh 10 echo "we're all 10 seconds older"
#
# Really useful when combined with async:
# async.sh delayed.sh 3600 run-my-supertuff-script.sh
# ^ Runs `run-my-supertuff-script.sh` in 1 hour, but you can close your SSH and go to bed.
###

echo "Sleeping $1 seconds..."
sleep $1
echo "Awake!"

echo "Executing '${@:2}'"
echo
${@:2}
