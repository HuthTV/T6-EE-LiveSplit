# Description
Autosplitter for speedrunning BO2 origins easter egg.
Compatible with [Redacted](https://redacted.se) and [Plutonium](https://plutonium.pw).

# Setup
### Download
*  [Autosplitter + gsc script](https://github.com/HuthTV/BO2-Origins-EE-AutoSplitter/releases/download/1.0/ORIGINS_EE_AUTOSPLITTER.zip)

### Configure
* Add a Scriptable Auto Splitter component to your livesplit layout and point ```Script Path:``` at Origins_EE_autosplitter.asl
* Place Origins_EE_split_monitor.gsc in your games script folder
  * Redacted: ```redacted\data\scripts```
  * Plutonium: ```C:\Users\%username%\AppData\Local\Plutonium\storage\t6\scripts\zm```
* Make sure all timer and split components in your layout have ```Timing Method: Game Time```
* Ensure you have splits created corresponding to the splits selected in the Scriptable Auto Splitter settings tab
