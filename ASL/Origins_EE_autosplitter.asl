state("plutonium-bootstrapper-win32")
{
	int tick:     0x002AA13C, 0x14;
}

startup
{
	refreshRate = 20;
	vars.splitValue = 0;
	vars.timeValue = 0;

	vars.split_names = new Dictionary<int, Tuple<string, string>>()
	{
		{1, Tuple.Create("no_mans_land", "No mans land open")},
		{2, Tuple.Create("soul_chests", "All chests filled")},
		{3, Tuple.Create("staff_1", "Staff 1 crafted")},
		{4, Tuple.Create("staff_2", "Staff 2 crafted")},
		{5, Tuple.Create("staff_3", "Staff 3 crafted")},
		{6, Tuple.Create("staff_4", "Staff 4 crafted")},
		{7, Tuple.Create("ee_all_staffs_placed", "Ascend from darkness (Staffs placed in robots)")},
		{8, Tuple.Create("ee_mech_zombie_hole_opened", "Rain fire (Seal broken)")},
		{9, Tuple.Create("end_game", "Freedom (Game ended)")}
	};

	settings.Add("splits", true, "Splits");
	foreach(var Split in vars.split_names)
		settings.Add(Split.Value.Item1, true, Split.Value.Item2, "splits");

	vars.timerString = "0|0";
	vars.filePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),"Plutonium", "storage", "t6", "raw", "scriptdata", "timer");
}

update
{
	if(File.Exists(vars.filePath))
	{
		using (StreamReader r = new StreamReader(new FileStream(vars.filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
		{
			vars.timerString = r.ReadToEnd();
			string[] data = vars.timerString.Split('|');
			vars.splitValue = int.Parse(data[0]);
			vars.timeValue = int.Parse(data[1]);
		}
	}
}

gameTime
{
	return TimeSpan.FromMilliseconds( vars.timeValue );
}

isLoading
{
	return true;
}

start
{
	if(vars.timeValue == 50)
	{
		vars.split = 0;
		return true;
	}
}

split
{
	if(vars.splitValue > vars.split)
	{
		if(settings[vars.split_names[++vars.split].Item1])
			return true;
	}
}

reset
{
	if(vars.timeValue == 0)
	{
		return true;
	}
}