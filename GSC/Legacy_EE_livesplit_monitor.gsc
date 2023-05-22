#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;

init()
{
    if(level.scr_zm_ui_gametype_group != "zclassic") return;

    level.leem_version = "V2.2";
    level.leem_start_value = 935;
    level.leem_split_dvar = "sv_maxPing";
    level.leem_split_num = 0;

    setdvar(level.leem_split_dvar, 0);
    if(level.script == "zm_transit") level thread upgrade_dvars();
    level thread on_player_connect();
}

on_player_connect()
{
    level endon( "game_ended" );
    level waittill( "connected", player );
    if(level.is_forever_solo_game)
    {
        level thread split_monitor();
        if(level.script == "zm_transit") self thread persistent_upgrades_bank();
    }

    self waittill( "spawned_player" );
    player show_spawn_message();
}

split_monitor()
{
    if(level.script == "zm_prison")
    {
        splits = strtok("dryer_cycle_active|gondola_in_motion1|plane_boarded|gondola_in_motion|plane_boarded|gondola_in_motion|plane_boarded|nixie_code|last_audio_log", "|");
    }
    else if(level.script == "zm_tomb")
    {
        splits = strtok("activate_zone_nml|boxes|staff_1_crafted|staff_2_crafted|staff_3_crafted|staff_4_crafted|ee_all_staffs_placed|end_game", "|");
    }
    else if(level.script == "zm_transit")
    {
        splits = strtok("jetgun|tower|end", "|");
    }

    flag_wait("initial_blackscreen_passed");
    setdvar(level.leem_split_dvar, level.leem_start_value);

    while(level.leem_split_num < splits.size)
    {
        level.last_split_time = check_split(splits[level.leem_split_num], is_flag(splits[level.leem_split_num]));
        level.leem_split_num++;
        setdvar(level.leem_split_dvar, level.leem_split_num);
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
                wait 10;
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

show_spawn_message()
{
    self iprintln("^1Legacy ^6Livesplit Monitor ^5" + level.leem_version + " ^8| ^3github.com/HuthTV/BO2-Easter-Egg-Auto-Splitters");
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