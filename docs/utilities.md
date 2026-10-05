---
layout: default
title: Utilities
nav_order: 3
---

# Utilities

The `utils/` directory contains optional command-line tools for inspecting a running softGlueZynq IOC, generating MEDM displays, and preparing APS MicroZed systems. These scripts are not run by the normal EPICS build.

## Reporting signal connections

`softglue_connections.py` reports how a running IOC's softGlue signals are connected. It reads PV names ending in `_Signal` from a `dbl-all.txt` file, queries their live values and descriptions through Channel Access, and groups each named signal into drivers, loads, and inverted loads. It also reports constants, pulse values whose text ends in `!`, blank connections, and warnings such as multiple drivers or loads without a driver.

The utility requires Python 3.9 or newer and [pyepics](https://pyepics.github.io/pyepics/):

```sh
python3 -m pip install pyepics
```

Generate `dbl-all.txt` from the IOC so that it matches the records currently loaded, then run, for example:

```sh
python3 utils/softglue_connections.py --dbl-all dbl-all.txt
python3 utils/softglue_connections.py --dbl-all dbl-all.txt --with-states
python3 utils/softglue_connections.py --dbl-all dbl-all.txt \
    --print-blank-drivers --print-blank-loads
python3 utils/softglue_connections.py --dbl-all dbl-all.txt \
    --format json > softglue-connections.json
```

`--with-states` also reads companion `_BI` records when they exist. FI records are treated as drivers and FO records as loads; other records are classified from descriptions beginning with `OUT` or `IN`. The command exits with an error if a required PV cannot be read, rather than producing a misleading partial report.

## Generating MEDM displays

`generate_softglue_screen.py` generates a top-level MEDM ADL display and its bare component display from a YAML description. The generator requires Python 3.10 or newer and [PyYAML](https://pyyaml.org/):

```sh
python3 -m pip install PyYAML
python3 utils/generate_softglue_screen.py \
    softGlueApp/op/yaml/IF_tracker.yaml \
    --output-dir softGlueApp/op/adl
```

For a YAML module whose `file_stem` is `IF_tracker`, the output files are:

```text
softGlueZynq_IF_tracker.adl
softGlueZynq_IF_tracker_bare.adl
```

The YAML `module` section controls the display and PV-name stems, optional instance numbering, description field, block label, and exact-PV mode. Ordered `inputs` and `outputs` may be signals or registers. Signal pins can be inverted and input signals can be marked as clocks; register pins support display formats and optional widths. A `layout` section can override layout defaults.

The utility writes ADL only; conversion to UI, EDL, OPI, or BOB formats is a separate step. Generator version 1.5.0 sizes displays from their actual content, centers titles across the display, and accounts for MEDM's external-composite bounds.

## Preparing an APS MicroZed SD card

> **Warning:** `setup_SD_sg` is destructive and APS-specific. It erases and repartitions the selected block device. It is not intended as a general-purpose SD-card preparation tool.

`setup_SD_sg` prepares an SD card for the APS softGlueZynq MicroZed environment. It is intentionally restricted to APS user `bcda1` on host `bcpc10-ln.xray.aps.anl.gov`. The script:

1. Lists `/dev/sdX` block devices other than the detected system root disk.
2. Requires the operator to select and confirm the target device.
3. Unmounts existing partitions and creates a DOS partition table with partition 1 spanning sectors 2048 through 21111221 (about 10 GiB) and partition 2 using the remaining space.
4. Formats partition 1 as VFAT and partition 2 as ext4.
5. Mounts them at `/tmp/mnt/SD1` and `/tmp/mnt/SD2`.
6. Optionally copies `BOOT.BIN`, `boot.scr`, `image.ub`, `rootfs.tar.gz`, and `system.dtb` from an APS boot-files directory.
7. Records the selected Vivado project path in `hardware-build`.
8. Extracts the root filesystem and optionally invokes `generate_userConfig`.

Run it only from the module checkout on the required APS host:

```sh
utils/setup_SD_sg
```

The script requires `sudo` access and Linux utilities including `findmnt`, `lsblk`, `fdisk`, `partprobe`, `udevadm`, `mkfs`, `mount`, `mountpoint`, `umount`, `tar`, `realpath`, `df`, `awk`, `sed`, `grep`, `cp`, and `sync`. The target must be large enough for the fixed first partition. Its default boot-file source is `~bcda1/PetaLinuxBootFiles_MZ_script`. The generated partitions remain mounted when the script exits; the unmount commands are currently disabled.

Before confirming the target, verify the device name, size, and model shown by `lsblk`. The script's root-device exclusion and `/dev/sdX` candidate filtering are safeguards, not substitutes for operator verification.

### Generating APS userConfig

`generate_userConfig` can be run by `setup_SD_sg` or directly:

```sh
utils/generate_userConfig /path/to/userConfig
```

It prompts for a MAC address, host name, and IOC directory, or looks those values up in the APS IP/MAC inventory. Values are validated before being written into the shell-format configuration file. Inventory lookup requires exactly one matching hostname and a current-format row whose sixth field is a `/net/.../xorApps/...` IOC path; ambiguous and older rows are rejected. It derives the IOC server and mount paths from the IOC directory, writes the MicroZed `userConfig`, and copies the result to the IOC's top-level directory when that directory exists. The caller needs access to the inventory and write permission for the requested output and any IOC directory receiving the extra copy.

This script is also APS-specific. It contains defaults and generated values tied to APS infrastructure:

- Lookup file: `/home/beams/BCDA1/zynq/PetaLinux/IP_MAC_addresses.txt`
- IOC server domain: `.xray.aps.anl.gov`
- Shared filesystem and support files under `/APSshare`
- APS service account, group, UID, and GID values
- Default generated user and root passwords (`pwd`), which must be reviewed for the target system
- APS SSH authorized-key and procServ paths
- IOC directories expected below `/net/<server>/.../xorApps`

Moving the scripts into this module does not break the call from `setup_SD_sg`: the module copy locates `generate_userConfig` in the same `utils/` directory. The APS paths listed above remain hard-coded by design, so installations outside APS must review and adapt the scripts before use.
