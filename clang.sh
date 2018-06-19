#!/bin/bash

NC='\033[0m'
RED='\033[0;31m'
LGR='\033[1;32m'

readonly red=$(tput setaf 1) #  red
readonly grn=$(tput setaf 2) #  green
readonly ylw=$(tput setaf 3) #  yellow
readonly blu=$(tput setaf 4) #  blue
readonly cya=$(tput setaf 6) #  cyan
readonly txtbld=$(tput bold) # Bold
readonly bldred=$txtbld$red  #  red
readonly bldgrn=$txtbld$grn  #  green
readonly bldylw=$txtbld$ylw  #  yellow
readonly bldblu=$txtbld$blu  #  blue
readonly bldcya=$txtbld$cya  #  cyan
readonly txtrst=$(tput sgr0) # Reset

err() {
	echo "$txtrst${red}$*$txtrst" >&2
}

warn() {
	echo "$txtrst${ylw}$*$txtrst" >&2
}

info() {
	echo "$txtrst${grn}$*$txtrst"
}

setbuildjobs() {
	# Set build jobs
	JOBS=$(expr 0 + $(grep -c ^processor /proc/cpuinfo))
	info "Set build jobs to $JOBS"
}

WAKTUMULAI=$(date +"%s")

SAUCE=~/android/kernelcompile

KERNELSOURCE=~/synch/upstream111
ZIPOUTDIR=~/android/kernelcompile/mido-bin
#ZIPOUTDIR_M=~/android/kernelcompile/mido-bin/modules #new variable


info "Letak Kernel source : $KERNELSOURCE"
info "directory kerja : $SAUCE"

#perintah hapus ------------------------------------------->>>>>

cd $ZIPOUTDIR
rm -f *.zip
echo "sukses hapus zip"

cd $ZIPOUTDIR
rm -f Image.gz-dtb

echo "sukses Image.gz-dtb"
#akhir perintah hapus ---------------------------------------->>>>>


setbuildjobs

info "Pindah Ke Direktori kernel source"
cd $KERNELSOURCE

echo -e ${LGR} "############### branch active ################${NC}"
git branch -a
echo -e ${LGR} "############### branch active ################${NC}"

echo -e ${LGR} "############### Import Environment ################${NC}"
export KBUILD_BUILD_USER=Guzzo
export KBUILD_BUILD_HOST=f1ng3rcuss
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH=/home/cemplug/clang/bin
export PATH=${CLANG_PATH}:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export TCHAIN_PATH="/home/cemplug/gcc-linaro-7.2.1/bin/aarch64-linux-gnu-"
export CROSS_COMPILE="${CCACHE} ${TCHAIN_PATH}"
export CLANG_TCHAIN="/home/cemplug/clang/bin/clang"
export KBUILD_COMPILER_STRING="$(${CLANG_TCHAIN} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')"
echo -e ${LGR} "############### Environment Telah Siap ################${NC}"

make mrproper
make clean

echo -e ${RED} "# Bersihkan Source out Kernel Lama ! #"


make O=$SAUCE/mido mrproper
make O=$SAUCE/mido clean

echo -e ${LGR} "############### Sukses Dibersihkan ################${NC}"

echo -e ${RED} "# RESETING COUNT VERSION ! #"
echo 0 > $SAUCE/mido/.version
echo -e ${LGR} "############### Sukses Direset ################${NC}"


echo -e ${LGR} "############# Generating Defconfig For Redmi Nude 4x aka MIDO (Branch : Oreo Treble) ##############${NC}"
make CC=clang O=$SAUCE/mido mido_defconfig
echo -e ${LGR} "############### Succefully...... ################${NC}"

#echo -e ${RED} "# Config mido_menuconfig ! #"
make CC=clang O=$SAUCE/mido menuconfig 

echo -e ${LGR} "#################################################"
echo -e ${LGR} "############### Compiling Kernel ################"
echo -e ${LGR} "#################################################${NC}"
make CC=clang -j4 O=$SAUCE/mido

cp $SAUCE/mido/arch/arm64/boot/Image.gz-dtb $ZIPOUTDIR
#find $SAUCE/mido/ -type f -name *.ko -exec cp {} $SAUCE/mido-bin/modules/ \;
echo -e ${LGR} "############### Sukses Salin Image.gz-dtb ################${NC}"

cd $ZIPOUTDIR

WAKTUSAIKI=$(date +"%d-%m-%y-(%X)")

zip -r Kernel_v3.18.113_MIDO_oreo_TREBLE_CLANG-$WAKTUSAIKI.zip META-INF tools anykernel.sh Image.gz-dtb
echo -e ${LGR} "############### ZIP kernel sudah jadi ################${NC}"

WAKTUSELESAI=$(date +"%s")
ESTIMASIWAKTU=$(($WAKTUSELESAI - $WAKTUMULAI))

echo "Waktu Estimasi Compile : $(($ESTIMASIWAKTU / 60)) menit dan $(($ESTIMASIWAKTU % 60)) detik."
echo

echo -e ${LGR} "#################################################"
echo -e ${LGR} "############### Build competed! #################"
echo -e ${LGR} "#################################################${NC}"

date
echo "Generated Script by : $USER"


