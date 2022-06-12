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
		{"master_key", "Wardens key acquired"},
		{"dryer_cycle_active", "Dryer started"},
		{"cloth_found", "Clothes grabbed"},
		{"rigging_found", "Rigging grabbed"},
		{"fueltanks_found", "Fueltank grabbed"},
		{"gondola_1", "1st gondola ride"},
		{"engine_found", "Engine grabbed"},
		{"fly_1", "1st Flight"},
		{"enter_chair_1", "1st bridge leave"},
		{"wardens_fuel", "Wardens fuel"},
		{"gondola_2", "2nd gondola ride"},
		{"docks_fuel", "Docks fuel"},
		{"lighthouse_fuel", "Lighthouse fuel"},
		{"laundry_fuel", "Laundry fuel"},
		{"infirmary_fuel", "Infirmary fuel"},
		{"fly_2", "2nd Flight"},
		{"enter_chair_2", "2nd bridge leave"},
		{"two_fuel", "Laundry fuel"},
		{"fuel_3", "Lighthouse fuel"},
		{"fuel_4", "Docks fuel"},
		{"gondola_3", "3rd gondola ride"},
		{"fuel_5", "Infirmary fuel"},
		{"fly_3", "3rd Flight"},
		{"enter_chair_3", "3rd bridge leave"},	
		{"blundergat_obtained", "Blundergat grabbed"},
		{"nixie_code", "Prisoner codes entered"},
		{"audio_tour_finished", "Last audio log ended"},
	};
	 
	foreach(var Split in vars.split_names)
		settings.Add(Split.Key, false, Split.Value, "splits");
	 
	vars.split_index = new Dictionary<int,string> 
	{
		{1, "master_key"},
		{2, "dryer_cycle_active"},
		{3, "cloth_found"},
		{4, "rigging_found"},
		{5, "fueltanks_found"},
		{6, "gondola_1"},
		{7, "engine_found"},
		{8, "fly_1"},
		{9, "enter_chair_1"},
		{10, "wardens_fuel"},
		{11, "gondola_2"},
		{12, "docks_fuel"},
		{13, "lighthouse_fuel"},
		{14, "laundry_fuel"},
		{15, "infirmary_fuel"},
		{16, "fly_2"},
		{17, "enter_chair_2"},
		{18, "two_fuel"},
		{19, "fuel_3"},
		{20, "fuel_4"},
		{21, "gondola_3"},
		{22, "fuel_5"},
		{23, "fly_3"},
		{24, "enter_chair_3"},
		{25, "blundergat_obtained"},
		{26, "nixie_code"},
		{27, "audio_tour_finished"},
	};
}

start
{
	if( current.maxping == 115 && current.tick > 0)
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
