#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
osascript -e 'tell application "Final Cut Pro Creator Studio" to quit' 2>/dev/null
for i in $(seq 1 30); do pgrep -x "Final Cut Pro" >/dev/null || break; sleep 1; done
bash "$HOME/Movies/Footage/_agent/_build.sh" 2>&1 | grep -E "BUILD|error:"
bash "$HOME/Movies/Footage/_agent/_install.sh" 2>&1 | grep -E "signature: valid|copied to"
open -a "Final Cut Pro Creator Studio"
for i in $(seq 1 60); do pgrep -x "Final Cut Pro" >/dev/null && break; sleep 1; done
sleep 16
echo "relaunched"
