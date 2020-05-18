#!/bin/bash

set -x
cd ~/tmp
# From the OpenCL file, generate a bitstream ~/tmp/a.aocx for an FPGA emulator

ARRAY_PARAMS="-DI=$I -DJ=$J -DK=$K -DII=$II -DJJ=$JJ -DKK=$KK -DIII=$III -DJJJ=$JJJ -DKKK=$KKK"
BITSTREAM_OPTS="-time time.out -time-passes -regtest_mode -v -g -fpc -fp-relaxed -report"

    #rm -rf a a.aocx; aoc -march=emulator -emulator-channel-depth-model=strict $BITSTREAM_OPTS a.cl
	#env CL_CONTEXT_EMULATOR_DEVICE_INTELFPGA=1 AOCX_FILE="$HOME/tmp/a.aocx" ./host.out 

rm -rf a a.aocx;aoc $BITSTREAM_OPTS a.cl  
         
qsub-fpga
aocl program acl0 $HOME/tmp/a.aocx
env AOCX_FILE="$HOME/tmp/a.aocx" aocl do ./host.out
cd -
set +x

