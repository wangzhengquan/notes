
##  Record Screen on Ubuntu
```bash
ffmpeg -f x11grab -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -r 25 -c:v libx264 -crf 0 -preset ultrafast output.mkv

```

* -f x11grab: Specifies the X11 screen capture.
* -s $(xdpyinfo | grep dimensions | awk '{print $2}'): Automatically gets the screen resolution using xdpyinfo.
* -i :0.0: Specifies the display to capture (replace with your display identifier if different).
* -r 25: Sets the frame rate (you can adjust this as needed).
* -c:v libx264: Uses the H.264 codec for video compression.
* -crf 0: Sets the Constant Rate Factor to 0 for lossless recording (adjustable).
* -preset ultrafast: Uses the ultrafast preset for minimal compression delay (adjustable).
* output.mkv: The name of the output file.


Or,
```bash
ffmpeg -f x11grab -s $(xdpyinfo | grep dimensions | awk '{print $2}') -i :0.0 -c:v libx264 -r 30 -pix_fmt yuv420p output.mp4

```
* -f x11grab: Specifies the input format for screen capture.
* -s $(xdpyinfo | grep dimensions | awk '{print $2}'): Automatically sets the * screen size.
* -i :0.0: Indicates the display to capture (default display).
* -c:v libx264: Uses the H.264 codec for video compression.
* -r 30: Sets the frame rate to 30 FPS.
* -pix_fmt yuv420p: Ensures compatibility with most media players.
* output.mp4: The output file.
