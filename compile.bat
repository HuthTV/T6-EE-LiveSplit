@echo off
echo [104mSplit monitor compilation[0m

gsc-tool.exe comp t6 ".\GSC\T6EE_monitor.gsc.gsc"
COPY ".\compiled\t6\T6EE_monitor.gsc" "%LocalAppData%\Plutonium\storage\t6\scripts\zm"