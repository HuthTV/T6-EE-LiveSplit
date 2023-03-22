@echo off
echo [104mSplit monitor compilation[0m

gsc-tool.exe comp t6 ".\GSC\EE_split_monitor.gsc"
COPY ".\compiled\t6\EE_split_monitor.gsc" "%LocalAppData%\Plutonium\storage\t6\scripts\zm"