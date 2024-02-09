state("plutonium-bootstrapper-win32", "r3904")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
	float gametime:	0x026111A0;		//con_gameMsgWindow0SplitscreenScale
	float splitval:	0x026113E0;		//con_gameMsgWindow1SplitscreenScale
}

state("plutonium-bootstrapper-win32", "r2905")
{
	int tick:	0x002AA13C, 0x14;	//game ticks 20hz
	float gametime:	0x02612580;		//con_gameMsgWindow0SplitscreenScale
	float splitval:	0x026127C0;		//con_gameMsgWindow1SplitscreenScale
}


state("plutonium-bootstrapper-win32", "?")
{
	//No game version
}

startup
{
	refreshRate = 200;
	vars.startvalue = 118;
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
	vars.memsize = modules.First().ModuleMemorySize;
	switch(modules.First().ModuleMemorySize) {
		case 560967680: version = "r2905"; break;
		case 335872000: version = "r3904"; break;
		default: 		version = "?"; break;
	}
}

update
{
	if(current.splitval == vars.endvalue && vars.paused == 0)
	{
		vars.paused = 1;
		vars.timerModel.Pause();
	}
}

gameTime
{
	if(current.tick > 0)
		return TimeSpan.FromMilliseconds( current.gametime );
}

isLoading
{
	return true;
}

start
{
	if(current.splitval == vars.startvalue && current.tick > 0)
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
	if(current.splitval > vars.split && current.splitval < vars.startvalue)
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