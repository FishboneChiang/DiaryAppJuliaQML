#!/bin/bash
# End all QML processes
pkill julia

# new QML process
julia "$1" &

# Check if QML is ready
while true; do
    window_exists=$(osascript -e 'tell application "System Events" to exists (window 1 of (processes where name is "qml"))')
    if [ "$window_exists" = "true" ]; then
        break
    fi
    # sleep 0.1
done

# Focus on Visual Studio Code
osascript -e 'tell application "Visual Studio Code" to activate'