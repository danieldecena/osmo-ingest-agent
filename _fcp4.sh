#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "=== where is Final Cut actually installed / running from? ==="
ps -Axo pid,args | grep -i "Final Cut" | grep -v grep | cut -c1-140 | head -3
echo
echo "=== any FinalCut prefs anywhere under ~/Library ==="
find "$HOME/Library" -maxdepth 6 -iname "*FinalCut*" -o -maxdepth 6 -iname "*Final Cut*" 2>/dev/null | head -20
echo
echo "=== TCC: can this shell read ~/Library/Preferences at all? ==="
ls "$HOME/Library/Preferences" 2>&1 | head -3
echo
echo "=== developer tooling present? ==="
for t in xcodebuild xcrun swift swiftc; do printf '  %-12s %s\n' "$t" "$(command -v $t || echo '-')"; done
xcodebuild -version 2>/dev/null | head -2
echo "  swift: $(swift --version 2>&1 | head -1)"
echo
echo "=== Apple developer account signed in? ==="
ls -1 "$HOME/Library/Developer/Xcode/UserData/Provisioning Profiles" 2>/dev/null | head -3 || echo "  no provisioning profiles visible"
ls -d "$HOME/.appstoreconnect" 2>/dev/null && ls -1 "$HOME/.appstoreconnect" 2>/dev/null | head
