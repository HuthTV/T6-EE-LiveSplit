Autosplitter scripts for timing official BO2 _**solo**_ easter egg speedruns. Automatically start, reset, and split runs. Tick Accurate timing (50ms). Should be functional for Plutonium versions: `r2xxx` and beyond

## Video Guide

https://youtu.be/xQsdHSso_To

## Setup
1. Download LiveSplit [livesplit.org/downloads](https://livesplit.org/downloads/)

2. Place EE_livesplit_monitor in ```C:\Users\%username%\AppData\Local\Plutonium\storage\t6\scripts\zm```  
   If using your own LiveSplit file and layout skip step 3.   
   
3. Download and open the `.lss` file of the map you wish to configure. Right click LiveSplit and choose `Edit Splits...` Check the use layout box and select the maps `.lsl` file. Hit OK to save the change.

   ![Layout](https://i.imgur.com/fywHDRt.png "Layout")
  
4. Right click LiveSplit and choose `Edit Layout...` Open Scriptable Auto Splitter component (or add one first). Point script path at the `.asl` file for the map.

   ![Layout](https://i.imgur.com/aOkBIdd.png "ASL")

5. You can now start running!

## Downloads

GSC Split Monitor is required for all maps
| GSC Split Monitor | Origins ASL | MOTD ASL | Tranzit ASL |
| :-----------: | :-----------: | :-----------: | :-----------: |
| [download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.2/EE_livesplit_monitor_3.2.gsc) | [download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.2/Origins_EE_autosplitter_3.2.asl) | [download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.2/MotD_EE_autosplitter_3.2.asl) | [download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.2/Tranzit_EE_autosplitter_3.2.asl) |

Premade Livesplit Splits (lss) & Layout Files (lsl) files. If you don't want to make your own.
| Origins lss+lsl | MOTD lss+lsl | Tranzit lss+lsl |
| :-----------: | :-----------: | :-----------: |
| [download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/origins_livesplit_files.zip)  | [download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/motd_livesplit_files.zip)  | [download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/tranzit_livesplit_files.zip) |




## Network Frame Fix
In certain older versions of Plutonium (such as R2905), there exists an issue with the `wait_network_frame()` function, speeding up certain in-game events, most notably the spawnrate of zombies. The **latest** release incorporates a fix for this particular issue, ensuring that gameplay on older Plutonium versions remains legitimate.

## Persistent Upgrades & Bank
When playing tranzit. Upon spawning, players will be awarded all persistent upgrades except insta kill. Player bank will also be set to maximum amount. To change what upgrades are active, use to following boolean console dvars to enable/disable upgrades and bank fill.

`full_bank`  
`pers_jugg`   
`pers_boarding`    
`pers_carpenter`  
`pers_insta_kill`   
`pers_nube_counter`  
`pers_revivenoperk`  
`pers_sniper_counter`   
`pers_cash_back_prone`   
`pers_cash_back_bought`   
`pers_perk_lose_counter`   
`pers_box_weapon_counter`  
`pers_multikill_headshots`   
`pers_pistol_points_counter`    
`pers_double_points_counter`

## Legacy Scripts
These script use an older, inaccurate timing method. Scripts are not maintained and not recommended for runs. wait_network_frame fix is not included.
https://github.com/HuthTV/T6-EE-LiveSplit/releases/tag/Legacy_V1.0
