
##
```bash
git clone --depth 1 https://gitee.com/mirrors/x264.git

PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --enable-static --enable-pic
```

## opus

attention
```
If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the '-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'

```
## install on linux
### ffmpeg
```bash
wget -O ffmpeg-4.2.1.tar.bz2 https://ffmpeg.org/releases/ffmpeg-4.2.1.tar.bz2 && \
tar xjvf ffmpeg-4.2.1.tar.bz2

PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" CFLAGS="-O3 -fPIC" ../configure --prefix="$HOME/ffmpeg_build"  --pkg-config-flags="--static"  --extra-cflags="-I$HOME/ffmpeg_build/include"  --extra-ldflags="-L$HOME/ffmpeg_build/lib"  --extra-libs="-lpthread -lm" --bindir="$HOME/bin" --enable-gpl  --enable-libass  --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx  --enable-libx264 --enable-libx265 --enable-pic --enable-shared --enable-nonfree

make; make install
```


## install on macos

Install dependencies with Homebrew
```bash
brew install automake fdk-aac git lame libass libtool libvorbis libvpx opus sdl2 shtool texi2html theora wget x264 x265 xvid nasm
```

### install libass
1. install harfbuzz
```bash
git clone https://github.com/harfbuzz/harfbuzz.git
brew install pkg-config ragel gtk-doc freetype glib cairo meson
cd harfbuzz
meson build  -Ddocs=disabled  && ninja -Cbuild && meson test -Cbuild
sudo meson install -C build
```
2. install libass
git clone https://github.com/libass/libass.git



```
./configure  --prefix=/usr/local --enable-gpl --enable-nonfree --enable-libass \
--enable-libfdk-aac --enable-libfreetype --enable-libmp3lame \
--enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libopus --enable-libxvid \
--samples=fate-suite/
```


```
../configure --prefix=/usr/local/ffmpeg/7.0.1 --enable-shared --enable-gpl  --enable-nonfree --enable-libfdk-aac --enable-libx264 --enable-libx265 --enable-libopus  --enable-libmp3lame  --enable-libass --enable-libvorbis --enable-libvpx --enable-libfreetype
```
## reference
- (H.264)[https://trac.ffmpeg.org/wiki/Encode/H.264]
- (CompilationGuide)[https://trac.ffmpeg.org/wiki/CompilationGuide]