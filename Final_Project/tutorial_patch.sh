#!/bin/bash

set -x
cd ~/tmp;
# Patch the OpenCL file for a missing optimization: overlap draining and failing of two adjacent invocations of the systolic array
# patch -u -s a.cl sgemm.patch
        let III=49
        let JJJ=2
        let KKK=3
        let II=8
        let JJ=4
        let KK=3
        let I=32 
        let J=4
        let K=3
ARRAY_PARAMS="-DI=$I -DJ=$J -DK=$K -DII=$II -DJJ=$JJ -DKK=$KK -DIII=$III -DJJJ=$JJJ -DKKK=$KKK"
BITSTREAM_OPTS="-time time.out -time-passes -regtest_mode -v -g -fpc -fp-relaxed -report"
# To workaround a aoc 17 bug, which gets stuck when some variable name has double underscore.
sed 's/__autorun__run_on_device/_autorun_run_on_device/gI' a.cl > tmp.cl; mv tmp.cl a.cl

# Compile the host code
if [ $FPGA_MACHINE == "LOCAL" ]; then     
    g++ host.cpp -g $ARRAY_PARAMS -DLINUX -DALTERA_CL -fPIC -Icommon/inc common/src/AOCLUtils/opencl.cpp common/src/AOCLUtils/options.cpp -I$ALTERAOCLSDKROOT/host/include $AOCL_LIBS -lelf -o host.out
else
    g++ host.cpp -g $ARRAY_PARAMS -DLINUX -DALTERA_CL -fPIC -Icommon/inc common/src/AOCLUtils/opencl.cpp common/src/AOCLUtils/options.cpp -I$ALTERAOCLSDKROOT/host/include $AOCL_LIBS -Wl,--no-as-needed -lalteracl  -lintel_opae_mmd -lrt -lelf -lrt -lpthread  -o host.out -L/export/fpga/tools/quartus_pro/17.1.1/hld/linux64/lib -L/export/fpga/release/a10_gx_pac_ias_1_1_pv/opencl/opencl_bsp/linux64/lib  -L/export/fpga/tools/quartus_pro/17.1.1/hld/host/linux64/lib -Wl,--no-as-needed -lalteracl  -lintel_opae_mmd -lrt -lelf -lrt -lpthread -lintel_opae_mmd -lrt -lelf -L/opt/aalsdk/sdk502/lib -Wl,-rpath=/opt/aalsdk/sdk502/lib
fi

set +x
