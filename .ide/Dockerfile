FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV APPIMAGE_EXTRACT_AND_RUN=1

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    jq \
    git \
    ffmpeg \
    vulkan-tools \
    libvulkan1 \
    mesa-vulkan-drivers \
    libgl1 \
    libglib2.0-0 \
    libstdc++6 \
    libfuse2t64 \
    file \
    xz-utils \
    procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
