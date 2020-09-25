#!/bin/sh -x
# Downloads and extract all dependencies necessary to build and test LLVM
set -e

# Loads variables
. ci/config.sh

GOLD_TAR=patmos-gold.tar.gz
SIMULAROT_TAR=patmos-simulator.tar.gz

GOLD_LINK=https://github.com/t-crest/patmos-gold/releases/download/v1.0.0-rc-1/patmos-gold-v1.0.0-rc-1.tar.gz
SIMULATOR_LINK=https://github.com/t-crest/patmos-simulator/releases/download/1.0.2/patmos-simulator-x86_64-linux-gnu.tar.gz

make --version

# Empty Travis-CI cache from last run (no-op if no cache)
rm -rf $BUILD_DIR

mkdir -p $PATH_DIR
cd $PATH_DIR

# Dowload Dependencies (compiler-rt, gold, patmos-simulator)
wget -O $GOLD_TAR $GOLD_LINK
wget -O $SIMULAROT_TAR $SIMULATOR_LINK

# Extract dependencies
tar -xvf $GOLD_TAR
tar -xvf $SIMULAROT_TAR

# Configure build
cd $BUILD_DIR

cmake $LLVM_DIR $CMAKE_FLAGS
