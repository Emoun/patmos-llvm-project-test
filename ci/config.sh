#!/bin/sh -x
# Variables shared between scripts
set -e

OS_NAME=$(uname -s)
# Whether the local host OS is MacOs 
MACOS=0
if [ "$OS_NAME" = "Darwin" ]; then
	MACOS=1
	# Update path to make sure we us Brew's make installation
	export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
fi

# Figure out what target architecture to build for
if [ "$TARGETS" = "x86" ]; then
	BUILD_TARGET="X86"
else
	BUILD_TARGET="X86"
fi

# Root directory of the project. If not run in Travis, assume current directory is root.
ROOT_DIR=${TRAVIS_BUILD_DIR:=$(pwd)} 

BUILD_DIR=$ROOT_DIR/build
PATH_DIR=$BUILD_DIR/local
BENCH_DIR=$BUILD_DIR/bench
LLVM_DIR=$ROOT_DIR/llvm

JOB_COUNT=2
MAKE_FLAGS_BUILD="-j$JOB_COUNT"
MAKE_FLAGS_REFRESH="--touch -j$JOB_COUNT"

# Build targets

# Targets to build in stage 1
TARGETS_STAGE_1=LLVMCodeGen
# Targets to build in stage 2
TARGETS_STAGE_2=UnitTests
# Additional targets to build before unit tests
TARGETS_UNIT_TESTS="FileCheck count not lli llvm-strip llvm-install-name-tool dsymutil lli-child-target llvm-as llvm-bcanalyzer llvm-config llvm-cov llvm-cxxdump llvm-cvtres llvm-diff llvm-dis llvm-dwarfdump llvm-exegesis llvm-extract llvm-isel-fuzzer llvm-ifs llvm-jitlink llvm-opt-fuzzer llvm-lib llvm-link llvm-lto llvm-lto2 llvm-mc llvm-mca llvm-modextract llvm-nm llvm-objdump llvm-pdbutil llvm-profdata llvm-ranlib llvm-rc llvm-readelf llvm-rtdyld llvm-size llvm-split llvm-strings llvm-undname llvm-c-test llvm-cxxfilt llvm-xray yaml2obj obj2yaml yaml-bench verify-uselistorder bugpoint llc llvm-symbolizer opt sancov sanstats"
# Additional targets to build before regression tests
TARGETS_REG_TESTS="BugpointPasses llvm-cat llvm-opt-report llvm-mt llvm-addr2line llvm-dwp llvm-reduce llvm-lipo llvm-elfabi llvm-dlltool llvm-cxxmap llvm-cfi-verify"
# Final targets to export
TARGETS_FINAL="llc llvm-link clang llvm-config llvm-objdump opt"

# Pipe ("|") seperated list of unit/regression test to not test.
# These should be native LLVM tests that fail for some reason that has nothing
# to do with patmos.
# This list should be kept minimal to ensure that we do not change incompatible changes
# to LLVM code.
EXCLUDE_TESTS="Other/can-execute|tools/llvm-lipo/create-executable.test|tools/llvm-lipo/thin-executable-universal-binary.test" 

# CMAKE options
CMAKE_FLAGS="\
	-DCMAKE_CXX_STANDARD=14 \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=local \
	-DLLVM_TARGETS_TO_BUILD=$BUILD_TARGET \
	-DLLVM_ENABLE_PROJECTS=clang \
	-DCLANG_ENABLE_ARCMT=false \
	-DCLANG_ENABLE_STATIC_ANALYZER=false \
	-DCLANG_BUILD_EXAMPLES=false \
	-DLLVM_ENABLE_BINDINGS=false \
	-DLLVM_INSTALL_BINUTILS_SYMLINKS=false \
	-DLLVM_INSTALL_CCTOOLS_SYMLINKS=false \
	-DLLVM_INCLUDE_EXAMPLES=false \
	-DLLVM_INCLUDE_BENCHMARKS=false \
	-DLLVM_APPEND_VC_REV=false \
	-DLLVM_ENABLE_WARNINGS=false \
	-DLLVM_ENABLE_PEDANTIC=false \
	-DLLVM_ENABLE_LIBPFM=false \
	-DLLVM_BUILD_INSTRUMENTED_COVERAGE=false \
	-DLLVM_INSTALL_UTILS=false 
"
if [ "$ASSERTIONS" = "true" ]; then
	CMAKE_FLAGS="$CMAKE_FLAGS -DLLVM_ENABLE_ASSERTIONS=true"
fi