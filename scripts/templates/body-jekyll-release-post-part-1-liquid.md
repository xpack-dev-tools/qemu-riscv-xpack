---
title:  xPack QEMU RISC-V {{ RELEASE_VERSION }} released

summary: "Version **{{ RELEASE_VERSION }}** is a maintenance release; it fixes several bugs."

version: {{ RELEASE_VERSION }}
npm_subversion: 1
download_url: https://github.com/xpack-dev-tools/qemu-riscv-xpack/releases/tag/v{{ RELEASE_VERSION }}/

date:   {{ RELEASE_DATE }}

categories:
  - releases
  - qemu

tags:
  - releases
  - qemu
  - emulator
  - arm
  - cortex-m

---

[The xPack QEMU RISC-V](https://xpack.github.io/qemu-riscv/)
is a standalone cross-platform binary distribution of
[QEMU](http://www.qemu.org), with several extensions for Arm Cortex-M
devices.

There are separate binaries for **Windows** (Intel 32/64-bit),
**macOS** (Intel 64-bit) and **GNU/Linux** (Intel 32/64-bit, Arm 32/64-bit).

{% raw %}{% include note.html content="The main targets for the Arm binaries
are the **Raspberry Pi** class devices." %}{% endraw %}

## Download

The binary files are available from GitHub [Releases]({% raw %}{{ page.download_url }}{% endraw %}).

## Prerequisites

- Intel GNU/Linux 32/64-bit: any system with **GLIBC 2.15** or higher
  (like Ubuntu 12 or later, Debian 8 or later, RedHat/CentOS 7 later,
  Fedora 20 or later, etc)
- Arm GNU/Linux 32/64-bit: any system with **GLIBC 2.23** or higher
  (like Ubuntu 16 or later, Debian 9 or later, RedHat/CentOS 8 or later,
  Fedora 24 or later, etc)
- Intel Windows 32/64-bit: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- Intel macOS 64-bit: 10.13 or later

On GNU/Linux, QEMU requires the X11 libraries to be present. On Debian derived
distribution they are already in the system; on RedHat & Arch derived
distributions they must be installed explicitly.

## Install

The full details of installing the **xPack QEMU RISC-V** on various platforms
are presented in the separate
[Install]({% raw %}{{ site.baseurl }}{% endraw %}/qemu-riscv/install/) page.

### Easy install

The easiest way to install QEMU RISC-V is with
[`xpm`]({% raw %}{{ site.baseurl }}{% endraw %}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/qemu-riscv`](https://www.npmjs.com/package/@xpack-dev-tools/qemu-riscv)
from the [`npmjs.com`](https://www.npmjs.com) registry.

With the `xpm` tool available, installing
the latest version of the package and adding it as
a dependency for a project is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/qemu-riscv@latest

ls -l xpacks/.bin
```

To install this specific version, use:

```sh
xpm install @xpack-dev-tools/qemu-riscv@{% raw %}{{ page.version }}.{{ page.npm_subversion }}{% endraw %}
```

For xPacks aware tools, like the **Eclipse Embedded C/C++ plug-ins**,
it is also possible to install QEMU RISC-V globally, in the user home folder.

```sh
xpm install --global @xpack-dev-tools/qemu-riscv@latest
```

Eclipse will automatically
identify binaries installed with
`xpm` and provide a convenient method to manage paths.

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/qemu-riscv
```

To completely remove the package from the global store:

```sh
xpm uninstall --global @xpack-dev-tools/qemu-riscv
```

## Compliance

The xPack QEMU RISC-V currently is based on the official [QEMU](http://www.qemu.org),
with major changes.

The current version is based on:

- QEMU version 6.1.0, commit [0737f32](https://github.com/xpack-dev-tools/qemu/commit/0737f32daf35f3730ed2461ddfaaf034c2ec7ff0) from Dec 20th, 2016.

## Changes

Compared to the master `qemu-system-arm`, the changes are major, all
application class Arm
devices were removed and replaced by several Cortex-M devices.

The supported boards are:

```console
xPack 64-bit QEMU v6.1.0 (qemu-system-riscv32).

Supported boards:
...
Supported MCUs:
...
```

Warning: support for hardware floating point on Cortex-M4 devices is not
available yet.

## Bug fixes

- none

## Enhancements

- none

## Known problems

- Ctrl-C does not interrupt the execution if the `--nographic` option is used.

## Shared libraries

On all platforms the packages are standalone, and expect only the standard
runtime to be present on the host.

All dependencies that are build as shared libraries are copied locally
in the `libexec` folder (or in the same folder as the executable for Windows).

### `DT_RPATH` and `LD_LIBRARY_PATH`

On GNU/Linux the binaries are adjusted to use a relative path:

```console
$ readelf -d library.so | grep runpath
 0x000000000000001d (RPATH)            Library rpath: [$ORIGIN]
```

In the GNU ld.so search strategy, the `DT_RPATH` has
the highest priority, higher than `LD_LIBRARY_PATH`, so if this later one
is set in the environment, it should not interfere with the xPack binaries.

Please note that previous versions, up to mid-2020, used `DT_RUNPATH`, which
has a priority lower than `LD_LIBRARY_PATH`, and does not tolerate setting
it in the environment.

### `@rpath` and `@loader_path`

Similarly, on macOS, the binaries are adjusted with `install_name_tool` to use a
relative path.

## Documentation

The original documentation is available in the `share/doc` folder.

## Build

The binaries for all supported platforms
(Windows, macOS and GNU/Linux) were built using the
[xPack Build Box (XBB)](https://xpack.github.io/xbb/), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[How to build](https://github.com/xpack-dev-tools/qemu-riscv-xpack/blob/xpack/README-BUILD.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/qemu-riscv-xpack/actions/)
- [travis-ci.com](https://app.travis-ci.com/github/xpack-dev-tools/qemu-riscv-xpack/builds/)

## Tests

The binaries were testes on Windows 10 Pro 32/64-bit, Intel Ubuntu 18
LTS 64-bit, Intel Xubuntu 18 LTS 32-bit and macOS 10.15.

The tests consist in running a simple blinky application
on the graphically emulated STM32F4DISCOVERY board. The binaries were
those generated by
[simple Eclipse projects](https://github.com/xpack-dev-tools/arm-none-eabi-gcc-xpack/tree/xpack/tests/eclipse)
available in the **xPack GNU Arm Embedded GCC** project. Use the
`arm-f4b-fs-debug-qemu` debug luncher available in the `arm-f4b-fs` project.

On platforms where Eclipse is not available, the binaries were
tested by manually starting the
blinky test on the emulated STM32F4DISCOVERY board.

```console
.../xpack-qemu-riscv-6.1.0-1/bin/qemu-system-gnuarmeclipse --version
...


```

On Raspberry Pi OS 10 (buster) 64-bit the program was able to run in non
graphic mode, but did not start in graphic mode due to a
missing driver. To be further investigated.

## Checksums

The SHA-256 hashes for the files are:
