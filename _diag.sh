#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
A="/Applications/Footage Board.app"
echo "=== bundle contents ==="
find "$A" -maxdepth 3 -not -path "*/PlugIns/*" | sed "s|$A|.|" | head -15
echo
echo "=== Info.plist keys that matter ==="
for k in CFBundleExecutable CFBundleIdentifier CFBundleName CFBundlePackageType; do
  printf '  %-22s %s\n' "$k" "$(/usr/libexec/PlistBuddy -c "Print :$k" "$A/Contents/Info.plist" 2>&1)"
done
echo
echo "=== is there a binary at all? ==="
ls -l "$A/Contents/MacOS/" 2>&1 | sed 's/^/  /'
echo
echo "=== same questions of the extension ==="
E="$A/Contents/PlugIns/FootageBoardExtension.appex"
for k in CFBundleExecutable CFBundleIdentifier; do
  printf '  %-22s %s\n' "$k" "$(/usr/libexec/PlistBuddy -c "Print :$k" "$E/Contents/Info.plist" 2>&1)"
done
ls -l "$E/Contents/MacOS/" 2>&1 | sed 's/^/  /'
