@echo off
echo [104mSplit monitor compilation[0m

gsc-tool.exe comp t6 ".\GSC\EE_livesplit_monitor.gsc"
COPY ".\compiled\t6\EE_livesplit_monitor.gsc" "%LocalAppData%\Plutonium\storage\t6\scripts\zm"

gsc-tool.exe comp t6 ".\GSC\Legacy_EE_livesplit_monitor.gsc"
COPY ".\compiled\t6\Legacy_EE_livesplit_monitor.gsc" "%LocalAppData%\Plutonium\storage\t6\scripts\zm"