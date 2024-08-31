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
		{"jetgun_built", "Jetgun built"},
		{"tower_heated", "Tower heated"},
		{"ee_complete", "Easter egg completed"}
	 };

	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, true, Split.Value, "splits");

	vars.split_index = new Dictionary<int,string>
	{
		{1, "jetgun_built"},
		{2, "tower_heated"},
		{3, "ee_complete"}
	 };

	vars.oldVersionSig = new SigScanTarget(11, "50 6C 75 74 6F 6E 69 75 6D 20 72 ?? ?? ?? ?? 3E"); 		//old style "rXXXX>"
	vars.newVersionSig = new SigScanTarget(11, "50 6C 75 74 6F 6E 69 75 6D 20 72 ?? ?? ?? ?? ?? 3E"); 	//new style "rXXXX >"
	vars.splitInfoSig = new SigScanTarget(24, "3B 0B 18 01 6C 9A C5 00 62 60 AD 35 01 04");	//splits dvar 	con_gameMsgWindow1SplitscreenScale
	vars.timeInfoSig = new SigScanTarget(24, "18 0B 18 01 6C 9A C5 00 61 7E D3 A2 01 04");	//time dvar		con_gameMsgWindow0SplitscreenScale
}

init
{
	var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);

	IntPtr splitPtr = scanner.Scan(vars.splitInfoSig);
	IntPtr timePtr = scanner.Scan(vars.timeInfoSig);

	if(splitPtr == IntPtr.Zero || timePtr == IntPtr.Zero) throw new Exception();

	IntPtr versPtrOld = scanner.Scan(vars.oldVersionSig);
	IntPtr versPtrNew = scanner.Scan(vars.newVersionSig);

	if(versPtrOld != IntPtr.Zero)		{ version = "Plutonium r" + game.ReadString(versPtrOld, 4); }
	else if(versPtrNew != IntPtr.Zero)	{ version = "Plutonium r" + game.ReadString(versPtrNew, 4); }
	else								{ version = "Plutonium"; }

	vars.Watchers = new MemoryWatcherList()
	{
		new MemoryWatcher<float>(splitPtr){ Name = "split" },
		new MemoryWatcher<float>(timePtr){ Name = "time" }
	};
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