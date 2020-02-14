#!/bin/sh

# This script just used for testing. Like:
# ./async.sh sleep-awake.sh -a b -c d

echo "inside $0. We are pid $$. Our args were '$@'"
for i in {1..30}; do
    sleep 1
    echo "Awake $i"
done
echo "exiting $0"
