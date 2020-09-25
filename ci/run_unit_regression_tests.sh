#!/bin/sh -x
# Build targets required for unit/regression test, then run tests.
set -e

# Loads variables
. ci/config.sh

cd $BUILD_DIR
# Assume already built
make $MAKE_FLAGS_REFRESH $TARGETS_STAGE_2

# Build targets required for running unit tests
make $MAKE_FLAGS_BUILD $TARGETS_UNIT_TESTS $TARGETS_REG_TESTS 

# All binaries now need execute permission
chmod +x $BUILD_DIR/bin/*

# Make filter to exlude some tests
# Split paranthesis to avoid the shell treating it as an executable
FILTER="^((?!"
FILTER="${FILTER}($EXCLUDE_TESTS"
FILTER="${FILTER})).)*\$"

# Run regression tests batches to ensure output is produced regularly
SHARDS=8
# Track whether any test shards failed (1 means all success, 0 for failures)
TEST_SUCCESS=1
for i in $(seq 1 $SHARDS)
do
	if ! ./bin/llvm-lit $LLVM_DIR/test --filter=$FILTER --num-shards $SHARDS --run-shard $i -s --no-progress-bar -v; then
		TEST_SUCCESS=0
	fi
done 

# Check that no tests failed
if [ $TEST_SUCCESS -eq 0 ]; then
	echo "Test Failure"
	exit 1
else
	echo "Test Success"
fi
