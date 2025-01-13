# -----------------------------------------------------------------------------
#
# This file is part of the xPack project (http://xpack.github.io).
# Copyright (c) 2019 Liviu Ionescu. All rights reserved.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
#
# If a copy of the license was not distributed with this file, it can
# be obtained from https://opensource.org/licenses/mit/.
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function qemu_riscv_test()
{
  local test_bin_path="$1"

  echo
  echo "Checking the qemu shared libraries..."
  show_host_libs "${test_bin_path}/qemu-system-riscv32"
  show_host_libs "${test_bin_path}/qemu-system-riscv64"

  echo
  echo "Checking if qemu starts..."
  run_host_app_verbose "${test_bin_path}/qemu-system-riscv32" --version
  run_host_app_verbose "${test_bin_path}/qemu-system-riscv64" --version

  run_host_app_verbose "${test_bin_path}/qemu-system-riscv32" --help

  run_host_app_verbose "${test_bin_path}/qemu-system-riscv32" \
    --machine virt \
    --kernel "${root_folder_path}/test-assets/hello-world-rv32imac.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV32

  run_host_app_verbose "${test_bin_path}/qemu-system-riscv64" \
    --machine virt \
    --kernel "${root_folder_path}/test-assets/hello-world-rv64imafdc.elf" \
    -smp 1 \
    -bios none \
    --nographic \
    -d unimp,guest_errors \
    --semihosting-config enable=on,target=native,arg=hello-world,arg=RV64

  if [ "${XBB_IS_DEVELOP}" == "y" ]
  then
    echo
    echo "Showing supported machines/cpus..."

    run_host_app_verbose "${test_bin_path}/qemu-system-riscv32" -machine help
    run_host_app_verbose "${test_bin_path}/qemu-system-riscv32" -cpu help

    run_host_app_verbose "${test_bin_path}/qemu-system-riscv64" -machine help
    run_host_app_verbose "${test_bin_path}/qemu-system-riscv64" -cpu help
  fi

}

# -----------------------------------------------------------------------------
