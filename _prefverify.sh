#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
P="$HOME/Library/Containers/com.apple.FinalCutApp/Data/Library/Preferences/com.apple.FinalCutApp.plist"
say(){ echo "  $*"; }

echo "=== value written, before FCP has seen it ==="
say "FFImportCopyToMediaFolder = $(defaults read "$P" FFImportCopyToMediaFolder 2>/dev/null)"

echo "=== launching Final Cut ==="
open -a "Final Cut Pro Creator Studio" 2>/dev/null
for i in $(seq 1 45); do
  pgrep -x "Final Cut Pro" >/dev/null && break
  sleep 1
done
pgrep -x "Final Cut Pro" >/dev/null || { echo "  did not start"; exit 1; }
say "running (pid $(pgrep -x 'Final Cut Pro'))"
sleep 12   # let it finish reading prefs and settle

echo "=== quitting it again ==="
osascript -e 'tell application "Final Cut Pro Creator Studio" to quit' 2>/dev/null
for i in $(seq 1 40); do
  pgrep -x "Final Cut Pro" >/dev/null || break
  sleep 1
done
pgrep -x "Final Cut Pro" >/dev/null && { echo "  still running — quit did not complete"; exit 1; }
say "quit cleanly"
sleep 2

echo "=== the value AFTER Final Cut rewrote its own preferences ==="
V=$(defaults read "$P" FFImportCopyToMediaFolder 2>/dev/null)
say "FFImportCopyToMediaFolder = $V"
[ "$V" = "0" ] && echo "  STUCK — Final Cut kept it" || echo "  REVERTED — Final Cut overwrote it"
