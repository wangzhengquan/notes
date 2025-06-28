## 1 安装依赖包
```bash
# 依赖包openssl安装
sudo apt-get install openssl libssl-dev 
# 依赖包pcre安装
sudo apt-get install libpcre3 libpcre3-dev
# 依赖包zlib安装
sudo apt-get install zlib1g-dev  
```

## 2 编译Nginx
### 2.1 源码下载
- Nginx下载
```bash
git clone https://github.com/nginx/nginx
```

- 下载nginx-rtmp-module
```bash
git clone https://github.com/arut/nginx-rtmp-module.git
```

### 2.2 编译

```bash
cd nginx

auto/configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module --with-http_flv_module --with-http_mp4_module --add-module=../nginx-rtmp-module

make -j8

sudo make install
```

默认安装到 `/usr/local/nginx`

配置文件路径：`/usr/local/nginx/conf/nginx.conf`

## 3 配置nginx

### 3.1 点播配置
#### 3.1.1 建立媒体文件夹

```bash
mkdir /mnt/hgfs/dn_class/vod
```
#### 3.1.2 准备媒体文件：
把媒体文件 "35.mp4" 复制到/mnt/hgfs/dn_class/vod目录下。  
媒体文件自己拷贝，符合AAC+H264的格式即可。

#### 3.1.3 在nginx中配置rtmp

打开配置文件nginx.conf（路径/usr/local/nginx/conf/nginx.conf），添加RTMP的配置。

```bash

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}

rtmp {  #RTMP server
    server {    
        listen 1935;  #server port
        chunk_size 4096;  #chunk_size
        application vod {
            play /mnt/hgfs/dn_class/vod; #media file position
        }
    }
}
........
其他配置不需理会
```

配置目录/mnt/hgfs/qingfu/vod为存放视频文件的位置.

配置好后，重新启动一下nginx
```bash
sudo /usr/local/nginx/sbin/nginx -s reload
```
如果报错, 
```
nginx: [error] open() "/usr/local/nginx/logs/nginx.pid" failed (2: No such file or directory)
```
则说明nginx没有启动，所以需要先启动
```bash
sudo /usr/local/nginx/sbin/nginx
````

- 3.1.4 使用ffplay进行播放

```bash
ffplay rtmp://192.168.100.33/vod/35.mp4
```

### 3.2 直播配置
接着我们就在点播服务器配置文件的基础之上添加直播服务器的配置。
#### 3.2.1 配置
RTMP服务添加一个application, 这个名字可以任意起，也可以起多个名字，由于是直播我就叫做它live。

```bash

events {
    worker_connections  1024;
}

rtmp {  #RTMP server
    server {    
        listen 1935;  #server port
        chunk_size 4096;  #chunk_size
        # vod server
        application vod {
            play /mnt/hgfs/dn_class/vod; #media file position
        }

        # live server 1
	    application live{ #Darren live first add
	        live on;
	    }

		     
    }
}
........
其他配置不需理会
```

#### 3.2.2 推流
在Ubuntu端用ffmpeg产生一个模拟直播源，向rtmp服务器推送

```bash
ffmpeg -re -i /mnt/hgfs/dn_class/vod/35.mp4 -c copy -f flv rtmp://192.168.100.33/live/35
```
注意，源文件必须是H.264+AAC编码的。如果不是则需要转码，
```bash
ffmpeg -re -i /path/to/your/video.mp4 -c:v libx264 -preset fast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 128k -ar 44100 -f flv rtmp://192.168.100.33/live/35

```
* -re: Read the input at its native frame rate.
* -i /path/to/your/video.mp4: Input file.
* -c:v libx264: Use the H.264 video codec.
* -preset fast: Set the encoding speed/quality tradeoff.
* -maxrate 3000k -bufsize 6000k: Control the bitrate.
* -pix_fmt yuv420p: Set pixel format.
* -g 50: Set the GOP size.
* -c:a aac: Use the AAC audio codec.
* -b:a 128k -ar 44100: Set audio bitrate and sample rate.
* -f flv: Output format is FLV (Flash Video).
* rtmp://localhost/live/stream: RTMP URL where the stream is sent.

#### 3.2.3 拉流
使用ffplay进行拉流
```bash
ffplay rtmp://192.168.100.33/live/35
```


> https://www.jianshu.com/p/16741e363a77
