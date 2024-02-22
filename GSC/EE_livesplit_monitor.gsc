#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

main()
{
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::wait_network_frame_fix);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::wait_network_frame_fix);
}

init()
{
    level.eem_version = "V3.1";
    level.eem_start_value = 119;
    level.eem_end_value = 500;
    level.eem_split_num = 0;
    level.eem_split_dvar = "con_gameMsgWindow1SplitscreenScale";    //communicate split progress
    level.eem_time_dvar = "con_gameMsgWindow0SplitscreenScale";     //communicate gametime
    setdvar(level.eem_split_dvar, level.eem_split_num);

    if(level.scr_zm_ui_gametype_group != "zclassic") return;

    level thread on_player_connect();
    //if(getdvar("scr_kill_infinite_loops") == "") {} Pre r3755
}

on_player_connect()
{
    level endon( "game_ended" );
    level waittill( "connected", player );

    if(level.is_forever_solo_game)
    {
        if(level.script == "zm_transit")
        {
            level thread upgrade_dvars();
            self thread persistent_upgrades_bank();
        }
        level thread game_start_wait();
        level thread game_over_wait();
        level thread start_monitor();
        level thread split_monitor();
        level thread gametime_monitor();
        player thread network_frame_print();
        player thread show_start_message();
    }
}

start_monitor()
{
    setdvar(level.eem_time_dvar, 0);
    flag_wait("timer_start");
    setdvar(level.eem_split_dvar, level.eem_start_value + level.eem_split_num); //No start if split_num is set by end value
}

gametime_monitor()
{
    splits = 0;
    flag_wait("timer_start");
    level.eem_level_start_time = getTime();
    wait_network_frame();

    while(level.eem_split_num < level.splits.size)
    {
        if(splits < level.eem_split_num)
        {
            splits++;
            wait_network_frame();
        }
        else
        {
            setdvar(level.eem_time_dvar, (gettime() - level.eem_level_start_time));
        }
        wait 0.05;
    }
}

split_monitor()
{
    if(level.script == "zm_prison")
    {
        level.splits = strtok("dryer_cycle_active|gondola_in_motion1|plane_boarded|gondola_in_motion|plane_boarded|gondola_in_motion|plane_boarded|nixie_code|last_audio_log", "|");
    }
    else if(level.script == "zm_tomb")
    {
        level.splits = strtok("activate_zone_nml|boxes|staff_1_crafted|staff_2_crafted|staff_3_crafted|staff_4_crafted|ee_all_staffs_placed|ee_mech_zombie_hole_opened|end_game", "|");
    }
    else if(level.script == "zm_transit")
    {
        level.splits = strtok("jetgun|tower|end", "|");
    }

    flag_wait("timer_start");
    wait_network_frame();
    setdvar(level.eem_split_dvar, 0);

    while(level.eem_split_num < level.splits.size)
    {
        level.last_split_time = check_split(level.splits[level.eem_split_num], is_flag(level.splits[level.eem_split_num]));
        level.eem_split_num++;
        setdvar(level.eem_time_dvar, level.last_split_time - level.eem_level_start_time);
        setdvar(level.eem_split_dvar, level.eem_split_num);
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
                flag_wait("gondola_at_docks");
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
                wait 4.3;
                break;

            case "staff_1_crafted":
            case "staff_2_crafted":
            case "staff_3_crafted":
            case "staff_4_crafted":
                curr = level.n_staffs_crafted;
                while(curr == level.n_staffs_crafted && level.n_staffs_crafted < 4) wait 0.05;
                break;

            case "end_game":
                flag_wait( "ee_samantha_released" );
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

    return gettime();
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

game_start_wait()
{
    level endon( "game_ended" );
    flag_init("timer_start");
    flag_clear("timer_start");
    if(level.script == "zm_prison") level thread mob_start_wait();

    flag_wait( "initial_blackscreen_passed" );
    flag_set("timer_start");
}


mob_start_wait()
{
    level endon( "game_ended" );
    players = getplayers();

    while(!flag("timer_start"))
    {
        foreach(ghost in players)
        {
            if(isdefined(ghost.e_afterlife_corpse))
            {
                wait 1.5;
                flag_set("timer_start");
            }
        }
        wait 0.05;
    }
}

game_over_wait()
{
    level waittill( "end_game" );
    wait_network_frame();
    level.eem_split_num = level.eem_end_value;
    setdvar(level.eem_split_dvar, level.eem_end_value);
}

show_start_message()
{
    flag_wait( "initial_players_connected" );
    wait 0.15;
    self iprintln("^8[^3EE Livesplit Monitor^8][^5" + level.eem_version + "^8]^7 github.com/HuthTV/T6-EE-LiveSplit");
}

upgrade_dvars()
{
    foreach(upgrade in level.pers_upgrades)
    {
        foreach(stat_name in upgrade.stat_names)
            level.eet_upgrades[level.eet_upgrades.size] = stat_name;
    }

    create_bool_dvar("full_bank", 1);
    create_bool_dvar("pers_insta_kill", level.script != "zm_transit");

    foreach(pers_perk in level.eet_upgrades)
        create_bool_dvar(pers_perk, 1);
}

persistent_upgrades_bank()
{
    foreach(upgrade in level.pers_upgrades)
    {
        for(i = 0; i < upgrade.stat_names.size; i++)
        {
            val = (getdvarint(upgrade.stat_names[i]) > 0) * upgrade.stat_desired_values[i];
            self maps\mp\zombies\_zm_stats::set_client_stat(upgrade.stat_names[i], val);
        }
    }

    flag_wait("initial_blackscreen_passed");
    if(getdvarint("full_bank"))
    {
        self maps\mp\zombies\_zm_stats::set_map_stat("depositBox", level.bank_account_max, level.banking_map);
        self.account_value = level.bank_account_max;
    }
}

create_bool_dvar( dvar, start_val )
{
    if( getdvar( dvar ) == "" ) setdvar( dvar, start_val);
}

wait_network_frame_fix()
{
    if (level.players.size == 1)
        wait 0.1;
    else if (numremoteclients())
    {
        snapshot_ids = getsnapshotindexarray();

        for (acked = undefined; !isdefined(acked); acked = snapshotacknowledged(snapshot_ids))
            level waittill("snapacknowledged");
    }
    else
        wait 0.1;
}

network_frame_print()
{
    flag_wait( "initial_players_connected" );
    if(!isdefined(level.network_frame_checked))
    {
        level.network_frame_checked = true;

        start = gettime();
        wait_network_frame();
        delay = gettime() - start;

        msgstring = "^8[^6Network Frame -Fix^8] ^7" + delay + "ms ";

        if( (level.players.size == 1 && delay == 100) || (level.players.size < 1 && delay == 50) )
            msgstring += "^2good";
        else
            msgstring += "^1bad";

        Print(msgstring);
        IPrintLn(msgstring);
    }
}