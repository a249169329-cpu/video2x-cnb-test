#!/usr/bin/env bash
set -euo pipefail

echo "== System =="
uname -a || true
printf 'PWD: '; pwd
printf 'Date: '; date

echo
echo "== GPU / CUDA =="
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi || true
  echo
  nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader || true
else
  echo "nvidia-smi not found"
fi

echo
echo "== Vulkan =="
if command -v vulkaninfo >/dev/null 2>&1; then
  vulkaninfo --summary || true
else
  echo "vulkaninfo not found"
fi

echo
echo "== FFmpeg =="
if command -v ffmpeg >/dev/null 2>&1; then
  ffmpeg -version | head -n 5
else
  echo "ffmpeg not found"
fi

echo
echo "== Disk =="
df -h . || true

echo
echo "== Verdict hint =="
echo "nvidia-smi 成功 + vulkaninfo 能看到 GPU，才建议继续跑 Video2X。"
