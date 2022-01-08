# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2019 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the GNU MCU Eclipse build
# scripts. As the name implies, it should contain only functions and
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

function build_versions()
{
  if [ "${TARGET_PLATFORM}" == "win32" ]
  then
    prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
  elif [ "${TARGET_PLATFORM}" == "darwin" ]
  then
    # Otherwise it fails with:
    # error: 'macOS' undeclared (first use in this function)
    # if (__builtin_available(macOS 11.0, *)) {
    prepare_clang_env ""
  fi

  export QEMU_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-.*||')"

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 6\.2\.*-* ]]
  then

    # -------------------------------------------------------------------------

    if [[ "${RELEASE_VERSION}" =~ 6\.2\.0-1 ]]
    then
      (
        xbb_activate

        QEMU_GIT_BRANCH=${QEMU_GIT_BRANCH:-"xpack-riscv-develop"}
        QEMU_GIT_COMMIT=${QEMU_GIT_COMMIT:-"v${QEMU_VERSION}-xpack-riscv"}

        build_zlib "1.2.11"

        if [ "${TARGET_PLATFORM}" != "win32" ]
        then
          build_bzip2 "1.0.8"
        fi

        build_zstd "1.5.0"

        # required by nettle
        build_gmp "6.2.1"

        build_libpng "1.6.37"
        build_jpeg "9d"

        if [ "${TARGET_PLATFORM}" != "win32" ]
        then
          build_libxml2 "2.9.11"
        fi

        # required by glib
        build_libiconv "1.16"

        if [ "${TARGET_PLATFORM}" == "darwin" ]
        then
          : # On macOS use Cocoa.
        else
          build_sdl2 "2.0.18"
          build_sdl2_image "2.0.5"
        fi

        # required by glib
        build_libffi "3.4.2"

        # required by glib
        build_gettext "0.21"

        # TODO "2.70.2" (meson)
        build_glib "2.56.4" #

        # Not toghether with nettle.
        # build_libgpg_error "1.43"
        # build_libgcrypt "1.9.4"

        # https://github.com/Homebrew/homebrew-core/blob/master/Formula/gnutls.rb
        # gnutls

        # libslirp

        # libcurl


        if [ "${TARGET_PLATFORM}" != "win32" ]
        then
          # required by libssh
          build_openssl "1.1.1l"

          build_libssh "0.9.6"


          build_ncurses "6.3"
        fi

        if [ "${TARGET_PLATFORM}" == "win32" ]
        then
          # TODO: check if QEMU can use it or something else is needed.
          build_libusb_w32 "1.2.6.0"
        else
          build_libusb "1.0.24"
        fi

        build_lzo "2.10"

        build_nettle "3.7.3"

        build_pixman "0.40.0"

        # https://github.com/Homebrew/homebrew-core/blob/master/Formula/snappy.rb
        # snappy - Compression/decompression library aiming for high speed

        if [ "${TARGET_PLATFORM}" != "win32" ]
        then
          # required by vde
          build_libpcap "1.10.1"
          build_vde "2.3.2"
        fi

        build_qemu "${QEMU_VERSION}"
      )

    # -------------------------------------------------------------------------
    else
      echo "Unsupported version ${RELEASE_VERSION}."
      exit 1
    fi

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
