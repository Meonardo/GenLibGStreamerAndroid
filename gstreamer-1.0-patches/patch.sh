echo "Aplly patch 0001:"

patch -p1 < 0001-filesrc-Fix-stopping-race-in-pull-mode.patch

sleep 1

echo "Aplly patch 0002:"
patch -p1 < 0002-HACK-gstpad-Add-1-sec-timeout-for-activation.patch

sleep 1

echo "Aplly patch 0003:"
patch -p1 < 0003-HACK-caps-Consider-dmabuf-subset-of-system-memory.patch

sleep 1

echo "Aplly patch 0004:"
patch -p1 < 0004-gst-launch-Fix-random-hang-when-EOS.patch

echo "All done."