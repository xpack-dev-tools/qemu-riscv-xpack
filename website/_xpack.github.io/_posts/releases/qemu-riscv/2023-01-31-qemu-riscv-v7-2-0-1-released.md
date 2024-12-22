---

title:  xPack QEMU RISC-V v7.2.0-1 released

summary: "Version **7.2.0-1** is a new release; it follows the upstream QEMU release."

version: "7.2.0-1"
npm_subversion: 1
qemu_version: "7.2.0"
qemu_short_commit: "b67b00e"
qemu_long_commit: "b67b00e6b4c7831a3f5bc684bc0df7a9bfd1bd56"
qemu_date: "Dec 13, 2022"

download_url: https://github.com/xpack-dev-tools/qemu-riscv-xpack/releases/tag/v7.2.0-1/

date: 2023-01-31 19:50:04 +0200

redirect_to: https://xpack-dev-tools.github.io/qemu-riscv-xpack/blog/2023/01/31/qemu-riscv-v7-2-0-1-released/

comments: true

categories:
  - releases
  - qemu-riscv

tags:
  - releases
  - qemu
  - emulator
  - risc-v

---

The [xPack QEMU RISC-V](https://xpack.github.io/dev-tools/qemu-riscv/)
is a standalone cross-platform binary distribution of
[QEMU](https://www.qemu.org).

There are separate binaries for **Windows** (x64),
**macOS** (x64, arm64)
and **GNU/Linux** (x64, arm64 and arm).

{% include note.html content="The main targets for the GNU/Linux Arm
binaries are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}

## Download

The binary files are available from [GitHub Releases]({{ page.download_url }}).

## Prerequisites

- x64 GNU/Linux: any system with **GLIBC 2.27** or higher
  (like Ubuntu 18 or later, Debian 10 or later, RedHat 8 or later,
  Fedora 29 or later, etc)
- arm64/arm GNU/Linux: any system with **GLIBC 2.27** or higher
  (like Raspberry Pi OS, Ubuntu 18 or later, Debian 10 or later, RedHat 8 or later,
  Fedora 29 or later, etc)
- x64 Windows: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- x64 macOS: 10.13 or later
- arm64 macOS: 11.6 or later

On GNU/Linux, QEMU requires the X11 libraries to be present. On Debian derived
distribution they are already in the system; on RedHat & Arch derived
distributions they must be installed explicitly.

## Install

The full details of installing the **xPack QEMU RISC-V** on various platforms
are presented in the separate [Install]({{ site.baseurl }}/dev-tools/qemu-riscv/install/) page.

### Easy install

The easiest way to install QEMU RISC-V is with
[`xpm`]({{ site.baseurl }}/xpm/)
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
xpm install @xpack-dev-tools/qemu-riscv@{{ page.version }}.{{ page.npm_subversion }}
```

For xPacks aware tools, like the **Eclipse Embedded C/C++ plug-ins**,
it is also possible to install QEMU RISC-V globally, in the user home folder.

```sh
xpm install --global @xpack-dev-tools/qemu-riscv@latest --verbose
```

Eclipse will automatically
identify binaries installed with
`xpm` and provide a convenient method to manage paths.

### Uninstall

To remove the links created by xpm in the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/qemu-riscv
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/qemu-riscv
```

## Compliance

The xPack QEMU RISC-V currently is based on the official [QEMU](https://www.qemu.org),
with no major changes.

The current version is based on:

- QEMU version {{ page.qemu_version }},
  commit [{{ page.qemu_short_commit }}](https://github.com/xpack-dev-tools/qemu/commit/{{ page.qemu_long_commit }})
  from {{ page.qemu_date }}.

## Changes

Compared to the master `qemu-system-riscv*`, there are no major changes.

The supported boards and CPUs are:

```console
$ .../xpack-qemu-riscv-7.0.0-1/bin/qemu-system-riscv32 -machine help
Supported machines are:
none                 empty machine
opentitan            RISC-V Board compatible with OpenTitan
sifive_e             RISC-V Board compatible with SiFive E SDK
sifive_u             RISC-V Board compatible with SiFive U SDK
spike                RISC-V Spike board (default)
virt                 RISC-V VirtIO board
$ .../xpack-qemu-riscv-7.0.0-1/bin/qemu-system-riscv32 -cpu help
any
lowrisc-ibex
rv32
sifive-e31
sifive-e34
sifive-u34

$ .../xpack-qemu-riscv-7.0.0-1/bin/qemu-system-riscv64 -machine help
Supported machines are:
microchip-icicle-kit Microchip PolarFire SoC Icicle Kit
none                 empty machine
shakti_c             RISC-V Board compatible with Shakti SDK
sifive_e             RISC-V Board compatible with SiFive E SDK
sifive_u             RISC-V Board compatible with SiFive U SDK
spike                RISC-V Spike board (default)
virt                 RISC-V VirtIO board
$ .../xpack-qemu-riscv-7.0.0-1/bin/qemu-system-riscv64 -cpu help
any
rv64
shakti-c
sifive-e51
sifive-u54
x-rv128
```

## Bug fixes

- none

## Enhancements

- none

## Known problems

- in order to build on macOS 10.13, the x64 macOS version has
  some functionality related to bridged virtual interfaces disabled.

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

The original documentation is available on-line:

- <https://www.qemu.org/docs/master/>

## Build

The binaries for all supported platforms
(Windows, macOS and GNU/Linux) were built using the
[xPack Build Box (XBB)](https://xpack.github.io/xbb/), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/qemu-riscv-xpack/blob/xpack/README-MAINTAINER.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/qemu-riscv-xpack/actions/)
- [Travis CI](https://app.travis-ci.com/github/xpack-dev-tools/qemu-riscv-xpack/builds/)

## Tests

TBD

## Checksums

The SHA-256 hashes for the files are:

```txt
f5b96416d4c73448e02fe9ad07bd311a60206fc400beb21aff8e522d087bdf60
xpack-qemu-riscv-7.2.0-1-darwin-arm64.tar.gz

33d853ee26dba75bf44d95d87a4f39b178399b8f197416c807f04a1a73f8981a
xpack-qemu-riscv-7.2.0-1-darwin-x64.tar.gz

49fa8a3bfd8ac672267ad0df7f9e6b973ff0d293b5cb277084c6711d2fc1582a
xpack-qemu-riscv-7.2.0-1-linux-arm.tar.gz

b3e275f83414adb5135cd6c9d2948016f17dbdafd6312d16644d5be04e101c1f
xpack-qemu-riscv-7.2.0-1-linux-arm64.tar.gz

c57b420223b5568b88ff81441608e83d61535886049ded60189790acddb492f3
xpack-qemu-riscv-7.2.0-1-linux-x64.tar.gz

5658cfc1f2f83dd546bbb674faff76ea438b7ac7f8346d46a85837136b0abc69
xpack-qemu-riscv-7.2.0-1-win32-x64.zip

```

## Deprecation notices

### 32-bit support

Support for 32-bit x86 GNU/Linux and x86 Windows was
dropped in 2022. Support for 32-bit Arm GNU/Linux (armv7l) will be preserved
for a while, due to the large user base of 32-bit Raspberry Pi systems.

### GNU/Linux minimum requirements

Support for RedHat 7 was dropped in 2022, and the
minimum requirement was raised to GLIBC 2.27, available starting
with Ubuntu 18 and RedHat 8.

## Download analytics

- GitHub [xpack-dev-tools/qemu-riscv-xpack](https://github.com/xpack-dev-tools/qemu-riscv-xpack/)
  - this release [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/qemu-riscv-xpack/v{{ page.version }}/total.svg)](https://github.com/xpack-dev-tools/qemu-riscv-xpack/releases/v{{ page.version }}/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/qemu-riscv-xpack/total.svg)](https://github.com/xpack-dev-tools/qemu-riscv-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=qemu-riscv-xpack) (grouped per release)
- npmjs.com [@xpack-dev-tools/qemu-riscv](https://www.npmjs.com/package/@xpack-dev-tools/qemu-riscv)
  - latest releases [![npm](https://img.shields.io/npm/dw/@xpack-dev-tools/qemu-riscv.svg)](https://www.npmjs.com/package/@xpack-dev-tools/qemu-riscv/)
  - all @xpack-dev-tools releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/qemu-riscv.svg)](https://www.npmjs.com/package/@xpack-dev-tools/qemu-riscv/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
