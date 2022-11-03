# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2019 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function test_qemu_riscv()
{
  local test_bin_path="$1"

  echo
  echo "Checking the qemu shared libraries..."
  show_libs "${test_bin_path}/qemu-system-riscv32"
  show_libs "${test_bin_path}/qemu-system-riscv64"

  echo
  echo "Checking if qemu starts..."
  run_app "${test_bin_path}/qemu-system-riscv32" --version
  run_app "${test_bin_path}/qemu-system-riscv64" --version

  run_app "${test_bin_path}/qemu-system-riscv32" --help

  run_app "${test_bin_path}/qemu-system-riscv32" \
    --machine virt \
    --kernel "${project_folder_path}/tests/assets/hello-world-rv32imac.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV32

  run_app "${test_bin_path}/qemu-system-riscv64" \
    --machine virt \
    --kernel "${project_folder_path}/tests/assets/hello-world-rv64imafdc.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV64

}

# -----------------------------------------------------------------------------
