#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_utility;

init()
{
	if(level.script == "zm_prison")
	{
		thread startMonitor();
		thread onPlayerConnect();	
		flag_wait("initial_blackscreen_passed");
	}
}

onPlayerConnect()
{
	level waittill("connecting", player);
	flag_wait("initial_blackscreen_passed");
	player thread showConnectMessage();
}

startMonitor()
{
	setSplit(0);
	flag_wait("initial_blackscreen_passed");
	setSplit(120);
	level waittill("someone_touched_controls");
	setSplit(115);
	level thread splitMonitor();
}

splitMonitor()
{
	split = 0;
	splits = array(	
			"key_found", 
			"gondola_in_motion_1",
			"plane_boarded",
			"gondola_in_motion",
			"plane_boarded",
			"gondola_in_motion",
			"plane_boarded",
			"warden_blundergat_obtained",
			"nixie_code",
			"last_audio_log");
	
	while(split < splits.size)
	{		
		checkSplit(splits[split], isFlag(splits[split]));		
		split++;
		setSplit(split);
	}
}

checkSplit(split, isFlag)
{
	if(isFlag)
	{
		flag_wait(split);
		return 1;
	}
	else
	{
		switch(split)
		{
		
			case "nixie_code":
				level waittill_multiple("nixie_final_" + 386, "nixie_final_" + 481, "nixie_final_" + 101, "nixie_final_" + 872);
				return 1;
			
			case "last_audio_log":
				wait 45;
				while( isdefined(level.m_headphones) ) wait 0.05;
				return 1;
				
			case "gondola_in_motion_1":
				flag_wait("gondola_in_motion");
				wait 15;
				flag_wait("gondola_in_motion");
				return 1;
			
			default:
				return 0;
		}
	}
}

setSplit(val)
{
	setDvar("sv_maxPing", val);
}

isFlag(splitName)
{
	switch(splitName)
	{
		case "nixie_code":
		case "last_audio_log":
		case "gondola_in_motion_1":
			return 0;
			
		default:
			return 1;
	}
}

showConnectMessage()
{ 
	self iprintln("^4github.com/HuthTV ^7- MotD EE autosplitter"); 
}
