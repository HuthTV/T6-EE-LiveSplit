//Redacted
state("t6zmv41", "Redacted")
{
	int tick:	0x002AA13C, 0x14;		//Tick counter
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}

//Plutonium
state("plutonium-bootstrapper-win32", "Plutonium")
{
	int tick:	0x002AA13C, 0x14;
	int maxping:	0x024B6880, 0x18;		//Maxping DVAR
}

startup
{
	refreshRate = 20;
	settings.Add("splits", true, "Splits");

	vars.split_names = new Dictionary<string,string>
	{
		{"no_mans_land", "No mans land open"},
		{"soul_chests", "4 Chest filled"},
		{"staff_1", "Staff 1 crafted"},
		{"staff_2", "Staff 2 crafted"},
		{"staff_3", "Staff 3 crafted"},
		{"staff_4", "Staff 4 crafted"},
		{"ee_all_staffs_placed", "Ascend from darkness (Staffs placed in robots)"},
		{"ee_mech_zombie_hole_opened", "Rain fire (Seal broken)"},
		{"end_game", "Freedom (Game ended)"}
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
		{8, "ee_mech_zombie_hole_opened"},
		{9, "end_game"}
	};
}

start
{
	if( current.maxping == 935 && current.tick > 0)
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
