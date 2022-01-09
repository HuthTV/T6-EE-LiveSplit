//Redacted
state("t6zmv41", "Redacted")
{
	int tick: 		0x002AA13C, 0x14;		//Tick counter	
	int round: 		0x004530D0, 0x4;		//Current round
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}

//Plutonium
state("plutonium-bootstrapper-win32", "Plutonium")
{
	int tick: 		0x002AA13C, 0x14;		//Tick counter	 
	int round: 		0x004530D0, 0x4;		//Current round
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}
startup
{
	settings.Add("splits", true, "Splits");
	
	vars.split_names = new Dictionary<string,string> 
	{
		{"master_key", "Wardens key acquired"},
		{"gondola_1", "1st gondola ride"},
		{"fly_1", "1st Flight"},
		{"gondola_2", "2nd gondola ride"}, 
		{"fly_2", "2nd Flight"},
		{"gondola_3", "3rd gondola ride"},
		{"fly_3", "3rd Flight"},
		{"blundergat_obtained", "Blundergat grabbed"},
		{"nixie_code", "Prisoner codes entered"},
		{"audio_tour_finished", "Last audio log ended"},
	 };
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, true, Split.Value, "splits");
	 
	vars.split_index = new Dictionary<int,string> 
	{
		{1, "master_key"},
		{2, "gondola_1"},
		{3, "fly_1"},
		{4, "gondola_2"},
		{5, "fly_2"},
		{6, "gondola_3"},
		{7, "fly_3"},
		{8, "blundergat_obtained"},
		{9, "nixie_code"},
		{10, "audio_tour_finished"},
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
	if(current.tick == 0)
		return true;
}


gameTime
{
	return TimeSpan.FromMilliseconds( (current.tick - vars.starttick) * 50);
}

isLoading
{
	return true;
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
