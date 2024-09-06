state("plutonium-bootstrapper-win32")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
}

startup
{
	refreshRate = 20;
	vars.startvalue = 120;
	vars.endvalue = 500;
	vars.timerModel = new TimerModel { CurrentState = timer };

	settings.Add("splits", true, "Splits");
	vars.split_names = new Dictionary<string,string>
	{
		{"no_mans_land", "No mans land open"},
		{"soul_chests", "All chest filled"},
		{"staff_1", "Staff 1 crafted"},
		{"staff_2", "Staff 2 crafted"},
		{"staff_3", "Staff 3 crafted"},
		{"staff_4", "Staff 4 crafted"},
		{"ee_all_staffs_placed", "Ascend from darkness (Staffs placed in robots)"},
		{"ee_mech_zombie_hole_opened", "Rain fire (Seal broken)"},
		{"end_game", "Freedom (Game ended)"}
	 };

	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, true, Split.Value, "splits");

	vars.split_index = new Dictionary<int,string>
	{
		{1, "no_mans_land"},
		{2, "soul_chests"},
		{3, "staff_1"},
		{4, "staff_2"},
		{5, "staff_3"},
		{6, "staff_4"},
		{7, "ee_all_staffs_placed"},
		{8, "ee_mech_zombie_hole_opened"},
		{9, "end_game"}
	 };

	vars.oldVersionSig = new SigScanTarget(11, "50 6C 75 74 6F 6E 69 75 6D 20 72 ?? ?? ?? ?? 3E");	//old style "rXXXX>"
	vars.newVersionSig = new SigScanTarget(11, "50 6C 75 74 6F 6E 69 75 6D 20 72 ?? ?? ?? ?? ?? 3E");	//new style "rXXXX >"
	vars.timeInfoSig = new SigScanTarget(24, "18 0B 18 01 6C 9A C5 00 61 7E D3 A2 01 04");	//time dvar - con_gameMsgWindow0SplitscreenScale
	vars.splitInfoSig = new SigScanTarget(24, "3B 0B 18 01 6C 9A C5 00 62 60 AD 35 01 04");	//splits dvar - con_gameMsgWindow1SplitscreenScale
	vars.versionDvarSig = new SigScanTarget(16, "63 42 87 C8 01 00 00 00");	//version dvar - con_gameMsgWindow2SplitscreenScale
}

init
{
	var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);

	IntPtr splitPtr = scanner.Scan(vars.splitInfoSig);
	IntPtr timePtr = scanner.Scan(vars.timeInfoSig);
	if(splitPtr == IntPtr.Zero || timePtr == IntPtr.Zero) throw new Exception();

	IntPtr versPtrOld = scanner.Scan(vars.oldVersionSig);
	IntPtr versPtrNew = scanner.Scan(vars.newVersionSig);
	IntPtr versDvarPtr = scanner.Scan(vars.versionDvarSig);

	if(versPtrOld != IntPtr.Zero)		{ vars.versionNum = game.ReadString(versPtrOld, 4); }
	else if(versPtrNew != IntPtr.Zero)	{ vars.versionNum = game.ReadString(versPtrNew, 4); }
	else								{ vars.versionNum = "0"; }
	version = "Plutonium r" + vars.versionNum;

	vars.Watchers = new MemoryWatcherList()
	{
		new MemoryWatcher<float>(splitPtr){ Name = "split" },
		new MemoryWatcher<float>(timePtr){ Name = "time" }
	};

	vars.versionWritePtr = versDvarPtr;
}

update
{
	vars.Watchers.UpdateAll(game);
	if(vars.Watchers["split"].Current == vars.endvalue && timer.CurrentPhase == TimerPhase.Running)
		vars.timerModel.Pause();
}

gameTime
{
	if(current.tick > 0)
		return TimeSpan.FromMilliseconds( vars.Watchers["time"].Current );
}

isLoading
{
	return true;
}

start
{
	if(vars.Watchers["split"].Current == vars.startvalue && current.tick > 0)
	{
		vars.split = 0;
		IntPtr temp = vars.versionWritePtr;
		game.WriteValue<float>(temp, (float)Int32.Parse(vars.versionNum));
		return true;
	}
}

split
{
	if(vars.Watchers["split"].Current > vars.split && vars.Watchers["split"].Current < vars.startvalue)
	{
		if(settings[vars.split_index[++vars.split]])
			return true;
	}
}

reset
{
	return current.tick > 0 && current.tick < 10;
}

exit
{
	if(timer.CurrentPhase == TimerPhase.Running)
		vars.timerModel.Pause();
}