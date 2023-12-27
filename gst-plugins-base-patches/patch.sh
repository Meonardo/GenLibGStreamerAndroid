echo "Aplly patch 0008:"

patch -p1 < 0008-video-converter-Support-rockchip-RGA-2D-accel.patch

sleep 1

echo "Aplly patch 0009:"
patch -p1 < 0009-HACK-gl-egl-allow-direct-dmabuf-import-when-unable-t.patch

sleep 1

echo "Aplly patch 0010:"
patch -p1 < 0010-glupload-dmabuf-prefer-DirectDmabufExternal-uploader.patch

sleep 1

echo "Aplly patch 0011:"
patch -p1 < 0011-videoconvert-Support-preferred-formats.patch

sleep 1

echo "Aplly patch 0012:"
patch -p1 < 0012-glupload-Support-NV12_10LE40-and-NV12-NV12_10LE40-NV.patch

sleep 1

echo "Aplly patch 0021:"
patch -p1 < 0021-gst-libs-Support-NV16_10LE40.patch

sleep 1

echo "Aplly patch 0022:"
patch -p1 < 0022-videodecoder-Allow-disabling-QoS-by-default.patch

echo "All done."