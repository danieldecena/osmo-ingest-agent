#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "=== every ProExtension* on the system (excluding the shipped apps) ==="
find / -maxdepth 6 -name "ProExtension*" -not -path "*/Applications/*Creator Studio.app/*" 2>/dev/null | head -20
echo
echo "=== what the template itself contains ==="
T="/Library/Developer/Xcode/Templates/ProVideo/WorkflowExtension/FCP Workflow Extension.xctemplate"
ls -1 "$T" 2>/dev/null
echo "--- TemplateInfo, frameworks it expects to link:"
grep -o '[A-Za-z]*\.framework' "$T/TemplateInfo.plist" 2>/dev/null | sort -u
grep -o 'ProExtension[A-Za-z]*' "$T/TemplateInfo.plist" 2>/dev/null | sort -u
echo "--- linker flags it sets:"
grep -A2 -i 'OTHER_LDFLAGS\|ProExtensionMain' "$T/TemplateInfo.plist" 2>/dev/null | head -8
echo
echo "=== SDK receipt / what the installer wrote ==="
pkgutil --pkgs 2>/dev/null | grep -i -E 'workflow|proextension|provideo' | head
for p in $(pkgutil --pkgs 2>/dev/null | grep -i -E 'workflow|proextension|provideo'); do
  echo "--- $p"; pkgutil --files "$p" 2>/dev/null | head -12
done
