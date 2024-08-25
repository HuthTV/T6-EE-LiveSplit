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
		{"dryer_cycle_active", "Dryer started"},
		{"gondola_1", "1st gondola ride"},
		{"fly_1", "1st Flight"},
		{"gondola_2", "2nd gondola ride"},
		{"fly_2", "2nd Flight"},
		{"gondola_3", "3rd gondola ride"},
		{"fly_3", "3rd Flight"},
		{"nixie_code", "Prisoner codes entered"},
		{"audio_tour_finished", "Last audio log deleted"}
	};

	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, true, Split.Value, "splits");

	vars.split_index = new Dictionary<int,string>
	{
		{1, "dryer_cycle_active"},
		{2, "gondola_1"},
		{3, "fly_1"},
		{4, "gondola_2"},
		{5, "fly_2"},
		{6, "gondola_3"},
		{7, "fly_3"},
		{8, "nixie_code"},
		{9, "audio_tour_finished"}
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