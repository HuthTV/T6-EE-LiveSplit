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
		{"no_mans_land", "No mans land open"},
		{"soul_chests", "All chest filled"},
		{"staff_1", "Staff 1 crafted"},
		{"staff_2", "Staff 2 crafted"},
		{"staff_3", "Staff 3 crafted"},
		{"staff_4", "Staff 4 crafted"},
		{"ee_all_staffs_placed", "Ascend from darkness (Staffs placed in robots)"},
		{"end_game", "Freedom (Game ended)"},
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
		{8, "end_game"},
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