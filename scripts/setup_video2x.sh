#!/usr/bin/env bash
set -euo pipefail

VERSION="${VIDEO2X_VERSION:-6.4.0}"
APP="tools/Video2X-x86_64.AppImage"
URL="https://github.com/k4yt3x/video2x/releases/download/${VERSION}/Video2X-x86_64.AppImage"

mkdir -p tools input output

if [ ! -f "$APP" ]; then
  echo "Downloading Video2X ${VERSION}..."
  curl -fL --retry 3 --retry-delay 2 -o "$APP" "$URL"
else
  echo "Video2X AppImage already exists: $APP"
fi

chmod +x "$APP"

echo
echo "== Video2X help =="
APPIMAGE_EXTRACT_AND_RUN=1 "$APP" --help | tee video2x-help.txt

echo
echo "== Keywords in help =="
grep -iE "rife|interpol|fps|frame|realesrgan|model|scale|processor|filter" video2x-help.txt || true

echo
echo "Video2X ready: $APP"
