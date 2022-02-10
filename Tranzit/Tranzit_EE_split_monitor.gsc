#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;

init()
{
	if(level.script == "zm_transit")
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
	splits = array(	"jetgun_built", "ee_complete", "lights_on");

	while(split < splits.size)
	{
		checkSplit(splits[split]);
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
	switch(split)
	{
		case "jetgun_built":
			while(level.sq_progress["rich"]["A_jetgun_built"] == 0) wait 0.05;
			return 1;

		case "ee_complete":
			while(level.sq_progress["rich"]["FINISHED"] == 0) wait 0.05;
			return 1;

		case "lights_on":
			wait 8;
			return 1;
			
		default:
			return 0;
	}
}

showConnectMessage()
{ 
	self iprintln("^4github.com/HuthTV ^7- Tranzit EE autosplitter"); 
}
