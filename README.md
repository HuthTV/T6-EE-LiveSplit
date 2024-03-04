Autosplitter scripts for timing BO2 **solo** easter egg speedruns. Automatically start, reset, and split runs. Tick Accurate timing (50ms). Tested and functional for following Plutonium versions:  
`R2905` `R3904` `R3963`  

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

5. You can now start running! Make sure to open LiveSplit before starting game.

## Downloads

### V3.1 Scripts
[[Download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1/EE_livesplit_monitor_3.1.gsc)] GSC split monitor (required for all maps)  
[[Download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.1/Tranzit_EE_autosplitter_3.1.1.asl)] Tranzit ASL script  
[[Download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.1/MotD_EE_autosplitter_3.1.1.asl)] MotD ASL script  
[[Download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.1/Origins_EE_autosplitter_3.1.1.asl)] Origins ASL script  

### Livesplit splits/layout files (optional, can make your own)
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/tranzit_livesplit_files.zip)]  Tranzit  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/motd_livesplit_files.zip)]  MotD  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/origins_livesplit_files.zip)] Origins  

### Legacy V1.0 Scripts (only use if V3.1 is not working)
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_EE_livesplit_monitor_1.0.gsc)] GSC split monitor  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_Tranzit_EE_autosplitter_1.0.asl)] Tranzit ASL script  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_MotD_EE_autosplitter_1.0.asl)] MotD ASL script  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_Origins_EE_autosplitter_1.0.asl)] Origins ASL script  

## Network Frame Fix
In certain older versions of Putonium (such as R2509), there exists an issue with the `wait_network_frame()` function, speeding up certain in-game events, most notably the spawnrate of zombies. This timer incorporates a fix for this particular issue, ensuring that gameplay on older Putonium versions remains legitimate.

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
