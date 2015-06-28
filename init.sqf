// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.2
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat, [GoT] JoSchaap, AgentRev
//	@file Description: The main init.

#define DEBUG false

enableSaving [false, false];

_descExtPath = str missionConfigFile;
currMissionDir = compileFinal str (_descExtPath select [0, count _descExtPath - 15]);

X_Server = false;
X_Client = false;
X_JIP = false;

// versionName = ""; // Set in STR_WL_WelcomeToWasteland in stringtable.xml

if (isServer) then { X_Server = true };
if (!isDedicated) then { X_Client = true };
if (isNull player) then { X_JIP = true };

A3W_scriptThreads = [];

[DEBUG] call compile preprocessFileLineNumbers "globalCompile.sqf";

//init Wasteland Core
[] execVM "config.sqf";
[] execVM "storeConfig.sqf"; // Separated as its now v large
[] execVM "briefing.sqf";

if (!isDedicated) then
{
	[] spawn
	{
		if (hasInterface) then // Normal player
		{
			9999 cutText ["Welcome to SNAFU A3Wasteland, please wait for your client to initialize", "BLACK", 0.01];

			waitUntil {!isNull player};
			player setVariable ["playerSpawning", true, true];

			removeAllWeapons player;
			client_initEH = player addEventHandler ["Respawn", { removeAllWeapons (_this select 0) }];

			// Reset group & side
			[player] joinSilent createGroup playerSide;

			execVM "client\init.sqf";
		}
		else // Headless
		{
			waitUntil {!isNull player};
			if (typeOf player == "HeadlessClient_F") then
			{
				execVM "client\headless\init.sqf";
			};
		};
	};
};

if (isServer) then
{
	diag_log format ["############################# %1 #############################", missionName];
	diag_log "WASTELAND SERVER - Initializing Server";
	[] execVM "server\init.sqf";
};

//init 3rd Party Scripts (not supposed to run on HC)
if (hasInterface || isServer) then
{
	if (isServer) then {call compile preprocessFile "addons\extraSites\init.sqf";};
	[] execVM "addons\R3F_LOG\init.sqf"; //Cael817, Changed to R3F_LOG 3.1 
	[] execVM "addons\proving_ground\init.sqf";
	[] execVM "addons\scripts\DynamicWeatherEffects.sqf";
	[] execVM "addons\JumpMF\init.sqf";
	[] execVM "addons\scripts\intro.sqf"; //Cael817, Intro text from LouDnl
	[] execVM "addons\outlw_magRepack\MagRepack_init_sv.sqf"; //Cael817, Repack your half empty mags
	//[] execVM "addons\scripts\zlt_fastrope.sqf"; //Cael817, Fastroping from choppers
	[] execVM "addons\bounty\bounty.sqf"; //Cael817, Bounty
	//[] execVM "addons\restrictedArea\createTriggers.sqf"; //Cael817, not working, kills all players on the map
	[] execVM "addons\laptop\init.sqf"; //Cael817, Addon for hack laptop mission
	[] execVM "addons\APOC_Airdrop_Assistance\init.sqf"; //Cael817, APOCs airdrop_assistance
};
