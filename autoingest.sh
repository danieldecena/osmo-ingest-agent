#!/bin/bash
# Fires when the Osmo mounts. Copy, verify, index — then, only if every clip
# verified, optionally clear the camera.
#
# Auto-clear is OFF unless the file _agent/CLEAR_CAMERA_OK exists. Deleting is
# gated on the verify result, never on "the copy finished" — that distinction is
# what the 2026-09-17 loss came down to.

set -uo pipefail

# launchd gives a process almost no PATH, so ffprobe/ffmpeg/montage would all be
# missing. Name the directories explicitly.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

CARD="${FOOTCAT_CARD:-$(cat "$HOME/Movies/Footage/_agent/card_path" 2>/dev/null || echo /Volumes/OsmoAction)}"
FOOTAGE="$HOME/Movies/Footage"
AGENT="$FOOTAGE/_agent"
ARCHIVE="${FOOTCAT_ARCHIVE:-$(cat "$AGENT/archive_root" 2>/dev/null || echo "$FOOTAGE/2026-09-17_osmo-import")}"
PKG="$HOME/Movies/footage-catalog/src"

# /usr/bin/python3 on this Mac is Xcode's 3.9, which cannot parse the package.
# Pick the first interpreter that is actually 3.10 or newer.
PY=""
for c in "$(cat "$AGENT/python_path" 2>/dev/null)" /opt/homebrew/bin/python3 \
         /opt/homebrew/bin/python3.13 /usr/local/bin/python3 /usr/bin/python3; do
  [ -x "${c:-}" ] || continue
  if "$c" -c 'import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)' 2>/dev/null; then
    PY="$c"; break
  fi
done
LOG="$AGENT/autoingest.log"
LOCK="$AGENT/.lock"
STAMP="$AGENT/.last_seen"
LASTFAIL="$AGENT/.last_failure"

mkdir -p "$AGENT"

[ -d "$CARD/DCIM" ] || exit 0                                # nothing plugged in

# Which card, not merely whether one is present.
#
# The stamp used to mean "a card was handled", cleared after the card had
# been gone for four consecutive ticks. That tolerated a USB blip, which was
# the point, but it also meant swapping card A for card B -- fifteen seconds,
# well under two minutes -- left the stamp in place and card B was skipped
# entirely. No log line, no notification: the script exits here, before say()
# is even defined.
#
# Identity settles both cases without a timer. A blip re-mounts the same card
# and produces the same signature, so it is still skipped; a different card
# produces a different one and is ingested. Built from the volume name, the
# camera index's size and mtime, and the newest clip on the card -- cheap,
# and no two cards share all four.
card_signature() {
  db="$CARD/MISC/AC006.db"
  printf '%s|%s|%s' \
    "$(basename "$CARD")" \
    "$(stat -f '%z:%m' "$db" 2>/dev/null || echo nodb)" \
    "$(find "$CARD/DCIM" -type f -name '*.MP4' 2>/dev/null | sort | tail -1 | xargs basename 2>/dev/null || echo noclips)"
}

SIG=$(card_signature)
if [ -e "$STAMP" ] && [ "$(cat "$STAMP" 2>/dev/null)" = "$SIG" ]; then
  exit 0                                                     # this exact card, already done
fi
# A different card is a different story, so let it report its own failures.
rm -f "$LASTFAIL"

mkdir "$LOCK" 2>/dev/null || exit 0                          # a run is already going
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

say(){ printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG"; }
notify(){ /usr/bin/osascript -e "display notification \"$1\" with title \"Footage\"" >/dev/null 2>&1; }

# A failure that repeats unchanged is one problem, not many. Notify on the
# first occurrence and on any change of verdict; stay quiet while it is the
# same story. Cleared on success and on a real unmount, so the next genuine
# failure is always announced.
notify_failure(){
  if [ "$1" = "$(cat "$LASTFAIL" 2>/dev/null || true)" ]; then
    say "same failure as the previous run — not re-notifying"
  else
    notify "$1"
    printf '%s' "$1" > "$LASTFAIL"
  fi
}

printf '%s' "$SIG" > "$STAMP.$$" && mv -f "$STAMP.$$" "$STAMP"
say "camera mounted — starting"
if [ -z "$PY" ]; then
  say "no python 3.10+ found — camera left untouched"
  notify_failure "Ingest cannot run: no Python 3.10+ found"
  exit 1
fi
notify "Camera found. Copying and verifying…"

OUT=$(PYTHONPATH="$PKG" "$PY" -m footcat.cli \
        --archive "$ARCHIVE" --card "$CARD" 2>&1)
RC=$?
printf '%s\n' "$OUT" >> "$LOG"

VERDICT=$(printf '%s' "$OUT" | grep -E 'SAFE TO FORMAT|DO NOT FORMAT' | tail -1)
say "${VERDICT:-no verdict returned}"

if [ $RC -ne 0 ] || ! printf '%s' "$VERDICT" | grep -q 'SAFE TO FORMAT'; then
  say "verification did not pass — camera left untouched"
  notify_failure "${VERDICT:-Ingest failed} — camera untouched"
  exit 1
fi

rm -f "$LASTFAIL"

# board data, so the review board reflects the new footage
PYTHONPATH="$PKG" "$PY" -m footcat.board \
  --archive "$ARCHIVE" --out "$ARCHIVE/board.json" >> "$LOG" 2>&1

if [ ! -e "$AGENT/CLEAR_CAMERA_OK" ]; then
  say "all clips verified; auto-clear is off, camera left as is"
  notify "$VERDICT — camera not cleared"
  exit 0
fi

# Clear, file by file, and only where the archive holds a byte-identical copy.
CLEARED=0; KEPT=0
while IFS= read -r -d '' f; do
  rel="${f#$CARD/}"
  dst="$ARCHIVE/$rel"
  if [ -f "$dst" ] && [ "$(stat -f%z "$f")" = "$(stat -f%z "$dst")" ]; then
    rm -f "$f" && CLEARED=$((CLEARED+1))
  else
    KEPT=$((KEPT+1)); say "kept on camera (no matching copy): $rel"
  fi
done < <(find "$CARD/DCIM" -type f -print0)

say "cleared $CLEARED file(s) from the camera, kept $KEPT"
notify "$VERDICT · cleared $CLEARED files"
