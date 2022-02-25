#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	if(level.script == "zm_tomb")
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
	setSplit(0);
	flag_wait("initial_blackscreen_passed");
	setSplit(115);
	level thread splitMonitor();
}

splitMonitor()
{
	split = 0;
	splits = array(	"activate_zone_nml", 
			"soul_box_1",
			"soul_box_2",
			"soul_box_3",
			"soul_box_4",
			"staff_1_crafted",
			"has_beacon_zm",
			"staff_2_crafted",
			"staff_3_crafted",
			"staff_4_crafted",
			"ee_all_staffs_upgraded",
			"ee_all_staffs_placed",
			"ee_mech_zombie_hole_opened",
			"ee_mech_zombie_fight_completed",
			"ee_maxis_drone_retrieved",
			"ee_all_players_upgraded_punch",
			"all_staffs_placed",
			"ee_souls_absorbed",
			"end_game");

	while(split < splits.size)
	{
		checkSplit(splits[split], isFlag(splits[split]));
		split++;
		setSplit(split);
	}
}

setSplit(val)
{
	setDvar("sv_maxPing", val);
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
			case "soul_box_1":
			case "soul_box_2":
			case "soul_box_3":
			case "soul_box_4":
				boxes = level.n_soul_boxes_completed;
				while(boxes == level.n_soul_boxes_completed) wait 0.05;
				return 1;
				
			case "staff_1_crafted":
			case "staff_2_crafted":
			case "staff_3_crafted":
			case "staff_4_crafted":
				staffs = level.n_staffs_crafted;
				while(staffs == level.n_staffs_crafted) wait 0.05;
				return 1;
			
			case "has_beacon_zm":
				while(!maps/mp/zm_tomb_craftables::players_has_weapon("beacon_zm")) wait 0.05;
				return 1;

			case "all_staffs_placed":
				while(!maps/mp/zm_tomb_ee_main::all_staffs_inserted_in_puzzle_room()) wait 0.05;
				return 1;
				
			case "end_game":
				level waittill("end_game");
				return 1;
			
			default:
				return 0;
		}
	}
}

isFlag(splitName)
{
	switch(splitName)
	{
		case "soul_box_1":
		case "soul_box_2":
		case "soul_box_3":
		case "soul_box_4":
		case "has_beacon_zm":
		case "staff_1_crafted":
		case "staff_2_crafted":
		case "staff_3_crafted":
		case "staff_4_crafted":
		case "all_staffs_placed":
		case "end_game":
		
			return 0;
			
		default:
			return 1;
	}
}

showConnectMessage()
{ 
	self iprintln("^4github.com/HuthTV ^7- Origins EE autosplitter"); 
}
