# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function tests_update_system()
{
  local image_name="$1"

  # Make sure that the minimum prerequisites are met.
  if [[ ${image_name} == github-actions-ubuntu* ]]
  then
    : # sudo apt-get -qq install -y XXX
  elif [[ ${image_name} == *ubuntu* ]] || [[ ${image_name} == *debian* ]] || [[ ${image_name} == *raspbian* ]]
  then
    : # run_verbose apt-get -qq install --yes ...
  elif [[ ${image_name} == *centos* ]] || [[ ${image_name} == *redhat* ]] || [[ ${image_name} == *fedora* ]]
  then
    run_verbose yum install --assumeyes --quiet libX11
  elif [[ ${image_name} == *suse* ]]
  then
    run_verbose zypper --no-gpg-checks --quiet install --no-confirm libX11-6
  elif [[ ${image_name} == *manjaro* ]]
  then
    run_verbose pacman -S --noconfirm --noprogressbar --quiet libx11
  elif [[ ${image_name} == *archlinux* ]]
  then
    run_verbose pacman -S --noconfirm --noprogressbar --quiet libx11
  fi

  echo
  echo "The system C/C++ libraries..."
  find /usr/lib* /lib -name 'libc.*' -o -name 'libstdc++.*' -o -name 'libgcc_s.*'

  # build/linux-arm64/aarch64-unknown-linux-gnu/build/qemu-8.2.2/ui --interface-prefix org.qemu. --c-namespace QemuDBus --generate-c-code dbus-display1
  # Traceback (most recent call last):
  #   File "/home/ilg/Work/xpack-dev-tools/qemu-riscv-xpack.git/build/linux-arm64/aarch64-unknown-linux-gnu/install/bin/gdbus-codegen", line 53, in <module>
  #     from codegen import codegen_main
  #   File "/home/ilg/Work/xpack-dev-tools/qemu-riscv-xpack.git/build/linux-arm64/aarch64-unknown-linux-gnu/install/share/glib-2.0/codegen/codegen_main.py", line 30, in <module>
  #     from . import dbustypes
  #   File "/home/ilg/Work/xpack-dev-tools/qemu-riscv-xpack.git/build/linux-arm64/aarch64-unknown-linux-gnu/install/share/glib-2.0/codegen/dbustypes.py", line 22, in <module>
  #     from . import utils
  #   File "/home/ilg/Work/xpack-dev-tools/qemu-riscv-xpack.git/build/linux-arm64/aarch64-unknown-linux-gnu/install/share/glib-2.0/codegen/utils.py", line 22, in <module>
  #     import packaging.version
  # ModuleNotFoundError: No module named 'packaging'

  python3 -m pip install packaging
}

# -----------------------------------------------------------------------------
