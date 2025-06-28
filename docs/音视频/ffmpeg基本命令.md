##
ffmpeg -filters

## 播放yuv
```bash
ffplay -f rawvideo -pixel_format yuv420p -video_size 1280x720 sample.yuv
```
* -f rawvideo：告诉 ffplay 输入文件是原始视频数据。
* -pixel_format yuv420p：指定像素格式为 YUV420p。
* -video_size 1920x1080：指定视频分辨率为 1920x1080。

## 播放pcm
假设你有一个 PCM 文件，名为 audio.pcm，采样率为 44100 Hz，声道数为 2（立体声），采样格式为 16 位有符号整数（signed 16-bit little-endian）。你可以使用以下命令播放该文件：
```
ffplay -f s16le -ar 44100 -ac 2 audio.pcm

```

* -f s16le：指定 PCM 文件的格式为 signed 16-bit little-endian。
* -ar 44100：指定采样率为 44100 Hz。
* -ac 2：指定声道数为 2（立体声）。
