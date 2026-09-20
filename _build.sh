#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
R="$HOME/Movies/footage-board-extension"
cd "$R" || exit 1
echo "=== generating the xcode project ==="
xcodegen generate 2>&1 | tail -2
echo
echo "=== building (manual Developer ID signing) ==="
xcodebuild -project FootageBoard.xcodeproj -scheme FootageBoard \
  -configuration Release -derivedDataPath build \
  CODE_SIGN_STYLE=Manual \
  CODE_SIGN_IDENTITY="Developer ID Application" \
  DEVELOPMENT_TEAM=877MLS29T9 \
  PROVISIONING_PROFILE_SPECIFIER="" \
  build 2>&1 | grep -E "error:|BUILD|\*\*" | head -25
echo
echo "=== product ==="
A=$(find build -name "FootageBoard.app" -maxdepth 6 2>/dev/null | head -1)
echo "  $A"
[ -n "$A" ] && ls -1 "$A/Contents/PlugIns" 2>/dev/null | sed 's/^/  plugin: /'
