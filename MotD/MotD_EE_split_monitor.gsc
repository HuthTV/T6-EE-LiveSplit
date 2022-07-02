#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_utility;

init()
{
	setSplit(0);
	if(level.script == "zm_prison" && isDefined( level.is_forever_solo_game ) && level.is_forever_solo_game)
	{
		thread startMonitor();
		thread onPlayerConnect();	
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
	flag_wait("initial_blackscreen_passed");
	setSplit(115);
	level thread splitMonitor();
}

splitMonitor()
{
	split = 0;
	splits = array(	
			"key_found",					//Wardens key
			"dryer_cycle_active",			//Dryer started
			"cloth_found",					//Clothing grabbed
			"rigging_found",				//Lines grabbed
			"fueltanks_found",				//Fueltank grabbed
			"gondola_in_motion",			//1st gondola
			"engine_found",					//Engine grabbed
			"plane_boarded",				//Flight 1
			"enter_chair",					//Bridge 1 leave
			"fuel_grabbed",					//Wardens fuel
			"gondola_in_motion",			//2nd gondola
			"fuel_grabbed",					//Docks fuel
			"fuel_grabbed",					//Laundry fuel
			"fuel_grabbed",					//Infirmary fuel
			"plane_boarded",				//Flight 2
			"enter_chair",					//Bridge 2 leave
			"fuel_grabbed", 				//Laundry fuel
			"fuel_grabbed",					//Lighthouse fuel
			"fuel_grabbed",					//Docks fuel
			"gondola_in_motion",			//3rd gondola
			"5_fuel_grabbed",				//5th fuel
			"plane_boarded",				//Flight 3
			"enter_chair",					//Bridge 3 leave
			"warden_blundergat_obtained",	//Gat grabbed
			"nixie_code",					//Codes enterd
			"last_audio_log");				//Last log
	
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

			case "enter_chair":
				while(level.characters_in_nml.size == 0) wait 0.05;
				while(level.characters_in_nml.size == 1) wait 0.05;
				return 1;

			case "5_fuel_grabbed":
				while(level.sndfuelpieces != 5) wait 0.05;
				return 1;

			case "fuel_grabbed":
				if(isDefined( level.sndfuelpieces ))
				{
					num_fuel = level.sndfuelpieces;
				}
				else
				{
					num_fuel = 0;
				}
				while(level.sndfuelpieces == num_fuel) wait 0.05;
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
		case "enter_chair":
		case "fuel_grabbed":
		case "5_fuel_grabbed":
			return 0;
			
		default:
			return 1;
	}
}

showConnectMessage()
{ 
	self iprintlnbold("^6github^7.^6com^7/^6HuthTV ^7- MotD EE autosplitter"); 
}

