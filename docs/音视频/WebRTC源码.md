## 下载并安装 depot_tools
Clone the depot_tools repository:
```bash
cd /usr/local
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
```

Update the PATH Variable:
Add the following line at the end of the file  `~/.bash_profile`
```bash
export PATH="$PATH:/usr/local/depot_tools"
source ~/.bash_profile
```

Verify Installation:
```bash
which gclient
```

## 克隆WebRTC代码仓库：
```bash
mkdir webrtc
cd webrtc
fetch --nohooks webrtc
gclient sync

```

## 编译WebRTC库