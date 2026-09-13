Machine Start G-Code for reference from slicer. 

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

PRINT_START TOOL_TEMP={first_layer_temperature[initial_tool]} {if is_extruder_used[0]}T0_TEMP={first_layer_temperature[0]}{endif} {if is_extruder_used[1]}T1_TEMP={first_layer_temperature[1]}{endif} {if is_extruder_used[2]}T2_TEMP={first_layer_temperature[2]}{endif} {if is_extruder_used[3]}T3_TEMP={first_layer_temperature[3]}{endif} {if is_extruder_used[4]}T4_TEMP={first_layer_temperature[4]}{endif} USED_TOOLS="{if is_extruder_used[0]}0,{endif}{if is_extruder_used[1]}1,{endif}{if is_extruder_used[2]}2,{endif}{if is_extruder_used[3]}3,{endif}{if is_extruder_used[4]}4,{endif}" BED_TEMP=[first_layer_bed_temperature] TOOL=[initial_tool] LAYER=[layer_height] FILAMENT=[filament_type] SEQUENCE="[print_sequence]" EXCLUDE=[exclude_object] SURFACE="[curr_bed_type]"
```
