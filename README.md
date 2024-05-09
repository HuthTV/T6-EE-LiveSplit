Autosplitter scripts for timing BO2 **solo** easter egg speedruns. Automatically start, reset, and split runs. Tick Accurate timing (50ms). Tested and functional for following Plutonium versions:  
`R2905` `R3904 - R4043`

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

## Versions

   The version number is given by x.y.z  
      x = major change  
      y = minor change  
      z = asl change  
      
Typically T6 Pluto updates tend to break the ASL file, prompting the release of a updated ASL version. The GSC script remains unchanged but retains compatibility. For instance, the 3.1 GSC script functions with 3.1.3 ASL.  

The legacy scripts are older versions with inaccurate timing but superior compatibility. It is no longer maintained an will not recive any updates. These scripts are not recommended to be used, however.  If the current main release is not functioning properly, the legacy scripts can be temporarily utilized until the next update.

## Downloads

GSC Split Monitor V3.1 (required for all maps)  
[[download](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.3/EE_livesplit_monitor_3.1.gsc)]  

ASL Script V3.1.3  
[[Tranzit](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.3/Tranzit_EE_autosplitter_3.1.3.asl)]  [[MotD](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.3/MotD_EE_autosplitter_3.1.3.asl)] [[Origins](https://github.com/HuthTV/T6-EE-LiveSplit/releases/download/V3.1.3/Origins_EE_autosplitter_3.1.3.asl)]  

Livesplit Splits (lss) & Layout Files (lsl)  
[[Tranzit](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/tranzit_livesplit_files.zip)]  [[MotD](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/motd_livesplit_files.zip)]  [[Origins](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Split-Files/origins_livesplit_files.zip)]  

Legacy V1.0  
[[Split Monitor](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_EE_livesplit_monitor_1.0.gsc)]  [[Tranzit](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_Tranzit_EE_autosplitter_1.0.asl)]  [[MotD](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_MotD_EE_autosplitter_1.0.asl)]  [[Origins](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/Legacy_V1.0/Legacy_Origins_EE_autosplitter_1.0.asl)]  

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
