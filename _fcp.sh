#!/bin/bash
export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
echo "=== Final Cut running? ==="
pgrep -x "Final Cut Pro" >/dev/null && echo "RUNNING (prefs written now would be overwritten on quit)" || echo "not running"
echo
echo "=== version ==="
defaults read /Applications/"Final Cut Pro.app"/Contents/Info.plist CFBundleShortVersionString 2>/dev/null
echo
echo "=== import / storage prefs that matter ==="
for k in FFImportCopyToMediaFolder FFCreateOptimizedMediaForMulticamClips FFImportCreateProxyMedia \
         FFImportCreateOptimizedMedia FFImportAnalyzeVideoForStabilizationAndRollingShutter \
         FFImportAnalyzeVideoForKeywords FFImportAnalyzeAudioForProblems FFImportAssignAudioRole \
         FFImportTranscribeAudio FFPlayerQuality FFAutosaveInterval FFShareBackgroundRender; do
  v=$(defaults read com.apple.FinalCut "$k" 2>/dev/null || echo "(unset)")
  printf '  %-52s %s\n' "$k" "$v"
done
echo
echo "=== custom workspaces installed ==="
ls -1 "$HOME/Library/Application Support/Final Cut Pro/Workspaces/" 2>/dev/null || echo "  none"
echo
echo "=== custom command sets (keyboard) ==="
ls -1 "$HOME/Library/Application Support/Final Cut Pro/Command Sets/" 2>/dev/null || echo "  none"
echo
echo "=== libraries in play ==="
ls -1d "$HOME"/Movies/*.fcpbundle "$HOME"/Content.fcpbundle 2>/dev/null
