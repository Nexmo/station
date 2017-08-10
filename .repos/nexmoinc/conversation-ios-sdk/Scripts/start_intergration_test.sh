#!/bin/sh

# Check if WebSocket service is running
if [[ ! $(pgrep -f mocket-io.py) ]]; then
    echo "Starting intergration test script..."

    cd mocket-io
    sh start.sh > /dev/null 2>&1 &

    echo "Started intergration test script"
else 
	echo "Intergration test already running"
fi
