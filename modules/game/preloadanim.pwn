/*******************************************************************************
* FILENAME :        modules/game/preloadanim.pwn
*
* DESCRIPTION :
*       Preload animations.
*
* NOTES :
*       -
*
*       Copyright Paradise Devs 2015.  All rights reserved.
*
*/

#include <YSI\y_hooks>

//------------------------------------------------------------------------------

static bool:gplAnimationsPreLoaded[MAX_PLAYERS];

//------------------------------------------------------------------------------

PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

//------------------------------------------------------------------------------

hook OnPlayerDisconnect(playerid, reason)
{
    gplAnimationsPreLoaded[playerid] = false;
    return 1;
}

//------------------------------------------------------------------------------

hook OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
        return 1;

    if(!gplAnimationsPreLoaded[playerid])
	{
   		PreloadAnimLib(playerid,"SWEET");
   		PreloadAnimLib(playerid,"SWAT");
   		PreloadAnimLib(playerid,"KNIFE");
   		PreloadAnimLib(playerid,"CRACK");
   		PreloadAnimLib(playerid,"POLICE");
   		PreloadAnimLib(playerid,"HEIST9");
   		PreloadAnimLib(playerid,"BLOWJOBZ");
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"BASEBALL");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
   		PreloadAnimLib(playerid,"CLOTHES");
   		PreloadAnimLib(playerid,"INT_SHOP");
   		PreloadAnimLib(playerid,"KISSING");
   		PreloadAnimLib(playerid,"GYMNASIUM");
   		PreloadAnimLib(playerid,"FREEWEIGHTS");
   		PreloadAnimLib(playerid,"BENCHPRESS");
   		PreloadAnimLib(playerid,"MISC");
   		PreloadAnimLib(playerid,"PED");
		gplAnimationsPreLoaded[playerid] = true;
	}
    return 1;
}
