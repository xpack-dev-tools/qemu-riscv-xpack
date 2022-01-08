# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2019 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the GNU MCU Eclipse build
# scripts. As the name implies, it should contain only functions and
# should be included with 'source' by the build scripts (both native
# and container).

# -----------------------------------------------------------------------------

function build_qemu_()
{
  if [ ! -d "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}" ]
  then
    (
      git_clone "${QEMU_GIT_URL}" "${QEMU_GIT_BRANCH}" \
          "${QEMU_GIT_COMMIT}" "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}"

      cd "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}"

      local patch_file="${BUILD_GIT_PATH}/patches/${QEMU_GIT_PATCH}"
      if [ -f "${patch_file}" ]
      then
        run_verbose git apply "${patch_file}"
      fi
    )
  fi
}

function build_qemu()
{
  # https://github.com/xpack-dev-tools/qemu
  # https://github.com/xpack-dev-tools/qemu/archive/refs/tags/v6.1.94-xpack-riscv.tar.gz

  # https://github.com/archlinux/svntogit-packages/blob/packages/qemu/trunk/PKGBUILD
  # https://github.com/archlinux/svntogit-community/blob/packages/libvirt/trunk/PKGBUILD

  # https://github.com/Homebrew/homebrew-core/blob/master/Formula/qemu.rb

  # https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-qemu/PKGBUILD

  local qemu_version="$1"

  qemu_src_folder_name="qemu-${qemu_version}.git"

  QEMU_GIT_URL=${QEMU_GIT_URL:-"https://github.com/xpack-dev-tools/qemu.git"}

  local qemu_folder_name="qemu-${qemu_version}"

  mkdir -pv "${LOGS_FOLDER_PATH}/${qemu_folder_name}/"

  local qemu_stamp_file_path="${INSTALL_FOLDER_PATH}/stamp-${qemu_folder_name}-installed"
  if [ ! -f "${qemu_stamp_file_path}" ] || [ "${IS_DEBUG}" == "y" ]
  then

    cd "${SOURCES_FOLDER_PATH}"

    if [ ! -d "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}" ]
    then
      git_clone "${QEMU_GIT_URL}" "${QEMU_GIT_BRANCH}" \
          "${QEMU_GIT_COMMIT}" "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}"
    fi

    (
      mkdir -p "${BUILD_FOLDER_PATH}/${qemu_folder_name}"
      cd "${BUILD_FOLDER_PATH}/${qemu_folder_name}"

      xbb_activate_installed_dev

      CPPFLAGS="${XBB_CPPFLAGS}"
      if [ "${IS_DEBUG}" == "y" ]
      then
        CPPFLAGS+=" -DDEBUG"
      fi

      CFLAGS="${XBB_CFLAGS_NO_W}"
      CXXFLAGS="${XBB_CXXFLAGS_NO_W}"

      LDFLAGS="${XBB_LDFLAGS_APP}"
      if [ "${TARGET_PLATFORM}" == "linux" ]
      then
        LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH}"
      elif [ "${TARGET_PLATFORM}" == "win32" ]
      then
        LDFLAGS+=" -fstack-protector"
      fi

      export CPPFLAGS
      export CFLAGS
      export CXXFLAGS

      export LDFLAGS

      (
        if [ ! -f "config.status" ]
        then

          if [ "${IS_DEVELOP}" == "y" ]
          then
            env | sort
          fi

          echo
          echo "Running qemu configure..."

          if [ "${IS_DEVELOP}" == "y" ]
          then
            # Although it shouldn't, the script checks python before --help.
            run_verbose bash "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}/configure" \
              --help
          fi

          config_options=()

          config_options+=("--prefix=${APP_PREFIX}")

          if [ "${TARGET_PLATFORM}" == "win32" ]
          then
            config_options+=("--cross-prefix=${CROSS_COMPILE_PREFIX}-")
          fi

          config_options+=("--bindir=${APP_PREFIX}/bin")
          config_options+=("--docdir=${APP_PREFIX_DOC}")
          config_options+=("--mandir=${APP_PREFIX_DOC}/man")

          config_options+=("--cc=${CC}")
          config_options+=("--cxx=${CXX}")

          # CFLAGS, CXXFLAGS and LDFLAGS are used directly.
          config_options+=("--extra-cflags=${CPPFLAGS}")
          config_options+=("--extra-cxxflags=${CPPFLAGS}")

          config_options+=("--target-list=riscv32-softmmu,riscv64-softmmu")

          if [ "${IS_DEBUG}" == "y" ]
          then
            config_options+=("--enable-debug")
          fi

          config_options+=("--enable-nettle")
          config_options+=("--enable-lzo")

          # Not toghether with nettle.
          # config_options+=("--enable-gcrypt")

          if [ "${TARGET_PLATFORM}" != "win32" ]
          then
            config_options+=("--enable-libssh")
            config_options+=("--enable-curses")
            config_options+=("--enable-vde")
          fi

          if [ "${TARGET_PLATFORM}" == "darwin" ]
          then
            # For now, Cocoa builds fail on macOS 10.13.
            if true
            then
              config_options+=("--disable-cocoa")
              config_options+=("--enable-sdl")
            else
              config_options+=("--enable-cocoa")
              config_options+=("--disable-sdl")
            fi
          else
            config_options+=("--enable-sdl")
          fi

          config_options+=("--disable-bsd-user")
          config_options+=("--disable-guest-agent")
          config_options+=("--disable-gtk")

          if [ "${WITH_STRIP}" != "y" ]
          then
            config_options+=("--disable-strip")
          fi

          config_options+=("--disable-werror")

          run_verbose bash ${DEBUG} "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}/configure" \
            ${config_options[@]}

        fi
        cp "config.log" "${LOGS_FOLDER_PATH}/${qemu_folder_name}/configure-log-$(ndate).txt"
      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${qemu_folder_name}/configure-output-$(ndate).txt"

      (
        echo
        echo "Running qemu make..."

        # Build.
        run_verbose make V=1 -j ${JOBS}

        run_verbose make install

        show_libs "${APP_PREFIX}/bin/qemu-img"

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${qemu_folder_name}/make-output-$(ndate).txt"

      copy_license \
        "${SOURCES_FOLDER_PATH}/${qemu_src_folder_name}" \
        "qemu-${QEMU_VERSION}"
    )

    touch "${qemu_stamp_file_path}"
  else
    echo "Component qemu already installed."
  fi

  tests_add "test_qemu"
}

function test_qemu()
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
  show_libs "${TEST_BIN_PATH}/qemu-img"
  show_libs "${TEST_BIN_PATH}/qemu-nbd"
  show_libs "${TEST_BIN_PATH}/qemu-io"

  echo
  echo "Checking if qemu starts..."
  run_app "${TEST_BIN_PATH}/qemu-system-riscv32" --version
  run_app "${TEST_BIN_PATH}/qemu-system-riscv64" --version
  run_app "${TEST_BIN_PATH}/qemu-img" --version
  run_app "${TEST_BIN_PATH}/qemu-nbd" --version
  run_app "${TEST_BIN_PATH}/qemu-io" --version

  run_app "${TEST_BIN_PATH}/qemu-system-riscv32" --help
}

# -----------------------------------------------------------------------------
