#!/usr/bin/env bash
set -euo pipefail

APP="tools/Video2X-x86_64.AppImage"
IN="input/standard-test.mp4"
OUT="output/standard-test-upscale.mp4"

if [ ! -x "$APP" ]; then
  echo "Missing $APP. Run: bash scripts/setup_video2x.sh" >&2
  exit 1
fi
if [ ! -f "$IN" ]; then
  echo "Missing $IN. Run: bash scripts/download_test_clip.sh" >&2
  exit 1
fi

APPIMAGE_EXTRACT_AND_RUN=1 "$APP" \
  -i "$IN" \
  -o "$OUT" \
  -p realesrgan \
  -s 4 \
  --realesrgan-model realesr-animevideov3

ffprobe -hide_banner "$OUT" || true
ls -lh "$OUT"
