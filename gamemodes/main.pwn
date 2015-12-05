/*******************************************************************************
* FILENAME :        main.pwn
*
* DESCRIPTION :
*       Linkage of all modules and includes, definiton of values.
*
* NOTES :
*       This file is not intended to handle player's functions or anything.
*       This file must only have links and constants.
*
*       Copyright Paradise Devs 2015.  All rights reserved.
*/

// Required to be at the top
#include <a_samp>

//------------------------------------------------------------------------------

// Script versioning
#define SCRIPT_VERSION_MAJOR							"0"
#define SCRIPT_VERSION_MINOR							"2"
#define SCRIPT_VERSION_PATCH							""
#define SCRIPT_VERSION_NAME								"PC:RPG"

//------------------------------------------------------------------------------

#define MAX_PLAYER_PASSWORD								32
#define MAX_BUILDINGS									32
#define MAX_PICKUP_RANGE								40.0
#define MAX_TEXT3D_RANGE								20.0
#define MAX_MAPICON_RANGE								150.0

#define PICKUP_DELAY									2 // Seconds

#define INVALID_APARTMENT_ID							-1
#define INVALID_HOUSE_ID								-1
#define INVALID_BUSINESS_ID								-1

#define HOSPITAL_TIME									90	// Seconds

#define HOSPITAL_PRICE									500
#define FUEL_PRICE										1 // * 100 / 0.2%

#define MAX_FACTIONS									32

#define MAX_BUSINESS									32
#define MAX_BUSINESS_NAME								64

#define MAX_HOUSES										64
#define MAX_HOUSE_NAME									64
#define MAX_HOUSE_MAPICON_RANGE							25.0

#define INTERVAL_BETWEEN_SERVER_MESSAGES				900000 // ms

#define LAST_POSITION									0
#define HOUSE_POSITION									1

//------------------------------------------------------------------------------

#define COLOR_WARNING									0xf14545ff
#define COLOR_ERROR										0xf14545ff
#define COLOR_SUCCESS									0x88aa62FF
#define COLOR_INFO										0xA9C4E4FF
#define COLOR_ACTION									0xDA70D6FF
#define COLOR_WHITE										0xFFFFFFFF
#define COLOR_YELLOW									0xFFFF00FF
#define COLOR_TITLE										0xa5f413ff
#define COLOR_SPECIAL									0xa5f413ff
#define COLOR_ADMIN_ACTION								0x7dcfb6ff
#define COLOR_SUB_TITLE									0xe6e6e6ff
#define COLOR_SERVER									0xa5f413ff
#define COLOR_WALKIE_TALKIE								0x4FBBE0FF

#define COLOR_RANK_DEVELOPER							0x35a700ff
#define COLOR_RANK_ADMIN								0x00AEFFFF
#define COLOR_RANK_SUPERVISOR							0x009CE5FF
#define COLOR_RANK_MODERATOR							0x008BCCFF
#define COLOR_RANK_BETATESER							0x992A2AFF
#define COLOR_RANK_DESIGNER								0xe48200ff
#define COLOR_RANK_BACKUP								0xCE8500FF

//------------------------------------------------------------------------------

// Libraries
#include <sscanf2>
#include <a_mysql>
#include <YSI\y_iterate>
#include <YSI\y_hooks>
#include <YSI\y_timers>
#include <YSI\y_commands>
#include <YSI\y_va>
#include <streamer>
#include <progress2>
#include <fnumb>
#include <util>
#include <vcolor>
#include <zones>
#include <mSelection>

//------------------------------------------------------------------------------

// ID of the model list for text draw of skins
new maleskinlist = mS_INVALID_LISTID;
new femaleskinlist = mS_INVALID_LISTID;

//------------------------------------------------------------------------------

hook OnGameModeInit()
{
	// Gamemode start message
	printf("\n\n============================================================\n");
	printf("Initializing %s %s.%s%s...\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);

	// Set the gamemode name to the current version
	new rcon_command[32];
	format(rcon_command, sizeof(rcon_command), "gamemodetext %s %s.%s%s", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	SendRconCommand(rcon_command);

	// Gamemode settings
	ShowNameTags(1);
	UsePlayerPedAnims();
	DisableInteriorEnterExits();
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(false);
	ManualVehicleEngineAndLights();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);

	// Textdraw Model
	printf("Loading textdraw model selection...");
	maleskinlist = LoadModelSelectionMenu("civillian_male_skins.txt");
	femaleskinlist = LoadModelSelectionMenu("civillian_female_skins.txt");

	// Objects
	printf("Creating objects...");
	CreateDynamicObject(3089, 2160.5, 1603.3000488281, 1000.299987793, 0, 0, 270, -1, 1, -1, 25); // Phone Network inside door
	CreateDynamicObject(1506, 365.80, 196.24, 1007.37,   0.00, 0.00, 0.00, 26);//CNN News inside door
	return 1;
}

//------------------------------------------------------------------------------

// Iterators
new	Iterator:House<MAX_HOUSES>;
new	Iterator:Business<MAX_HOUSES>;

//------------------------------------------------------------------------------

// Modules

/* Defs */
#include "../modules/def/checkpoint.pwn"
#include "../modules/def/achievement.pwn"
#include "../modules/def/ranks.pwn"
#include "../modules/def/buttons.pwn"
#include "../modules/def/job.pwn"
#include "../modules/def/dialogs.pwn"
#include "../modules/def/ftime.pwn"
#include "../modules/def/messages.pwn"
#include "../modules/def/missions.pwn"
#include "../modules/def/statscol.pwn"

/* Data */
#include "../modules/data/connection.pwn"
#include "../modules/data/building.pwn"
#include "../modules/data/vehicle.pwn"
#include "../modules/data/faction.pwn"
#include "../modules/data/player.pwn"

/* Properties */
#include "../modules/properties/vehicle.pwn"
#include "../modules/properties/apartment.pwn"
#include "../modules/properties/house.pwn"
#include "../modules/properties/business.pwn"

/* Vehicle */
#include "../modules/vehicle/control.pwn"
#include "../modules/vehicle/reserve.pwn"
#include "../modules/vehicle/dschool.pwn"
#include "../modules/vehicle/status.pwn"
#include "../modules/vehicle/fueling.pwn"

/* Game */
#include "../modules/game/mapicons.pwn"
#include "../modules/game/automsg.pwn"
#include "../modules/game/pause.pwn"
#include "../modules/game/clock.pwn"
#include "../modules/game/preloadanim.pwn"

/* Gameplay */
#include "../modules/gameplay/8track.pwn"
#include "../modules/gameplay/motocross.pwn"
#include "../modules/gameplay/handshake.pwn"
#include "../modules/gameplay/blowjob.pwn"
#include "../modules/gameplay/hospital.pwn"
#include "../modules/gameplay/lottery.pwn"
#include "../modules/gameplay/tutorial.pwn"
#include "../modules/gameplay/weather.pwn"
#include "../modules/gameplay/phone.pwn"
#include "../modules/gameplay/paintball.pwn"
#include "../modules/gameplay/shtrange.pwn"
#include "../modules/gameplay/gps.pwn"

/* Player */
#include "../modules/player/achievement.pwn"
#include "../modules/player/chat.pwn"
#include "../modules/player/commands.pwn"
#include "../modules/player/deadbody.pwn"
#include "../modules/player/needs.pwn"
#include "../modules/player/pets.pwn"

/* Server */
#include "../modules/server/rcon.pwn"

/* Admin */
#include "../modules/admin/funcs.pwn"
#include "../modules/admin/commands.pwn"

/* Cutscenes */
#include "../modules/cutscenes/cityhall.pwn"

/* Visual */
#include "../modules/visual/speedo.pwn"
#include "../modules/visual/subtitles.pwn"
#include "../modules/visual/needs.pwn"
#include "../modules/visual/stats.pwn"
#include "../modules/visual/gps.pwn"
#include "../modules/visual/logo.pwn"

/* NPCs */
#include "../modules/npcs/actors.pwn"
#include "../modules/npcs/npcs.pwn"

/* Jobs */
#include "../modules/job/pilot.pwn"
#include "../modules/job/trucker.pwn"
#include "../modules/job/lumberjack.pwn"
#include "../modules/job/navigator.pwn"
#include "../modules/job/paramedic.pwn"

/* Missions */
#include "../modules/missions/gta.pwn"
#include "../modules/missions/colonel.pwn"

/* Objects */
#include "../modules/objects/hospital.pwn"
#include "../modules/objects/airport.pwn"
#include "../modules/objects/player.pwn" // a.k.a attachments

/* Core */
#include "../modules/core/timers.pwn"

//------------------------------------------------------------------------------

main()
{
	printf("\n\n%s %s.%s%s initialiazed.\n", SCRIPT_VERSION_NAME, SCRIPT_VERSION_MAJOR, SCRIPT_VERSION_MINOR, SCRIPT_VERSION_PATCH);
	printf("============================================================\n");
}
