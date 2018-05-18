export DISPLAY=:0
/usr/bin/nvidia-settings -a GPUFanControlState=1 -a GPUTargetFanSpeed=90
/usr/bin/nvidia-settings -a GPUPowerMizerMode=1 -a GPUMemoryTransferRateOffset[2]=1400
/home/easyminer/claymore_ethminer/ethdcrminer64 -epool eth-eu1.nanopool.org:9999 -ewal 0x1c8067528a3ccd5f2c756eb5f648d7f2ce96f633.default/emptyset110@gmail.com -epsw x -mode 1 -ftime 10 -minspeed 100

