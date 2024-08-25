state("plutonium-bootstrapper-win32", "other")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
}

startup
{
	refreshRate = 200;
	vars.startvalue = 120;
	vars.endvalue = 500;
	vars.paused = 0;
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
}

init
{
	var scanner = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize);
	var scanTargetSplits = new SigScanTarget(24, "3B 0B 18 01 6C 9A C5 00 62 60 AD 35 01 04 00 00 02 00 00 00 01 00 00 00 ?? ?? ?? ??");
	var scanTargetTime = new SigScanTarget(24, "18 0B 18 01 6C 9A C5 00 61 7E D3 A2 01 04 00 00 02 00 00 00 01 00 00 00 ?? ?? ?? ??");
	IntPtr splitPtr = scanner.Scan(scanTargetSplits);
	IntPtr timePtr = scanner.Scan(scanTargetTime);

	vars.Watchers = new MemoryWatcherList
	{
		new MemoryWatcher<float>(splitPtr){ Name = "split" },
		new MemoryWatcher<float>(timePtr){ Name = "time" }
	};
}

update
{
	vars.Watchers.UpdateAll(game);
	if(vars.Watchers["split"].Current == vars.endvalue && vars.paused == 0)
	{
		vars.paused = 1;
		vars.timerModel.Pause();
	}
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
		if(vars.paused == 1);
		{
			vars.timerModel.Pause();
			vars.paused = 0;
		}
		return true;
	}
}

split
{
	if(vars.Watchers["split"].Current > vars.split && vars.Watchers["split"].Current < vars.startvalue)
	{
		vars.split++;
		if(settings[vars.split_index[vars.split]])
			return true;
	}
}

reset
{
	return current.tick > 0 && current.tick < 10;
}

exit
{
	if(vars.paused == 0)
	{
		vars.paused = 1;
		vars.timerModel.Pause();
	}
}