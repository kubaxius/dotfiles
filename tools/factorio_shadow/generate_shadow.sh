#!/bin/sh

chromium \
  --headless \
  --disable-gpu \
  --hide-scrollbars \
  --force-device-scale-factor=1 \
  --default-background-color=00000000 \
  --window-size=128,128 \
  --screenshot=border_factorio.png \
  file:///home/kubaxius/.local/share/chezmoi/tools/factorio_shadow/border_factorio.html