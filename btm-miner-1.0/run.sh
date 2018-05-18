#!/bin/bash

cd $(dirname $0)

if [ ! -f address.txt ];then
echo -e "\n file address.txt not exists! \n"
exit
fi

SMI=nvidia-smi

ADDR=$(cat address.txt | head -1 )

DRV=$( $SMI -h |grep Interface | awk -Fv '{print $2}' | cut -d. -f1 )
CARDS=$( $SMI -L | wc -l )

if [ $DRV -lt 387 ];then
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:cuda8
else
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:cuda9
fi

echo "Driver = $DRV , CARD COUNT=$CARDS"

cd btm-miner
./miner -user ${ADDR} -url stratum+tcp://btm.uupool.cn:9921 $@ 
