# Video2X CNB GPU 试用仓库

这个仓库用于在 CNB 云原生开发 GPU 环境里测试 Video2X：

- 视频清晰增强 / 超分：Real-ESRGAN
- 视频补帧：RIFE（先通过 `--help` 确认 CLI 参数）
- 目标：先验证 CNB 48GB 共享 GPU 是否能跑 Video2X

> 注意：Video2X 依赖 Vulkan。CNB 有 48GB 共享 GPU，但不保证容器内一定暴露 Vulkan。先跑环境检测。

## 1. 在 CNB 使用

1. 在 CNB 导入这个 GitHub 仓库。
2. 进入仓库页面。
3. 点击「云原生开发」。
4. 等待环境构建完成，打开 WebIDE Terminal。

`.cnb.yml` 会请求：

```yaml
runner:
  tags: cnb:arch:amd64:gpu
services:
  - vscode
```

CNB 官方该节点通常是：

```text
16 核 CPU
48GB 共享显存
单次最长 4 小时
```

## 2. 先检测环境

```bash
bash scripts/probe.sh
```

重点看：

```text
nvidia-smi 是否成功
vulkaninfo --summary 是否能看到 GPU / Vulkan
ffmpeg 是否存在
```

如果 `vulkaninfo` 失败，Video2X 大概率跑不动；建议改用 PyTorch CUDA 路线：Real-ESRGAN + Practical-RIFE。

### 如果 AppImage 报 GLIBC / GLIBCXX 缺失

类似错误：

```text
GLIBC_2.38 not found
GLIBCXX_3.4.32 not found
```

说明当前 CNB 环境基于 Ubuntu 22.04，系统运行库太旧。仓库已改为：

```Dockerfile
FROM ubuntu:24.04
```

你需要在 CNB 页面关闭旧开发环境，然后重新启动「云原生开发」，让 CNB 重新构建镜像。只在旧终端里重新执行脚本不会生效。

## 3. 下载 Video2X AppImage

```bash
bash scripts/setup_video2x.sh
```

成功后会生成：

```text
tools/Video2X-x86_64.AppImage
video2x-help.txt
```

## 4. 下载官方小测试视频

```bash
bash scripts/download_test_clip.sh
```

测试视频来自 Video2X 官方文档，约 4.54 MiB：

```text
input/standard-test.mp4
```

## 5. 测试清晰增强 / 超分

```bash
bash scripts/test_upscale.sh
```

输出：

```text
output/standard-test-upscale.mp4
```

脚本使用的 Video2X 命令来自官方容器文档：

```bash
Video2X-x86_64.AppImage \
  -i input/standard-test.mp4 \
  -o output/standard-test-upscale.mp4 \
  -p realesrgan \
  -s 4 \
  --realesrgan-model realesr-animevideov3
```

## 6. 补帧测试

先查看 Video2X 当前 CLI 参数：

```bash
bash scripts/show_help_keywords.sh
```

把 `rife / interpolation / fps / frame` 相关输出发给 Hermes，再决定补帧命令。

## 7. 判断结果

### 可以继续用 Video2X 的情况

```text
nvidia-smi 成功
vulkaninfo 成功识别 NVIDIA/L40
setup_video2x.sh 成功
test_upscale.sh 成功输出 mp4
```

### 不建议继续 Video2X 的情况

```text
vulkaninfo 只看到 llvmpipe / CPU
AppImage 无法启动
Video2X 报 Vulkan device / GPU not found
```

这时切换到：

```text
Real-ESRGAN + Practical-RIFE + PyTorch CUDA
```

更适合 CNB 的 NVIDIA GPU 环境。

## 8. CNB 实测结论：CUDA 路线通过

实测环境：

```text
GPU: NVIDIA L40
Torch: 2.12.0+cu126
CUDA available: True
Video2X: 只识别 llvmpipe，走 CPU Vulkan，不推荐继续
```

### Real-ESRGAN 最小测试通过

成功输出：

```text
/workspace/realesrgan-test/out/frame_out.png
```

### RIFE 最小补帧测试通过

成功把官方测试视频从约 23.98 fps 补到约 47.95 fps：

```text
/workspace/output/standard-test-rife-2x.mp4
```

注意：RIFE 脚本如果缺 `moviepy`，可能音频合并失败，但视频补帧已经成功。可用 ffmpeg 手动合并原音频：

```bash
bash scripts/mux_rife_audio.sh \
  /workspace/output/standard-test-rife-2x.mp4 \
  /workspace/input/standard-test.mp4 \
  /workspace/output/standard-test-rife-2x-audio.mp4
```

## 9. 不要提交的文件

以下文件已被 `.gitignore` 忽略：

```text
tools/Video2X-x86_64.AppImage
input/*.mp4
output/*.mp4
video2x-help.txt
*.log
```

不要把原始视频、输出视频、大模型、密钥提交到 GitHub。
