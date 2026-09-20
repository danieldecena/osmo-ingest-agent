#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
S="/Library/Developer/SDKs/WorkflowExtensionSDK.sdk"
echo "=== SDK root ==="; ls -1 "$S" 2>/dev/null
echo
echo "=== frameworks in the SDK ==="; ls -1 "$S/Library/Frameworks" 2>/dev/null
echo
echo "=== headers (the API surface) ==="
find "$S" -name "*.h" 2>/dev/null | sed "s|$S/||"
echo
echo "=== FCPXTimeline: what can I actually call? ==="
H=$(find "$S" -name "FCPXTimeline.h" 2>/dev/null | head -1)
[ -n "$H" ] && grep -E '^\s*-\s*\(|^\s*@property|^\s*\+\s*\(' "$H" | sed 's/^/  /'
echo
echo "=== FCPXHost ==="
H2=$(find "$S" -name "FCPXHost.h" 2>/dev/null | head -1)
[ -n "$H2" ] && grep -E '^\s*-\s*\(|^\s*@property' "$H2" | sed 's/^/  /'
echo
echo "=== observer callbacks ==="
H3=$(find "$S" -name "FCPXTimelineObserver.h" 2>/dev/null | head -1)
[ -n "$H3" ] && grep -E '^\s*-\s*\(' "$H3" | sed 's/^/  /'
