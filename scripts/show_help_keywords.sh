#!/usr/bin/env bash
set -euo pipefail

APP="tools/Video2X-x86_64.AppImage"
if [ ! -x "$APP" ]; then
  echo "Missing $APP. Run: bash scripts/setup_video2x.sh" >&2
  exit 1
fi

APPIMAGE_EXTRACT_AND_RUN=1 "$APP" --help > video2x-help.txt

grep -iE "rife|interpol|fps|frame|realesrgan|realcugan|anime4k|processor|filter|scale|model" video2x-help.txt || true
