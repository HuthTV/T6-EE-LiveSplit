//Redacted
state("t6zmv41", "Redacted")
{
	int tick:	0x002AA13C, 0x14;		//Tick counter	
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}

//Plutonium
state("plutonium-bootstrapper-win32", "Plutonium")
{
	int tick:	0x002AA13C, 0x14;		//Tick counter	 
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}

startup
{
	refreshRate = 20;
	settings.Add("splits", true, "Splits");
	
	vars.split_names = new Dictionary<string,string> 
	{
		{"jetgun_built", "Jetgun built"},
		{"ee_complete", "Easter egg completed"},
		{"lights_on", "Blue lights turned on"}
	 };
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, false, Split.Value, "splits");
	 
	vars.split_index = new Dictionary<int,string> 
	{
		{1, "jetgun_built"},
		{2, "ee_complete"},
		{3, "lights_on",}
	 };
}


start
{
	if(current.maxping == 115 && current.tick > 0)
	{
		vars.starttick = current.tick;
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
	return TimeSpan.FromMilliseconds( (current.tick - vars.starttick) * 50);
}

isLoading
{
	timer.CurrentPhase = ( current.tick == old.tick ? TimerPhase.Paused : TimerPhase.Running );
	return false;
}

split
{
	if(current.maxping > vars.split && current.maxping < 100)
	{
		vars.split++;
		if(settings[vars.split_index[vars.split]])
			return true;
	}
}
