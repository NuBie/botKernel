#!/bin/bash

#blink_red='\033[05;31m'

WORKINGOUTDIR=~/android/kernelcompile/espresso-bin
cd $WORKINGOUTDIR
WAKTUSAIKI=$(date +"%d-%m-%y-(%X)_$RANDOM")

WAKTUMULAI=$(date +"%s")
zip -r Espresso_Kernel_Kopi_Luwak_$WAKTUSAIKI.zip META-INF modules tools anykernel.sh cemplug zImage

WAKTUSELESAI=$(date +"%s")
ESTIMASIWAKTU=$(($WAKTUSELESAI - $WAKTUMULAI))

#echo -e "${blink_red}"
echo "Waktu Estimasi : $(($ESTIMASIWAKTU / 60)) menit dan $(($ESTIMASIWAKTU % 60)) detik."
echo
date
echo "Generated Script by : $USER"

