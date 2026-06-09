#!/usr/bin/env bash
set -euo pipefail

VIDEO_IN="${1:-/workspace/output/standard-test-rife-2x.mp4}"
AUDIO_SRC="${2:-/workspace/input/standard-test.mp4}"
OUT="${3:-/workspace/output/standard-test-rife-2x-audio.mp4}"

if [ ! -f "$VIDEO_IN" ]; then
  echo "Missing interpolated video: $VIDEO_IN" >&2
  exit 1
fi
if [ ! -f "$AUDIO_SRC" ]; then
  echo "Missing source video/audio: $AUDIO_SRC" >&2
  exit 1
fi

ffmpeg -y \
  -i "$VIDEO_IN" \
  -i "$AUDIO_SRC" \
  -map 0:v:0 \
  -map 1:a:0? \
  -c:v libx264 \
  -preset medium \
  -crf 18 \
  -pix_fmt yuv420p \
  -c:a copy \
  -shortest \
  "$OUT"

ffprobe -hide_banner "$OUT" || true
ls -lh "$OUT"
