#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
S="$HOME/Library/Containers/com.decena.FootageBoard.Extension/Data/Library/Application Support/board-status.txt"
rm -f "$S"
pkill -f FootageBoardExtension 2>/dev/null; sleep 2
osascript -e 'tell application "System Events" to tell process "Final Cut Pro"
  set frontmost to true
  delay 1
  click menu item "FootageBoardExtension" of menu 1 of menu item "Extensions" of menu 1 of menu bar item "Window" of menu bar 1
end tell' >/dev/null 2>&1
sleep 10
echo "=== extension process ==="
pgrep -f FootageBoardExtension >/dev/null && echo "  running" || echo "  NOT running"
echo "=== what the extension says about its host ==="
if [ -f "$S" ]; then cat "$S" | sed 's/^/  /'; else echo "  (no status file written)"; fi
echo "=== crash? ==="
ls -t "$HOME/Library/Logs/DiagnosticReports"/FootageBoardExtension*.ips 2>/dev/null | head -1 | sed 's/^/  /' || echo "  none"
