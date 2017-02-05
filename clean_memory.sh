#Terminal - Release memory used by the Linux kernel on caches 
free && sync && echo 3 > /proc/sys/vm/drop_caches && free

#Clear filesystem memory cache
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
