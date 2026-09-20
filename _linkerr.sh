#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
cd "$HOME/Movies/footage-board-extension" || exit 1
xcodebuild -project FootageBoard.xcodeproj -scheme FootageBoard \
  -configuration Release -derivedDataPath build \
  CODE_SIGN_STYLE=Manual CODE_SIGN_IDENTITY="Developer ID Application" \
  DEVELOPMENT_TEAM=877MLS29T9 PROVISIONING_PROFILE_SPECIFIER="" \
  build 2>&1 | grep -B3 -A12 "linker command failed" | head -40
echo "=== what the SDK actually offers to link against ==="
find /Library/Developer/SDKs/WorkflowExtensionSDK.sdk -name "*.tbd" -o -name "*.dylib" -o -name "libProExtension*" 2>/dev/null
ls -1 /Library/Developer/SDKs/WorkflowExtensionSDK.sdk/usr/lib/ 2>/dev/null
