---
layout: default
title: Release Notes
nav_order: 4
---


softGlueZynq Release Notes
--------------------------

Release R3-1
------------

> Draft release notes. R3-1 has not yet been tagged.

### DMA and socket acquisition

- Added the framed `sendalld` socket protocol. Each response includes a network-order payload-word count followed by DMA data, and FPGA flush events are represented as stream boundaries rather than ordinary payload words.
- Added the autosaved `acquireTranWords` PV for run-time transfer sizing. The default is 100,000 words and the maximum is 1,000,000 words.
- Improved DMA proxy error handling, event bounds checking, circular-buffer synchronization, socket cleanup, reconnect behavior, and handling of partial or interrupted writes.
- Limited acquisition data consumption to one socket client at a time.
- Removed the obsolete in-tree socket client. [SGSocket](https://github.com/keenanlang/SGSocket) is the maintained client.

### FPGA content, registers, and autosave

- Added a 64-bit BCDALAB FPGA register map.
- Reconciled ACQ and BCDALAB content, register, and autosave definitions with current FPGA content.
- Added dedicated ACQ POLAR content, 64-bit register, and autosave files.
- Added IF tracker load-mask, miss-index, miss-count, and additional clear/load mappings.
- Removed obsolete PixelTrig and PixelFIFO mappings from the reviewed ACQ, ACQ POLAR, and BCDALAB files.
- Corrected scale/offset/limit autosave instance selection and stopped restoring unavailable histogram-scaler and scaler controls.

### Clock configuration

- Added `clockConfig_configMenu.db` to reapply clock settings in the required order after configMenu restores a circuit, preventing saved desired frequencies from producing incorrect hardware frequencies.

### Utilities and displays

- Added `softglue_connections.py` for reporting live drivers, loads, inversions, constants, pulse values ending in `!`, and wiring warnings from a running IOC.
- Added a YAML-to-MEDM screen generator and updated it to version 1.5.0 with content-driven sizing, centered titles, and corrected external-composite placement.
- Added APS-specific SD-card preparation and `userConfig` generation scripts under `utils/`.
- Added IF tracker YAML input and updated ADL/UI displays for load mask, miss index, and miss count.

### Compatibility notes

- DMA clients should use SGSocket or another client that implements the framed `sendalld` protocol. A zero-length frame can represent either a flush boundary or a no-data timeout.
- Updated FPGA content and register databases must be used with matching FPGA images.
- The connection-report utility requires Python 3.9 or newer and pyepics. The screen generator requires Python 3.10 or newer and PyYAML. Neither utility changes the normal EPICS build.

Release R2-0-5
--------------

- Documentation moved to github pages

Release R2-0-4
--------------

- Use of STD module replaced with SCALER module

Release R2-0-3
--------------

- Added bob files, updated ui and edl files

Release R2-0-2
--------------

- Req files now installed to top level db folder.

Release R2-0 
-------------

- End user can change clock frequencies
- Use Block-ram FIFO and DMA for data acquisition.
- Histogramming scaler increased to 64 channels. Fast histogramming scaler channel advance rate adjustable in ~.1 MHz increments to around 250 MHz.
- Added 16 input scaler.
- Added source from which Vivado and Petalinux projects can be reconstructed.
- Dropped support for the MicroZed 7010. Its FPGA is too small.

Release R1-0 
-------------

- First attempt

Suggestions and Comments to:   
[Tim Mooney ](mailto:mooney@aps.anl.gov): (mooney@aps.anl.gov)
