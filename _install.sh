#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
R="$HOME/Movies/footage-board-extension"
A="$R/build/Build/Products/Release/FootageBoard.app"
E="$A/Contents/PlugIns/FootageBoardExtension.appex/Contents/MacOS/FootageBoardExtension"
ID="Developer ID Application: Daniel Decena (877MLS29T9)"

# xcodebuild splits LD_RUNPATH_SEARCH_PATHS on spaces, and the host app's name
# has three of them. install_name_tool takes the path as one argument.
echo "=== adding rpaths to the host frameworks ==="
for p in "/Applications/Final Cut Pro Creator Studio.app/Contents/Frameworks" \
         "/Applications/Final Cut Pro.app/Contents/Frameworks"; do
  install_name_tool -add_rpath "$p" "$E" 2>/dev/null && echo "  added: $p" || echo "  already present: $p"
done

echo "=== re-signing (install_name_tool invalidates the signature) ==="
codesign --force --sign "$ID" --entitlements "$R/Extension/Extension.entitlements" \
  --options runtime --timestamp=none "$A/Contents/PlugIns/FootageBoardExtension.appex" 2>&1 | sed 's/^/  /'
codesign --force --sign "$ID" --entitlements "$R/App/FootageBoard.entitlements" \
  --options runtime --timestamp=none "$A" 2>&1 | sed 's/^/  /'
codesign --verify --deep --strict "$A" 2>&1 | sed 's/^/  /' && echo "  signature: valid"

echo "=== rpaths ==="
otool -l "$E" | grep -A2 LC_RPATH | grep "path " | sed 's/^ */  /'

echo "=== installing ==="
rm -rf "/Applications/Footage Board.app"
cp -R "$A" "/Applications/Footage Board.app" && echo "  copied to /Applications"
open "/Applications/Footage Board.app"; sleep 5
pluginkit -m -v 2>/dev/null | grep -i footageboard | sed 's/^/  registered: /'
