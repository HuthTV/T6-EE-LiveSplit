#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	if(level.script == "zm_tomb")
	thread onPlayerConnect();
}

onPlayerConnect()
{
	level waittill("connecting", player);
	player thread showConnectMessage();
	level thread splitMonitor();	
	split(0);
}

splitMonitor()
{
	split = 0;

	while(split < 18)
	{
		while(!checkSplit(split))
			wait 0.05;
	
		split++;
		split(split);
	}
}

split(i)
{
	setDvar("sv_maxPing", i);
}

checkSplit(split)
{
	switch(split)
	{
		case 0:	//NML
			value = flag("activate_zone_nml");
			break;

		case 1: //Box1
		case 2:	//Box2
		case 3:	//Box3
		case 4:	//Box4
			value = (level.n_soul_boxes_completed - (split - 1));
			break;

		case 5:	//Water staff
			value = (level.n_staffs_crafted == 1);
			break;

		case 6: //Gstrikes
			value = maps/mp/zm_tomb_craftables::players_has_weapon("beacon_zm");
			break;

		case 7:	//Air staff
		case 8:	//Fire staff
		case 9:	//Lightning staff
			value = (level.n_staffs_crafted - (split - 6));
			break;

		case 10: //secure the keys
			value = flag("ee_all_staffs_upgraded");
			break;

		case 11: //ascend from darkness
			value = flag("ee_all_staffs_placed");
			break;

		case 12: //rain fire
			value = flag("ee_mech_zombie_hole_opened");
			break;

		case 13: //unleash the horde
			value = flag("ee_mech_zombie_fight_completed");
			break;

		case 14: //Maxis drone retrived
			value = flag("ee_maxis_drone_retrieved");
			break;

		case 15: //Fist upgrade
			value = flag("ee_all_players_upgraded_punch");
			break;

		case 16: //raise hell
			value = flag("ee_souls_absorbed");
			break;

		case 17: //Freedom
			level waittill("end_game");
			value = 1;
			break;
	
		default:
			value = 0;
			break;
	}

	return value;
}

showConnectMessage()
{
	self endon( "disconnect" );
	self waittill( "spawned_player" );
	flag_wait("initial_blackscreen_passed");
	self iprintln("^4github.com/HuthTV ^7- Origins EE autosplitter");
}
