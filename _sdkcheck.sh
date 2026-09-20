#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "=== framework installed? ==="
for p in /Library/Frameworks/ProExtension.framework \
         /Library/Frameworks/ProExtensionHost.framework \
         /Library/Frameworks/ProExtensionSupport.framework; do
  if [ -e "$p" ]; then echo "  FOUND  $p"; else echo "  absent $p"; fi
done
echo
echo "=== Xcode template? ==="
find /Library/Developer/Xcode/Templates "$HOME/Library/Developer/Xcode/Templates" \
     -iname "*Workflow*" -o -iname "*Final Cut*" 2>/dev/null | head -6
[ -d /Library/Developer/Xcode/Templates ] && echo "  (templates dir exists)" || echo "  (no /Library/Developer/Xcode/Templates)"
echo
echo "=== headers, so I know what to code against ==="
ls -1 /Library/Frameworks/ProExtensionHost.framework/Versions/A/Headers/ 2>/dev/null | head -12
echo
echo "=== anything workflow-ish still sitting in Downloads? ==="
ls -t "$HOME/Downloads" 2>/dev/null | head -6
