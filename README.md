# Klipper-Backup 💾 
Klipper backup script for manual or automated GitHub backups 

## Software and Recovery Reference

ForgeOn runs Raspberry Pi OS Lite 64-bit on a Raspberry Pi 5.

### Base Installation

| Component | Repository | Purpose |
|---|---|---|
| KIAUH | [dw-0/kiauh](https://github.com/dw-0/kiauh) | Installation and management of Klipper and related services |
| Klipper | [Klipper3d/klipper](https://github.com/Klipper3d/klipper) | Printer control and MCU firmware |
| Moonraker | [Arksine/moonraker](https://github.com/Arksine/moonraker) | API server used by Mainsail and other clients |
| Mainsail | [mainsail-crew/mainsail](https://github.com/mainsail-crew/mainsail) | Browser interface |

### Klipper Extensions and Hardware Support

| Component | Repository | Purpose / Restore Notes |
|---|---|---|
| Toolchanger Easy — AsTechEvolves fork | [astechevolves/klipper-toolchanger-easy](https://github.com/astechevolves/klipper-toolchanger-easy) | Toolchanging and tool-probe support. Use this fork; current backup specifies branch `main`. |
| Beacon | [beacon3d/beacon_klipper](https://github.com/beacon3d/beacon_klipper) | Beacon probe support; required for `[beacon]` |
| TMC Autotune | [andrewmcgr/klipper_tmc_autotune](https://github.com/andrewmcgr/klipper_tmc_autotune) | Required for `[autotune_tmc ...]` sections |
| KAMP | [kyleisah/Klipper-Adaptive-Meshing-Purging](https://github.com/kyleisah/Klipper-Adaptive-Meshing-Purging) | Adaptive meshing and purge macros |
| Klippain Shake&Tune | [Frix-x/klippain-shaketune](https://github.com/Frix-x/klippain-shaketune) | Accelerometer analysis and tuning tools; required for `[shaketune]` |
| G-Code Shell Command | [KIAUH](https://github.com/dw-0/kiauh) | Install the extension through KIAUH; required for `[gcode_shell_command ...]` |
| LLL-Buffed — AsTechEvolves fork | [astechevolves/lll-buffed](https://github.com/astechevolves/lll-buffed) | Buffer firmware, CP2112 helpers, multi-buffer macros, and setup instructions |

### Interfaces and Supporting Services

| Component | Repository | Purpose |
|---|---|---|
| HelixScreen | [prestonbrown/helixscreen](https://github.com/prestonbrown/helixscreen) | Printer touchscreen interface |
| Axiscope | [nic335/Axiscope](https://github.com/nic335/Axiscope) | Camera-assisted tool-offset calibration |
| Crowsnest | [mainsail-crew/crowsnest](https://github.com/mainsail-crew/crowsnest) | Webcam service; current backup specifies branch `v5` |
| Mobileraker Companion | [Clon1998/mobileraker_companion](https://github.com/Clon1998/mobileraker_companion) | Companion service for the Mobileraker mobile app |

### Additional Integrations

- [Moonraker Timelapse](https://github.com/mainsail-crew/moonraker-timelapse):
  `timelapse.cfg` is present in the backup. Install its Moonraker component
  if timelapse functionality is wanted.
- [Spoolman](https://github.com/Donkie/Spoolman):
  external filament inventory integration. Restore the connection to the
  existing server; its database requires its own backup.
- [KNOMI Toolchanger fork](https://github.com/astechevolves/knomi-toolchanger/tree/firmware):
  toolhead-display firmware reference; separate from the Pi installation.
- [PrintBuddy](https://github.com/vmhomelab/printbuddy):
  Network monitoring of various printers, files, status, etc. Overall coolness.


### Orca Slicer Start G-Code for reference

The backed up script utilize the data provilded to it by the slicer. The below is is machine_start_gcode block for Orca. 

```
M117

ORCA_TOOL_METADATA_BEGIN

{if is_extruder_used[0]}
ORCA_TOOL_METADATA TOOL=0 COLOR="{filament_colour[0]}" MATERIAL="{filament_type[0]}"
{endif}

{if is_extruder_used[1]}
ORCA_TOOL_METADATA TOOL=1 COLOR="{filament_colour[1]}" MATERIAL="{filament_type[1]}"
{endif}

{if is_extruder_used[2]}
ORCA_TOOL_METADATA TOOL=2 COLOR="{filament_colour[2]}" MATERIAL="{filament_type[2]}"
{endif}

{if is_extruder_used[3]}
ORCA_TOOL_METADATA TOOL=3 COLOR="{filament_colour[3]}" MATERIAL="{filament_type[3]}"
{endif}

{if is_extruder_used[4]}
ORCA_TOOL_METADATA TOOL=4 COLOR="{filament_colour[4]}" MATERIAL="{filament_type[4]}"
{endif}

SET_PRINT_STATS_INFO TOTAL_LAYER=[total_layer_count]
M109 S0  ; Stops the slicer from sending temp waits separately
M140 S0

PRINT_START TOOL_TEMP={first_layer_temperature[initial_tool]} {if is_extruder_used[0]}T0_TEMP={first_layer_temperature[0]}{endif} {if is_extruder_used[1]}T1_TEMP={first_layer_temperature[1]}{endif} {if is_extruder_used[2]}T2_TEMP={first_layer_temperature[2]}{endif} {if is_extruder_used[3]}T3_TEMP={first_layer_temperature[3]}{endif} {if is_extruder_used[4]}T4_TEMP={first_layer_temperature[4]}{endif} {if is_extruder_used[0]}T0_TC_RETRACT={retract_length_toolchange[0]}{endif} {if is_extruder_used[1]}T1_TC_RETRACT={retract_length_toolchange[1]}{endif} {if is_extruder_used[2]}T2_TC_RETRACT={retract_length_toolchange[2]}{endif} {if is_extruder_used[3]}T3_TC_RETRACT={retract_length_toolchange[3]}{endif} {if is_extruder_used[4]}T4_TC_RETRACT={retract_length_toolchange[4]}{endif} USED_TOOLS="{if is_extruder_used[0]}0,{endif}{if is_extruder_used[1]}1,{endif}{if is_extruder_used[2]}2,{endif}{if is_extruder_used[3]}3,{endif}{if is_extruder_used[4]}4,{endif}" BED_TEMP=[first_layer_bed_temperature] TOOL=[initial_tool] LAYER=[layer_height] FILAMENT=[filament_type] SEQUENCE="[print_sequence]" EXCLUDE=[exclude_object] SURFACE="[curr_bed_type]"
```

### Restore Notes

Restore the Moonraker database with Moonraker stopped:
   `~/printer_data/database/moonraker-sql.db`.
   This contains Mainsail UI preferences, macro organization, and print history.
Restore `~/klipper-backup/.env` separately from secure storage.

This backup is provided by [Klipper-Backup](https://github.com/Staubgeborener/Klipper-Backup).
