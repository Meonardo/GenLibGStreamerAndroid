# libgstreamer_android_gen
This tool generates a `libgstreamer_android.so` library with all
[GStreamer](https://gstreamer.freedesktop.org/) dependencies for Android.

### NOTICE
- this build script contains a lot of hard-code file path like NDK path(etc...), may not work with your requirment, please use carefully!

### configuration
- configure NDK path(mine use `android-ndk-21` for building gstreamer-`1.22.2`);
- configure `GSTREAMER_ROOT_ANDROID` path;

### build
```bash
./build.sh
```
