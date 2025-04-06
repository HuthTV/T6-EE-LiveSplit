#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

main()
{
    file = fs_fopen("timer", "write");
    fs_write( file, "0|0" );
    fs_fclose( file );
}

init()
{
    flag_init("timer_start");
    level.eem_version = "V4";
    level.split_number = 0;
    level thread on_player_connect();
}

on_player_connect()
{
    level waittill( "connected", player );
    if(getdvar("scr_allowFileIo") == "")
    {
        player iprintln("^8[^3T6EE^8][^5" + level.eem_version + "^8]^1 Unsupported plutonium version! Use R4811+");
        return;
    }

    setdvar("scr_allowFileIo", 1);
    setdvar("cg_flashScriptHashes", 1);

    if(victis_map())
    {
        level thread upgrade_dvars();
        player thread persistent_upgrades_bank();
    }
    level thread game_start_wait();
    level thread game_over_wait();
    level thread gametime_monitor();
    level thread split_monitor();
    player thread show_start_message();
}

game_start_wait()
{
    if(level.script == "zm_prison") level thread mob_start_wait();
    flag_wait( "initial_blackscreen_passed" );
    flag_set("timer_start");
}


mob_start_wait()
{
    runner = getplayers()[0];
    while(!flag("timer_start"))
    {
        if(isdefined(runner.afterlife_visionset) && runner.afterlife_visionset == 1)
        {
            wait 0.45;
            flag_set("timer_start");
        }
        wait 0.05;
    }
}

game_over_wait()
{
    flag_init("game_over");
    level waittill( "end_game" );
    flag_set("game_over");
}

gametime_monitor()
{
    flag_wait("timer_start");
    start_time = getTime();
    while(!flag("game_over"))
    {
        timer_file = fs_fopen("timer", "write");
        str = level.split_number + "|" + (getTime() - start_time);
        fs_write( timer_file, str );
        fs_fclose( timer_file );
        wait 0.05;
    }
}

split_monitor()
{
    switch(level.script)
    {
        case "zm_transit":
        level.splits = strtok("jetgun|tower|end", "|");
        break;

        case "zm_highrise":
        level.splits = strtok("sq_atd_drg_puzzle_complete|balls|perks", "|");
        break;

        case "zm_prison":
        level.splits = strtok("dryer_cycle_active|gondola_in_motion1|plane_boarded|gondola_in_motion|plane_boarded|gondola_in_motion|plane_boarded|nixie_code|last_audio_log", "|");
        break;

        case "zm_buried":
        level.splits = strtok("cipher|time_travel|sharpshooter", "|");
        break;

        case "zm_tomb":
        level.splits = strtok("activate_zone_nml|boxes|staff_1_crafted|staff_2_crafted|staff_3_crafted|staff_4_crafted|ee_all_staffs_placed|ee_mech_zombie_hole_opened|end_game", "|");
        break;
    }

    flag_wait("timer_start");
    while(level.split_number < level.splits.size)
    {
        check_split(level.splits[level.split_number], is_flag(level.splits[level.split_number]));
        level.split_number++;
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

            //die rise nonflags
            case "balls":
                level waittill( "sq_slb_completed" );
                break;

            case "perks":
                level waittill( "sq_fireball_hit_player" );
                break;

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

            //buried nonflags
            case "cipher":
                wait_for_buildable("buried_sq_oillamp");
                break;

            case "time_travel":
                while( !flag("sq_tpo_special_round_active") && !flag("sq_wisp_saved_with_time_bomb") ) wait 0.05;
                break;

            case "sharpshooter":
                level waittill_any("sq_richtofen_complete", "sq_maxis_complete");
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
        }
    }

    return gettime();
}

is_flag(split_name)
{
    switch(split_name)
    {
        //tranzit nonflags
        case "jetgun":
        case "tower":
        case "end":

        //die rise nonflags
        case "balls":
        case "perks":

        //mob nonflags
        case "gondola_in_motion1":
        case "nixie_code":
        case "last_audio_log":

        //buried nonflags
        case "cipher":
        case "time_travel":
        case "sharpshooter":

        //origins nonflags
        case "staff_1_crafted":
        case "staff_2_crafted":
        case "staff_3_crafted":
        case "staff_4_crafted":
        case "boxes":
        case "end_game":

            return 0;

        default:
            return 1;
    }
}

show_start_message()
{
    flag_wait( "initial_players_connected" );
    wait 0.15;
    self iprintln("^8[^3T6EE^8][^5" + level.eem_version + "^8]^7 github.com/HuthTV/T6-EE-LiveSplit");
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

victis_map()
{
    return (level.script == "zm_transit" || level.script == "zm_highrise" || level.script == "zm_buried");
}


create_bool_dvar( dvar, start_val )
{
    if( getdvar( dvar ) == "" ) setdvar( dvar, start_val);
}