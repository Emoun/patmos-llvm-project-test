#!/bin/sh -x
# Finalize build
set -e

# Loads variables
. ci/config.sh

cd $BUILD_DIR
# Assume already built
make $MAKE_FLAGS_REFRESH $TARGETS_STAGE_2 $TARGETS_UNIT_TESTS $TARGETS_REG_TESTS

# Ensure all required final targets are built
make $MAKE_FLAGS_BUILD $TARGETS_FINAL 
