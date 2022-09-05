# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2019 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the xPack build scripts. As the name implies,
# it should contain only functions and should be included with 'source'
# by the build scripts (both native and container).

# -----------------------------------------------------------------------------

# A common build_qemu() is defined in the helper.

function test_qemu_riscv()
{
  if [ -d "xpacks/.bin" ]
  then
    TEST_BIN_PATH="$(pwd)/xpacks/.bin"
  elif [ -d "${APP_PREFIX}/bin" ]
  then
    TEST_BIN_PATH="${APP_PREFIX}/bin"
  else
    echo "Wrong folder."
    exit 1
  fi

  echo
  echo "Checking the qemu shared libraries..."
  show_libs "${TEST_BIN_PATH}/qemu-system-riscv32"
  show_libs "${TEST_BIN_PATH}/qemu-system-riscv64"

  echo
  echo "Checking if qemu starts..."
  run_app "${TEST_BIN_PATH}/qemu-system-riscv32" --version
  run_app "${TEST_BIN_PATH}/qemu-system-riscv64" --version

  run_app "${TEST_BIN_PATH}/qemu-system-riscv32" --help

  pwd
  env | sort

  run_app "${TEST_BIN_PATH}/qemu-system-riscv32" \
    --machine virt \
    --kernel "${tests_folder_path}/assets/hello-world-rv32imac.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV32

  run_app "${TEST_BIN_PATH}/qemu-system-riscv64" \
    --machine virt \
    --kernel "${tests_folder_path}/assets/hello-world-rv64imafdc.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV64

}

# -----------------------------------------------------------------------------
