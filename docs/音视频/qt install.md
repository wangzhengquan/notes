以ubuntu系统为例：


## 1. Install Missing Dependencies:
```bash
sudo apt-get install libxcb-cursor0
sudo apt-get install libxcb1 libxcb-xfixes0 libxcb-render0 libxcb-shape0 libxcb-shm0


```

## 2. Verify Installation of Qt and Its Plugins:
```
sudo apt-get install qt5-default qtbase5-dev qtbase5-dev-tools
```

## 3. install
下载在线安装程序：
https://download.qt.io/official_releases/online_installers/

https://download.qt.io/archive/qt/5.14/5.14.2


```bash
wget http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-5.15.0-online.run
chmod +x qt-unified-linux-x64-5.15.0-online.run
```


