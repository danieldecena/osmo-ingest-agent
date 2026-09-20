#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
P="$HOME/Library/Preferences/com.apple.FinalCut.plist"
echo "=== plist exists? ==="; ls -l "$P" 2>/dev/null || echo "  no plist at that path"
echo
echo "=== every key FCP actually stores (names only) ==="
defaults read com.apple.FinalCut 2>/dev/null | grep -oE '^ +"?[A-Za-z0-9_.]+"? =' | tr -d ' ="' | sort | head -80
echo
echo "=== total keys ==="
defaults read com.apple.FinalCut 2>/dev/null | grep -cE '^ +"?[A-Za-z0-9_.]+"? ='
echo
echo "=== anything import/copy/transcribe related ==="
defaults read com.apple.FinalCut 2>/dev/null | grep -iE 'import|copy|media|transcri|proxy|optimi|workspace' | head -30
echo
echo "=== app support layout ==="
ls -1 "$HOME/Library/Application Support/Final Cut Pro/" 2>/dev/null
