Autosplitter scripts for timing BO2 **solo** easter egg speedruns. Automatically start, reset, and split runs. Tick Accurate timing (50ms). Compatible with Redacted and [Plutonium](https://plutonium.pw).

[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/V2.1/timer_scripts_only_2.1.zip)] - Scripts only  
[[Download](https://github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters/releases/download/V2.1/timer_scripts_and_livesplit_files_2.1.zip)] - Scripts & livesplit files  

## Setup
1. Download LiveSplit [livesplit.org/downloads](https://livesplit.org/downloads/)

2. Place EE_livesplit_monitor in ```C:\Users\%username%\AppData\Local\Plutonium\storage\t6\scripts\zm```  
   If using your own LiveSplit file and layout skip step 3.   
   
3. Open the `.lss` file of the map you wish to configure. Right click LiveSplit and choose `Edit Splits...` Check the use layout box and select the maps `.lsl` file. Hit OK to save the change.

   ![Layout](https://i.imgur.com/fywHDRt.png "Layout")
  
4. Right click LiveSplit and choose `Edit Layout...` Open Scriptable Auto Splitter component (or add one first). Point script path at the `.asl` file for the map.

   ![Layout](https://i.imgur.com/aOkBIdd.png "ASL")

5. You can now start running! Make sure to open LiveSplit before starting game.

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
