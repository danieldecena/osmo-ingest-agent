#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
C="$HOME/Library/Containers/com.apple.FinalCut/Data/Library"
echo "=== sandbox container present? ==="
ls -d "$C" 2>/dev/null || echo "  not found"
echo
echo "=== prefs in container ==="
ls -l "$C/Preferences/" 2>/dev/null | head
echo
echo "=== key names ==="
defaults read "$C/Preferences/com.apple.FinalCut.plist" 2>/dev/null \
  | grep -oE '^ +"?[A-Za-z0-9_.]+"? =' | tr -d ' ="' | sort > /tmp/fcpkeys.txt
wc -l < /tmp/fcpkeys.txt; echo "--- import / media / transcribe related:"
grep -iE 'import|copy|media|transcri|proxy|optimi|analy|autosave|workspace|appearance|theme|bright' /tmp/fcpkeys.txt
echo
echo "--- their current values:"
for k in $(grep -iE 'import|copy|transcri|proxy|optimi|analy' /tmp/fcpkeys.txt); do
  printf '  %-54s %s\n' "$k" "$(defaults read "$C/Preferences/com.apple.FinalCut.plist" "$k" 2>/dev/null)"
done
echo
echo "=== app support (workspaces / command sets) ==="
ls -1 "$C/Application Support/Final Cut Pro/" 2>/dev/null || echo "  none"
