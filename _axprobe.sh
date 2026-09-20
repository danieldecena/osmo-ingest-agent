#!/bin/bash
# Is the browser's accessibility tree stable, or does it come and go?
for i in 1 2 3 4 5 6; do
  osascript <<'AS' 2>/dev/null
tell application "System Events" to tell process "Final Cut Pro"
  set found to false
  set total to 0
  try
    set w to first window whose name is "Final Cut Pro"
    set ec to entire contents of w
    set total to count of ec
    repeat with e in ec
      try
        if ((value of e) as text) contains "Vlog" then
          set found to true
          exit repeat
        end if
      end try
    end repeat
  end try
  return "elements=" & total & " found=" & found
end tell
AS
  sleep 1
done
