#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
P="$HOME/Library/Containers/com.apple.FinalCutApp/Data/Library/Preferences/com.apple.FinalCutApp.plist"
echo "=== app ==="
defaults read "/Applications/Final Cut Pro Creator Studio.app/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null
defaults read "/Applications/Final Cut Pro Creator Studio.app/Contents/Info.plist" CFBundleIdentifier 2>/dev/null
echo
echo "=== total prefs keys ==="
defaults read "$P" 2>/dev/null | grep -cE '^ +"?[A-Za-z0-9_.]+"? ='
echo "=== import / media / transcribe / appearance keys and values ==="
defaults read "$P" 2>/dev/null | grep -iE 'import|copy|media|transcri|proxy|optimi|analy|autosave|appearance|bright|workspace|role' | head -40
echo
echo "=== app support: workspaces / command sets ==="
for d in "$HOME/Library/Application Support/Final Cut Pro" \
         "$HOME/Library/Containers/com.apple.FinalCutApp/Data/Library/Application Support/Final Cut Pro"; do
  echo "  [$d]"; ls -1 "$d" 2>/dev/null | sed 's/^/    /' || echo "    (none)"
done
echo
echo "=== workflow extensions currently registered ==="
pluginkit -mAvvv -p com.apple.FinalCut.ProExtension 2>/dev/null | head -12 || echo "  none / not queryable"
