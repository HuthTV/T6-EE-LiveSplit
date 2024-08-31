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