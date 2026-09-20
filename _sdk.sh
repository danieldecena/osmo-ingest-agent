#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "=== Final Cut still running? ==="
pgrep -x "Final Cut Pro" >/dev/null && echo "  RUNNING" || echo "  quit — safe to write prefs"
echo
echo "=== Workflow Extension SDK installed anywhere? ==="
for p in /Library/Frameworks/ProExtension.framework \
         "$HOME/Library/Frameworks/ProExtension.framework" \
         /Library/Developer/Xcode/Templates \
         "$HOME/Library/Developer/Xcode/Templates"; do
  [ -e "$p" ] && echo "  FOUND: $p" || echo "  absent: $p"
done
echo "--- any ProExtension anywhere:"
find /Library /Applications "$HOME/Library/Developer" -maxdepth 5 -iname "*ProExtension*" 2>/dev/null | head -5 || true
echo "--- xcode templates for final cut:"
find "$HOME/Library/Developer/Xcode/Templates" /Library/Developer/Xcode/Templates -iname "*Final Cut*" -o -iname "*Workflow*" 2>/dev/null | head -5 || true
echo
echo "=== the pref, as it stands ==="
P="$HOME/Library/Containers/com.apple.FinalCutApp/Data/Library/Preferences/com.apple.FinalCutApp.plist"
echo "  FFImportCopyToMediaFolder = $(defaults read "$P" FFImportCopyToMediaFolder 2>/dev/null)"
echo
echo "=== how big is the duplication so far? ==="
du -sh "$HOME/Content.fcpbundle" 2>/dev/null
find "$HOME/Content.fcpbundle" -name "*.MP4" 2>/dev/null | wc -l | xargs echo "  media files copied into the library:"
