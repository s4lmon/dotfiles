#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.color=0xffff69b4 icon.color=0xff1a0a2e label.color=0xff1a0a2e background.border_width=2
else
  sketchybar --set $NAME background.color=0xff2d1b4e icon.color=0xffff69b4 label.color=0xffff69b4 background.border_width=0
fi
