#!/bin/bash

if [ $FPGA_MACHINE != "VLAB" -a $FPGA_MACHINE != "LOCAL" ]; then
    echo Environment var FPGA_MACHINE not set! Source ../setenv.sh first
    exit
fi

if [ $1 != "TINY" -a $1 != "SMALL" -a $1 != "LARGE" ]; then
    echo Usage: ./tutorial.sh TINY[SMALL, LARGE] EMULATE[RUN]
    exit
fi

if [ $2 != "EMULATE" -a $2 != "RUN" ]; then
    echo Usage: ./tutorial.sh TINY[SMALL, LARGE] EMULATE[RUN]
    exit
fi

if [ "$1" == "TINY" ]; then
    let III=2
    let JJJ=2
    let KKK=2 # vector len: 2
    let II=2  # systolic array has 2 rows
    let JJ=2  # systolic array has 2 columns
    let KK=2
    let I=2
    let J=2
    let K=2
    echo cp sgemm.patch $HOME/tmp/sgemm.patch   
         cp sgemm.patch $HOME/tmp/sgemm.patch
else
    if [ "$1" == "SMALL" ]; then
        let III=4
        let JJJ=2
        let KKK=4 # vector len: 4
        let II=2  # systolic array has 2 rows
        let JJ=2  # systolic array has 2 columns
        let KK=2
        let I=2 
        let J=2
        let K=2
        echo "sed \'s/float2/float4/gI\' sgemm.patch > $HOME/tmp/sgemm.patch"
              sed 's/float2/float4/gI' sgemm.patch > $HOME/tmp/sgemm.patch
    else
        let III=49
        let JJJ=2
        let KKK=3
        let II=8
        let JJ=4
        let KK=3
        let I=32 
        let J=4
        let K=3
        echo cp sgemm-large.patch $HOME/tmp/sgemm.patch
             cp sgemm-large.patch $HOME/tmp/sgemm.patch
    fi    
fi
ARRAY_PARAMS="-DI=$I -DJ=$J -DK=$K -DII=$II -DJJ=$JJ -DKK=$KK -DIII=$III -DJJJ=$JJJ -DKKK=$KKK"
BITSTREAM_OPTS="-time time.out -time-passes -regtest_mode -v -g -fpc -fp-relaxed -report"

set -x
cp host.cpp ~/tmp ; cp sgemm.cpp ~/tmp ; cp -rf common ~/tmp; cd ~/tmp; rm -rf a a.* *.out

######### Test on the emulator ##############
# Compile the T2S specification        
g++ sgemm.cpp $ARRAY_PARAMS -g -I$T2S_PATH/Halide_CoreIR/include -L$T2S_PATH/Halide_CoreIR/bin -lHalide -std=c++11 -o sgemm.out

# From the T2S specification, generate an OpenCL file ~/tmp/a.cl
./sgemm.out

# Patch the OpenCL file for a missing optimization: overlap draining and failing of two adjacent invocations of the systolic array
patch -u -s a.cl sgemm.patch

# To workaround a aoc 17 bug, which gets stuck when some variable name has double underscore.
sed 's/__autorun__run_on_device/_autorun_run_on_device/gI' a.cl > tmp.cl; mv tmp.cl a.cl

# Compile the host code
if [ $FPGA_MACHINE == "LOCAL" ]; then     
    g++ host.cpp -g $ARRAY_PARAMS -DLINUX -DALTERA_CL -fPIC -Icommon/inc common/src/AOCLUtils/opencl.cpp common/src/AOCLUtils/options.cpp -I$ALTERAOCLSDKROOT/host/include $AOCL_LIBS -lelf -o host.out
else
    g++ host.cpp -g $ARRAY_PARAMS -DLINUX -DALTERA_CL -fPIC -Icommon/inc common/src/AOCLUtils/opencl.cpp common/src/AOCLUtils/options.cpp -I$ALTERAOCLSDKROOT/host/include $AOCL_LIBS -Wl,--no-as-needed -lalteracl  -lintel_opae_mmd -lrt -lelf -lrt -lpthread  -o host.out
fi

if [ "$2" == "EMULATE" ]; then
    # From the OpenCL file, generate a bitstream ~/tmp/a.aocx for an FPGA emulator
    rm -rf a a.aocx; aoc -march=emulator -emulator-channel-depth-model=strict $BITSTREAM_OPTS a.cl
    env CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 AOCX_FILE="$HOME/tmp/a.aocx" ./host.out
else
    # From the OpenCL file, generate a bitstream ~/tmp/a.aocx for an FPGA HW
    rm -rf a a.aocx; aoc $BITSTREAM_OPTS a.cl         
    qsub-fpga
    aocl program acl0 $HOME/tmp/a.aocx
    env AOCX_FILE="$HOME/tmp/a.aocx" aocl do ./host.out
fi

cd -
set +x
