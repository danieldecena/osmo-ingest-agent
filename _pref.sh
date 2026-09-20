#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
P="$HOME/Library/Containers/com.apple.FinalCutApp/Data/Library/Preferences/com.apple.FinalCutApp.plist"
D="com.apple.FinalCutApp"

if pgrep -x "Final Cut Pro" >/dev/null; then
  echo "REFUSED: Final Cut is still running — it would overwrite this on quit."; exit 1
fi

echo "=== before ==="
echo "  FFImportCopyToMediaFolder = $(defaults read "$P" FFImportCopyToMediaFolder 2>/dev/null)"

# back the whole plist up before touching it
B="$HOME/Movies/Footage/_agent/fcp-prefs-backup-$(date +%Y%m%dT%H%M%S).plist"
cp "$P" "$B" && echo "  backup: $B"

# the sandboxed app reads its own container domain
defaults write "$P" FFImportCopyToMediaFolder -bool false
killall cfprefsd 2>/dev/null; sleep 1

echo "=== after ==="
echo "  FFImportCopyToMediaFolder = $(defaults read "$P" FFImportCopyToMediaFolder 2>/dev/null)"
plutil -lint "$P" | sed 's/^/  /'
