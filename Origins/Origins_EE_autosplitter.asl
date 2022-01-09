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
		{"no_mans_land", "No mans land open"},
		{"soul_chest_1", "Chest 1 filled"},
		{"soul_chest_2", "Chest 2 filled"},
		{"soul_chest_3", "Chest 3 filled"},
		{"soul_chest_4", "Chest 4 filled"},
		{"staff_1", "Staff 1 crafted"},
		{"beacon_zm", "G-Strike beacon equipped"},
		{"staff_2", "Staff 2 crafted"},
		{"staff_3", "Staff 3 crafted"},
		{"staff_4", "Staff 4 crafted"},
		{"ee_all_staffs_upgraded", "Secure the keys (Staffs upgraded)"},
		{"ee_all_staffs_placed", "Ascend from darkness (Staffs placed in robots)"},
		{"ee_mech_zombie_hole_opened", "Rain fire (Seal broken)"},
		{"ee_mech_zombie_fight_completed", "Unleash the horde (Panzers killed)"},
		{"ee_maxis_drone_retrieved", "Skewer the winged beast (Maxis drone retrieved)"},
		{"ee_all_players_upgraded_punch", "Wield a fist of iron (Punch upgraded)"},
		{"player_active_in_chamber", "Enter crazy place"},
		{"ee_souls_absorbed", "Raise hell (Crazy place souls filled)"},
		{"end_game", "Freedom (Game ended)"},
	 };
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, true, Split.Value, "splits");
	 
	vars.split_index = new Dictionary<int,string> 
	{
		{1, "no_mans_land"},
		{2, "soul_chest_1"},
		{3, "soul_chest_2"},
		{4, "soul_chest_3"},
		{5, "soul_chest_4"},
		{6, "staff_1"},
		{7, "beacon_zm"},
		{8, "staff_2"},
		{9, "staff_3"},
		{10, "staff_4"},
		{11, "ee_all_staffs_upgraded"},
		{12, "ee_all_staffs_placed"},
		{13, "ee_mech_zombie_hole_opened"},
		{14, "ee_mech_zombie_fight_completed"},
		{15, "ee_maxis_drone_retrieved"},
		{16, "ee_all_players_upgraded_punch"},
		{17, "player_active_in_chamber"},
		{18, "ee_souls_absorbed"},
		{19, "end_game"},
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
