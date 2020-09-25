Continuous Integration scripts
====================

These scripts are meant to be run by Travis-CI for testing and deploying the project binaries.
However, they can also be used to build/test the project locally.
These scripts are meant to be run from the project root folder (`cd ..` from this folder.)

The scripts should be run in the following order:

- `get_dependencies`: Readies the machine to build/test LLVM
- `build_1`: Builds the LLVMCodeGen target only. This is to reduce the running time of subsequent scripts.
- `build_2`: Builds the UnitTests target only. This is to reduce the running time of subsequent scripts.
- `run_unit_regression_tests`: Builds the final targets required to run tests, then runs them.
- `build_final`: Build the last remaining targets.

Running them in a different order or skipping any of them may result in errors.
We also habe helper scripts:

- `config`: Includes numerous variables. Imported by each of the above scipts at the beginning to make use of the variables.
- `macos_update_make`: If run on MacOs, uses HomeBrew to update the installed GNU make to the newest version.

