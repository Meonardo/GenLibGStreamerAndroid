export PATH=/home/meonardo/Android/gstreamer/1.22.2/cerbero/build/android-ndk-25:$PATH
export TARGET_ARCH_ABI=arm64-v8a
export GSTREAMER_ROOT_ANDROID=/home/meonardo/Android/gstreamer/tmp/gst-build

export LIBRGA_ROOT=/home/meonardo/Android/android-project/librga/1.10.1/librga/build/build_android_ndk/install

if [[ -z "${GSTREAMER_ROOT_ANDROID}" ]]; then
  echo "You must define an environment variable called GSTREAMER_ROOT_ANDROID and point it to the folder where you extracted the GStreamer binaries"
  exit 1
fi

VERSION=1.22.2
DATE=`date "+%Y%m%d-%H%M%S"`

rm -rf out
mkdir out


GST_TAR_FILE_PATH=$GSTREAMER_ROOT_ANDROID/../../1.22.2/cerbero/gstreamer-1.0-android-arm64-$VERSION.tar.xz
if [ -f "$GST_TAR_FILE_PATH" ]; then
    echo "File $GST_TAR_FILE_PATH exists, remove it first."
    # remove old gst-build lib directory
    rm -fr $GSTREAMER_ROOT_ANDROID/arm64-v8a
    mkdir $GSTREAMER_ROOT_ANDROID/arm64-v8a
    tar -xvf $GST_TAR_FILE_PATH -C $GSTREAMER_ROOT_ANDROID/arm64-v8a
else 
    echo "File $GST_TAR_FILE_PATH does not exist."
fi

# # copy drm, mpp & rga
echo "copy dependencies..."
echo "copy mpp"
cp $GSTREAMER_ROOT_ANDROID/new/mpp/lib/pkgconfig/rockchip_vpu.pc $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib/pkgconfig
cp $GSTREAMER_ROOT_ANDROID/new/mpp/lib/pkgconfig/rockchip_mpp.pc $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib/pkgconfig
cp $GSTREAMER_ROOT_ANDROID/new/mpp/lib/librockchip_vpu.so $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib
cp $GSTREAMER_ROOT_ANDROID/new/mpp/lib/librockchip_mpp.so $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib

echo "copy drm"
cp $GSTREAMER_ROOT_ANDROID/new/drm/lib/pkgconfig/libdrm.pc $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib/pkgconfig
cp $GSTREAMER_ROOT_ANDROID/new/drm/lib/libdrm.so $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib

# echo "copy rga"
echo "copy rga"
cp $LIBRGA_ROOT/lib/pkgconfig/librga.pc $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib/pkgconfig
cp $LIBRGA_ROOT/lib/librga.so $GSTREAMER_ROOT_ANDROID/arm64-v8a/lib
echo "done copy dependencies\n\n"

for TARGET in arm64
do
  NDK_APPLICATION_MK="jni/${TARGET}.mk"
  echo "\n\n=== Building GStreamer ${VERSION} for target ${TARGET} with ${NDK_APPLICATION_MK} ==="

  ndk-build NDK_DEBUG=1 NDK_APPLICATION_MK=$NDK_APPLICATION_MK

  if [ $TARGET = "arm64" ]; then
      LIB="arm64-v8a"
  fi;

  GST_LIB="gst-build-${LIB}"
  mkdir ${GST_LIB}

  cp -r libs/${LIB}/libgstreamer_android.so ${GST_LIB}
  cp -r $GSTREAMER_ROOT_ANDROID/${LIB}/lib/pkgconfig ${GST_LIB}

  echo 'Processing '$GST_LIB
  cd $GST_LIB
  sed -i -e 's?libdir=.*?libdir='`pwd`'?g' pkgconfig/*
  sed -i -e 's?.* -L${.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
  sed -i -e 's?Libs:.*?Libs: -L${libdir} -lgstreamer_android?g' pkgconfig/*
  sed -i -e 's?Libs.private.*?Libs.private: -lgstreamer_android?g' pkgconfig/*
  rm -rf pkgconfig/*pc-e*
  cd ..
  mkdir -p out/Gstreamer-$VERSION/$LIB/lib/
  cp -r $GST_LIB/libgstreamer_android.so  out/Gstreamer-$VERSION/$LIB/lib/
  rm -rf $GST_LIB
done

rm -rf libs obj src

# copy to Windows local file system
TARGET_PATH=/mnt/d/File/Android/GStreamerAndroid/gstreamer/src/main/cpp/gstreamer-$VERSION/arm64-v8a/lib/Debug
echo "copy libgstreamer_android.so to Windows file system at $TARGET_PATH"
cp gst-android-build/arm64-v8a/libgstreamer_android.so $TARGET_PATH

echo "\n*** Done ***\n`ls out`"
