state("plutonium-bootstrapper-win32")
{
	int tick:     0x002AA13C, 0x14;
}

startup
{
	refreshRate = 40;
	vars.splitValue = 0;
	vars.timeValue = 0;

	vars.split_names = new Dictionary<int, Tuple<string, string>>()
	{
		{1, Tuple.Create("dryer_cycle_active", "Dryer started")},
		{2, Tuple.Create("gondola_1", "First gondola ride")},
		{3, Tuple.Create("fly_1", "First flight")},
		{4, Tuple.Create("gondola_2", "Second gondola ride")},
		{5, Tuple.Create("fly_2", "Second flight")},
		{6, Tuple.Create("gondola_3", "Third gondola ride")},
		{7, Tuple.Create("fly_3", "Third flight")},
		{8, Tuple.Create("nixie_code", "Prisoner codes entered")},
		{9, Tuple.Create("audio_tour_finished", "Audio tour complete")}
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