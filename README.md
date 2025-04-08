LiveSplit Auto-splitter scripts for timing all Black Ops II _**solo**_ easter egg speedruns. Automatically starts, resets, and splits runs with tick-accurate timing. Built for Plutonium R4524 and newer.

## Video Guide

https://youtu.be/xQsdHSso_To

## Setup
### 1. Download LiveSplit
   Go to [livesplit.org/downloads](https://livesplit.org/downloads/) and download LiveSplit.

### 2. Add the monitor script to Plutonium
   Place the T6EE_monitor into this directory `C:\Users\%username%\AppData\Local\Plutonium\storage\t6\scripts\zm`

### 3. Configure LiveSplit
   _Skip this if you prefer to create your own LiveSplit files_
   - Download the `.lss` file for the map you want.
   - Open it with LiveSplit.
   - Right-click LiveSplit and select `Edit Splits...`
   - Check "Use Layout" and select the map's `.lsl` file.
   - Click OK to save.

   ![Layout](https://i.imgur.com/fywHDRt.png "Layout")

### 4. Load auto splitter
   - Right-click LiveSplit and choose `Edit Layout...`
   - If scriptable auto splitter isn’t already in the layout
      - Click `+ > Control > Scriptable Auto Splitter` to add it.
   - Click on the auto splitter component and set the script path to the maps `.asl` file.

   ![Layout](https://i.imgur.com/aOkBIdd.png "ASL")

### 5. You're Ready!
   Start your game and LiveSplit will now automatically start and split your run!

## Download links

### T6EE_monitor GSC script
In-game script that communicates with LiveSplit. Must be installed for **all maps**.
| T6EE_monitor |
|:---------:|
| [download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_monitor_V4.gsc) |

### ASL scripts
Auto-splitter scripts for LiveSplit. Each map uses its own dedicated script.
| Tranzit   | Die Rise  | MOTD      | Buried    | Origins   |
|:---------:|:---------:|:---------:|:---------:|:---------:|
| [ASL](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_tranzit.asl) | [ASL](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_die_rise.asl) | [ASL](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_motd.asl) | [ASL](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_buried.asl) | [ASL](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V4/T6EE_origins.asl) |

### LiveSplit files
Prepared split files and layout files for each map.
| Tranzit   | Die Rise  | MOTD      | Buried    | Origins   |
|:---------:|:---------:|:---------:|:---------:|:---------:|
| [lss+lsl](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/SplitFiles/tranzit.zip) | [lss+lsl](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/SplitFiles/die_rise.zip) | [lss+lsl](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/SplitFiles/motd.zip) | [lss+lsl](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/SplitFiles/buried.zip) | [lss+lsl](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/SplitFiles/origins.zip) |

## Persistent Upgrades & Bank
When playing tranzit. Upon spawning, players will be awarded all persistent upgrades except insta kill. Player bank will also be set to maximum amount. To change what upgrades are active, use to following boolean console dvars to enable/disable upgrades and bank fill.

- `full_bank`
- `pers_jugg`
- `pers_boarding`
- `pers_carpenter`
- `pers_insta_kill`
- `pers_nube_counter`
- `pers_revivenoperk`
- `pers_sniper_counter`
- `pers_cash_back_prone`
- `pers_cash_back_bought`
- `pers_perk_lose_counter`
- `pers_box_weapon_counter`
- `pers_multikill_headshots`
- `pers_pistol_points_counter`
- `pers_double_points_counter`