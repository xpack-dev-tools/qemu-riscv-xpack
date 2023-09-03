---
title:  xPack QEMU RISC-V v{{ XBB_RELEASE_VERSION }} released

TODO: select one summary
summary: "Version **{{ XBB_RELEASE_VERSION }}** is a maintenance release; it fixes <...>."
summary: "Version **{{ XBB_RELEASE_VERSION }}** is a new release; it follows the upstream QEMU release."

qemu_version: "7.2.5"
qemu_short_commit: "9abcf97"
qemu_long_commit: "9abcf9776d8906c53feacab686f3d50137654b62"
qemu_date: "August 7, 2023"

version: "{{ XBB_RELEASE_VERSION }}"
npm_subversion: "1"

download_url: https://github.com/xpack-dev-tools/qemu-riscv-xpack/releases/tag/v{{ XBB_RELEASE_VERSION }}/

comments: true

date:   {{ RELEASE_DATE }}

categories:
  - releases
  - qemu

tags:
  - releases
  - qemu
  - emulator
  - risc-v

---

[The xPack QEMU RISC-V](https://xpack.github.io/qemu-riscv/)
is a standalone cross-platform binary distribution of
[QEMU](https://www.qemu.org).

There are separate binaries for **Windows** (Intel 64-bit),
**macOS** (Intel 64-bit, Apple Silicon 64-bit)
and **GNU/Linux** (Intel 64-bit, Arm 32/64-bit).

{% raw %}{% include note.html content="The main targets for the Arm binaries
are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}{% endraw %}

## Download

The binary files are available from GitHub [Releases]({% raw %}{{ page.download_url }}{% endraw %}).

## Prerequisites

- GNU/Linux Intel 64-bit: any system with **GLIBC 2.27** or higher
  (like Ubuntu 18 or later, Debian 10 or later, RedHat 8 later,
  Fedora 29 or later, etc)
- GNU/Linux Arm 32/64-bit: any system with **GLIBC 2.27** or higher
  (like Raspberry Pi OS, Ubuntu 18 or later, Debian 10 or later, RedHat 8 later,
  Fedora 29 or later, etc)
- Intel Windows 64-bit: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- macOS Intel 64-bit: 10.13 or later
- macOS Apple Silicon 64-bit: 11.6 or later

On GNU/Linux, QEMU requires the X11 libraries to be present. On Debian derived
distribution they are already in the system; on RedHat & Arch derived
distributions they must be installed explicitly.

## Install

The full details of installing the **xPack QEMU RISC-V** on various platforms
are presented in the separate
[Install]({% raw %}{{ site.baseurl }}{% endraw %}/dev-tools/qemu-riscv/install/) page.

### Easy install

The easiest way to install QEMU RISC-V is with
[`xpm`]({% raw %}{{ site.baseurl }}{% endraw %}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/qemu-riscv`](https://www.npmjs.com/package/@xpack-dev-tools/qemu-riscv)
from the [`npmjs.com`](https://www.npmjs.com) registry.

With the `xpm` tool available, installing
the latest version of the package and adding it as
a development dependency for a project is quite easy:

```sh
cd my-project
xpm init # Add a package.json if not already present

xpm install @xpack-dev-tools/qemu-riscv@latest --verbose

ls -l xpacks/.bin
```

To install this specific version, use:

```sh
xpm install @xpack-dev-tools/qemu-riscv@{% raw %}{{ page.version }}.{{ page.npm_subversion }}{% endraw %} --verbose
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

To completely remove the package from the central xPack store:

```sh
xpm uninstall --global @xpack-dev-tools/qemu-riscv
```

## Compliance

The xPack QEMU RISC-V currently is based on the official [QEMU](https://www.qemu.org),
with major changes.

The current version is based on:

- QEMU version {% raw %}{{ page.qemu_version }}{% endraw %},
  commit [{% raw %}{{ page.qemu_short_commit }}{% endraw %}](https://github.com/xpack-dev-tools/qemu/commit/{% raw %}{{ page.qemu_long_commit }}{% endraw %})
  from {% raw %}{{ page.qemu_date }}{% endraw %}.

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

- in order to build on macOS 10.13, the Intel macOS version has
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
[How to build](https://github.com/xpack-dev-tools/qemu-riscv-xpack/blob/xpack/README-BUILD.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/qemu-riscv-xpack/actions/)
- [Travis CI](https://app.travis-ci.com/github/xpack-dev-tools/qemu-riscv-xpack/builds/)

## Tests

TBD

## Checksums

The SHA-256 hashes for the files are:
