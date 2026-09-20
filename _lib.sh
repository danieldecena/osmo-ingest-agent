#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
L="$HOME/Content.fcpbundle"
echo "=== what is the 580 MB, actually? ==="
du -sh "$L"/* 2>/dev/null | sort -rh | head -8
echo
echo "=== biggest files in the library ==="
find "$L" -type f -size +5M 2>/dev/null -exec du -h {} + | sort -rh | head -8
echo
echo "=== any original media copied in? ==="
find "$L" -type d -name "Original Media" 2>/dev/null | while read -r d; do
  echo "  $d -> $(find "$d" -type f | wc -l | xargs) files, $(du -sh "$d" 2>/dev/null | cut -f1)"
done
echo "  (none found)" 
echo
echo "=== symlinks out to the real footage? ==="
find "$L" -type l 2>/dev/null | head -5
echo "  symlink count: $(find "$L" -type l 2>/dev/null | wc -l | xargs)"
