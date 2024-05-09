state("plutonium-bootstrapper-win32", "r4043")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
	float gametime:	0x02611260;		//con_gameMsgWindow0SplitscreenScale
	float splitval:	0x026114A0;		//con_gameMsgWindow1SplitscreenScale
}

state("plutonium-bootstrapper-win32", "r4035")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
	float gametime:	0x02611260;		//con_gameMsgWindow0SplitscreenScale
	float splitval:	0x026114A0;		//con_gameMsgWindow1SplitscreenScale
}

state("plutonium-bootstrapper-win32", "r3963")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
	float gametime:	0x026111A0;		//con_gameMsgWindow0SplitscreenScale
	float splitval:	0x026113E0;		//con_gameMsgWindow1SplitscreenScale
}

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

state("plutonium-bootstrapper-win32", "other")
{
	int tick:     0x002AA13C, 0x14;	//game ticks 20hz
	//No game version
}

startup
{
	refreshRate = 200;
	vars.startvalue = 119;
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
	vars.memsize = modules.First().ModuleMemorySize;
	switch(modules.First().ModuleMemorySize) {
		case 560967680: version = "r2905"; break;
		case 335872000: version = "r3904"; break;
		case 338178048: version = "r3963"; break;
		case 340664320: version = "r4035"; break;
		case 340729856: version = "r4043"; break;

		default:
			version = "other";

			var versionMessage = MessageBox.Show
			(
				"WARNING!\n\n"+
				"Livesplit is unable to detect your version of plutonium. "+
				"Normaly happens after pluto update. Make sure you have the latest ASL script. "+
				"Downloads: github.com/HuthTV/T6-EE-LiveSplit/releases",
				"Unsupported plutonium version"
			);
			break;
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