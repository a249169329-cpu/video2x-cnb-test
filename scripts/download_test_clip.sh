#!/usr/bin/env bash
set -euo pipefail

mkdir -p input output

URL="https://files.k4yt3x.com/resources/videos/standard-test.mp4"
OUT="input/standard-test.mp4"

if [ ! -f "$OUT" ]; then
  curl -fL --retry 3 --retry-delay 2 -o "$OUT" "$URL"
fi

ffprobe -hide_banner "$OUT" || true
ls -lh "$OUT"
