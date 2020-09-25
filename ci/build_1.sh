#!/bin/sh -x
# Part 1 of building LLVM
set -e

# Loads variables
. ci/config.sh

cd $BUILD_DIR
make $MAKE_FLAGS_BUILD $TARGETS_STAGE_1