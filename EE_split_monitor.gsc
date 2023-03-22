#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

init()
{
    level.split_dvar = "league_leaderboardRefetchTime";     //communicate split progress
    level.time_dvar = "league_teamLeagueInfoRefetchTime";   //communicate gametime
    level.start_condition = 116;
    level.split = 0;
    
	set_split(0);
    level thread on_player_connect();
}

on_player_connect()
{
	level waittill("connecting", player);
    if(isDefined( level.is_forever_solo_game ) && level.is_forever_solo_game)
    {
	    player thread show_connect_message();
        level thread start_monitor();
        level thread livesplit_updater();
        level thread split_monitor();
    }
    else
    {
        player iPrintLn("EE split monitor ^1disabled ^7| not a solo game");
    }	
}

start_monitor()
{
    setDvar(level.time_dvar, 0);
	flag_wait("initial_blackscreen_passed");
    level.level_start_time = getTime();
	set_split(level.start_condition);
}

livesplit_updater()
{
    split = 0;
    flag_wait("initial_blackscreen_passed");
    wait_network_frame();
    
    while(true)
    {
        if(level.split > split && level.split < level.start_condition)
        {
            setDvar(level.time_dvar, level.last_split_time - level.level_start_time);
            wait_network_frame();
            set_split(split);
            wait_network_frame();
            split = level.split;
        }
        else
        {
            setDvar(level.time_dvar, (getTime() - level.level_start_time));
        }
        wait 0.05;
    }
}

split_monitor()
{
    if(level.script == "zm_prison")
    {
        splits = strtok("dryer_cycle_active|gondola_in_motion1|plane_boarded|gondola_in_motion|plane_boarded|gondola_in_motion|plane_boarded|nixie_code|last_audio_log", "|");
    }
    else if(level.script == "zm_tomb")
    {
        splits = strtok("activate_zone_nml|boxes|staff_1_crafted|staff_2_crafted|staff_3_crafted|staff_4_crafted|ee_all_staffs_placed|all_staffs_placed|end_game", "|"); 
    }
    else if(level.script == "zm_transit" &&  level.scr_zm_ui_gametype_group == "zclassic")
    {
        splits = strtok("jetgun|tower|end", "|");
    }

    flag_wait("initial_blackscreen_passed");
    wait_network_frame();
    set_split(0);

	while(level.split < splits.size)
	{		
		level.last_split_time = check_split(splits[level.split], is_flag(splits[level.split]));		
		level.split++;
	}
}

check_split(split, is_flag)
{
	if(is_flag)
	{
		flag_wait(split);
	}
	else
	{
		switch(split)
		{
            //mob nonflags
		    case "gondola_in_motion1":
                flag_wait("fueltanks_found");
                flag_wait("gondola_in_motion");
				break;

			case "nixie_code":
				level waittill_multiple("nixie_final_" + 386, "nixie_final_" + 481, "nixie_final_" + 101, "nixie_final_" + 872);
				break;
			
			case "last_audio_log":
				wait 45;
				while( isdefined(level.m_headphones) ) wait 0.05;
				break;
			
             //origins nonflags
            case "boxes":
                while(level.n_soul_boxes_completed < 4) wait 0.05;
                wait 4;
                break;
                
            case "staff_1_crafted":
            case "staff_2_crafted":
            case "staff_3_crafted":
            case "staff_4_crafted":
                curr = level.n_staffs_crafted;
                while(curr <= level.n_staffs_crafted) wait 0.05;
                break;

            case "end_game":
                level waittill("end_game");
                break;

            //transit nonflags
            case "jetgun": 
            while(level.sq_progress["rich"]["A_jetgun_built"] == 0) wait 0.05;
            break;

            case "tower":
                while(level.sq_progress["rich"]["A_jetgun_tower"] == 0) wait 0.05;
                break;
                
            case "end":
                while(level.sq_progress["rich"]["FINISHED"] == 0) wait 0.05;
                break;
		}
	}

    return GetTime();
}

set_split(val)
{
	setDvar(level.split_dvar, val);
}

is_flag(split_name)
{
	switch(split_name)
	{
        //mob nonflags
        case "gondola_in_motion1":
		case "nixie_code":
		case "last_audio_log":

        //origins nonflags
        case "staff_1_crafted":
		case "staff_2_crafted":
		case "staff_3_crafted":
		case "staff_4_crafted":
        case "boxes":
		case "all_staffs_placed":
		case "end_game":

        //tranzit nonflags
        case "jetgun":
        case "tower":
        case "end":
			return 0;
			
		default:
			return 1;
	}
}

show_connect_message()
{ 
    self waittill( "spawned_player" );
    wait 3;
	self iprintln("Livesplit monitor v2.0 | github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters"); 
}