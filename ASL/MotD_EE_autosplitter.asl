//Redacted
state("t6zmv41", "Redacted")
{
	int tick:	0x002AA13C, 0x14;	//Tick counter
	int gametime: 0x0262B300;		//Game time (ms)
	int splittime: 0x0262B2A0;		//Split time (ms)
}

//Plutonium
state("plutonium-bootstrapper-win32", "Plutonium")
{
	int tick:	0x002AA13C, 0x14;	//Tick counter		
	int gametime: 0x0262B300;		//Game time (ms)
	int splittime: 0x0262B2A0;		//Split time (ms)
}

startup
{
	refreshRate = 200;
	vars.startvalue = 116;
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
		{"audio_tour_finished", "Last audio log ended"},
	};
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, false, Split.Value, "splits");
	 
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
		{9, "audio_tour_finished"},
	};
}

start
{
	if( current.splittime == vars.startvalue && current.tick > 0)
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
	if(current.splittime > vars.split && current.splittime < vars.startvalue)
	{
		vars.split++;
		if(settings[vars.split_index[vars.split]])
			return true;		
	}
}