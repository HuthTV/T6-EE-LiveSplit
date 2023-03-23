//Redacted
state("t6zmv41", "Redacted")
{
	int tick:	0x002AA13C, 0x14;	//Tick counter
	int gametime: 0x0262B300;		//Game time (ms)
	int splitval: 0x0262B2A0;		//Split value
}

//Plutonium
state("plutonium-bootstrapper-win32", "Plutonium")
{
	int tick:	0x002AA13C, 0x14;	//Tick counter		
	int gametime: 0x0262B300;		//Game time (ms)
	int splitval: 0x0262B2A0;		//Split value
}

startup
{
	refreshRate = 200;
	vars.startvalue = 116;
	settings.Add("splits", true, "Splits");
	
	vars.split_names = new Dictionary<string,string> 
	{
		{"jetgun_built", "Jetgun built"},
		{"tower_heated", "Tower heated"},
		{"ee_complete", "Easter egg completed"},
	 };
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, false, Split.Value, "splits");
	 
	vars.split_index = new Dictionary<int,string> 
	{
		{1, "jetgun_built"},
		{2, "tower_heated"},
		{3, "ee_complete"},
	 };
}

start
{
	if( current.splitval == vars.startvalue && current.tick > 0)
	{
		vars.split = 0;
		return true;
	} 
}

reset
{
	return current.tick == 0;	
}

gameTime
{
	return TimeSpan.FromMilliseconds( current.gametime );
}

isLoading
{
	if(current.tick == old.tick)
	{
		if(vars.pauseticks > refreshRate/60 )
		{
			timer.CurrentPhase = TimerPhase.Paused;
			return true;
		}
		else
		{
			vars.pauseticks++;
			return false;
		}		
	}	
	else
	{
		vars.pauseticks = 0;
		timer.CurrentPhase = TimerPhase.Running;
		return false;
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