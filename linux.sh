#!/bin/bash
echo -e "\033[0;32mHow many CPU cores do you want to be used in compiling process? (Default is 1. Press enter for default.)\033[0m"
read -e CPU_CORES
if [ -z "$CPU_CORES" ]
then
	CPU_CORES=1
fi

echo -e "\033[0;32mDo you want to disable the tests? (yes/no)\033[0m"
read -e TEST_ANSWER
case "$TEST_ANSWER" in
        [nN] | [n|N][O|o] ) TEST_STATUS='--enable-tests' 	# qt tests still have some problems
           ;;											# so use --without-gui
        [yY] | [yY][Ee][Ss] ) TEST_STATUS='--disable-tests'
           ;;
        *) TEST_STATUS='--disable-tests'
            ;;
esac

echo -e "\033[0;32mDo you want to disable the debug? (yes/no)\033[0m"
read -e DEBUG_ANSWER
case "$DEBUG_ANSWER" in
        [nN] | [n|N][O|o] ) DEBUG_STATUS='--enable-debug' 	# qt tests still have some problems
           ;;											# so use --without-gui
        [yY] | [yY][Ee][Ss] ) DEBUG_STATUS='--disable-debug'
           ;;
        *) DEBUG_STATUS='--disable-debug'
            ;;
esac

# Upgrade the system and install required dependencies
	sudo apt update
	sudo apt install git zip unzip build-essential libtool bsdmainutils autotools-dev autoconf pkg-config automake python3 libqt5svg5-dev -y

# Compile dependencies
   make clean
	cd depends
	make -j$(echo $CPU_CORES) HOST=x86_64-pc-linux-gnu 
	cd ..

# Compile
	./autogen.sh
	./configure --enable-glibc-back-compat --prefix=$(pwd)/depends/x86_64-pc-linux-gnu LDFLAGS="-static-libstdc++" --enable-cxx --enable-static --disable-shared $(echo $DEBUG_STATUS) $(echo $TEST_STATUS) --disable-bench --with-pic --enable-upnp-default CPPFLAGS="-fPIC -O3 --param ggc-min-expand=1 --param ggc-min-heapsize=32768" CXXFLAGS="-fPIC -O3 --param ggc-min-expand=1 --param ggc-min-heapsize=32768"
	make -j$(echo $CPU_CORES) HOST=x86_64-pc-linux-gnu
	cd ..

# Create zip file of binaries
	cp xln2.0.1/src/lunariumcoind xln2.0.1/src/lunariumcoin-cli xln2.0.1/src/lunariumcoin-tx xln2.0.1/src/qt/lunariumcoin-qt .
	zip XLN-$(git describe --abbrev=0 --tags | sed s/v//)Linux1804.zip lunariumcoind lunariumcoin-cli lunariumcoin-tx lunariumcoin-qt
	rm -f lunariumcoind lunariumcoin-cli lunariumcoin-tx lunariumcoin-qt
