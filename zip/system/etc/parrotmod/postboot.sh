#!/system/bin/sh
bb=/system/etc/parrotmod/busybox

while $bb test "$(getprop sys.boot_completed)" != "1"; do sleep 1; done

sleep 2

#block ota
pm disable 'com.google.android.gms/.update.SystemUpdateActivity'
pm disable 'com.google.android.gms/.update.SystemUpdateService$ActiveReceiver'
pm disable 'com.google.android.gms/.update.SystemUpdateService$Receiver'
pm disable 'com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver'
pm disable 'com.google.android.gsf/.update.SystemUpdateActivity'
pm disable 'com.google.android.gsf/.update.SystemUpdatePanoActivity'
pm disable 'com.google.android.gsf/.update.SystemUpdateService$Receiver'
pm disable 'com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver'

if $bb test "$(cat /data/system/parrotmod_univ_last_version)" != "2.0.0"; then

  echo "2.0.0" > /data/system/parrotmod_univ_last_version
  
  if $bb test -e "/system/bin/settings"; then # not 4.1, which doesn't have these 2 settings anyway
    settings put global fstrim_mandatory_interval 0 # never
    settings put global storage_benchmark_interval -1 # never
  fi

  $bb sync
  reboot # the other code didn't work sometimes 
fi

# for (mostly) fixing audio stutter when multitasking

$bb renice -10 $($bb pidof hd-audio0)
$bb ionice -c 1 -n 2 -p $($bb pidof hd-audio0)
$bb renice -10 $($bb pidof mediaserver)
$bb ionice -c 1 -n 5 -p $($bb pidof mediaserver)

echo "0,1,2,4,7,15" > /sys/module/lowmemorykiller/parameters/adj  # https://android.googlesource.com/platform/frameworks/base/+/master/services/core/java/com/android/server/am/ProcessList.java#50
echo "8192,10240,12288,14336,16384,20480" > /sys/module/lowmemorykiller/parameters/minfree # the same as Moto G 5.1, and AOSP 4.x
$bb chmod -R 0555 /sys/module/lowmemorykiller/parameters # so android can't edit it
