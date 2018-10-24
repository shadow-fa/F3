// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Only run this for players
if (!hasInterface) exitWith{};

// ====================================================================================

// MAKE SURE THE PLAYER INITIALIZES PROPERLY

if (isNull player) then
{
    waitUntil {sleep 0.1; !isNull player};
};

// ====================================================================================

// SET UP VARIABLES
// Make sure all global variables are initialized
if (isNil "f_var_mapClickTeleport_Uses")          then {f_var_mapClickTeleport_Uses = 0};
if (isNil "f_var_mapClickTeleport_TimeLimit")     then {f_var_mapClickTeleport_TimeLimit = 0};
if (isNil "f_var_mapClickTeleport_GroupTeleport") then {f_var_mapClickTeleport_GroupTeleport = false};
if (isNil "f_var_mapClickTeleport_Units")         then {f_var_mapClickTeleport_Units = []};
if (isNil "f_var_mapClickTeleport_Height")        then {f_var_mapClickTeleport_Height = 0};

// Setup the localized strings for the various stages of the component
// Depending on the setting of the height variable the strings either use the teleport or the HALO option.

private _string = if (f_var_mapClickTeleport_Height == 0) then {"Teleport"} else {"HALO"};

f_var_mapClickTeleport_textAction = localize format ["STR_f_mapClick%1Action",_string];
f_var_mapClickTeleport_textDone   = localize format ["STR_f_mapClick%1Done",_string];
f_var_mapClickTeleport_textSelect = localize format ["STR_f_mapClick%1Select",_string];

// Reduce the array to valid units only
f_var_mapClickTeleport_Units = f_var_mapClickTeleport_Units select {! isNil _x} apply {call compile format ["%1",_x]};

// ====================================================================================

// CHECK IF COMPONENT SHOULD BE ENABLED
// We end the script if it is not running on a server or if only group leaders can use
// the action and the player is not the leader of his/her group

if (count f_var_mapClickTeleport_Units > 0 && !(player in f_var_mapClickTeleport_Units)) exitWith {};
if (f_var_mapClickTeleport_GroupTeleport && player != leader group player)  exitWith {};

// ====================================================================================

// ADD BRIEFING PAGE - HALO
// Add a briefing page for everyone that can use the action or is affected by it

if (f_var_mapClickTeleport_Height > 0) then {
	if (f_var_mapClickTeleport_GroupTeleport) then {
		{
			[_x] remoteExec ["f_fnc_mapClickTeleportBriefing", _x, true];
		} forEach (units group player);
	} else {
		[] call f_fnc_mapClickTeleportBriefing;
	};
};

// ====================================================================================

// ADD TELEPORT ACTION TO PLAYER ACTION MENU
// Whilst the player is alive we add the teleport action to the player's action menu.
// If the player dies we wait until he is alive again and re-add the action.

f_mapClickTeleportAction = player addAction [f_var_mapClickTeleport_textAction,{[] spawn f_fnc_mapClickTeleportAction},"", 0, false,true,"","_this == player"];

if (f_var_mapClickTeleport_TimeLimit > 0) then {
	sleep f_var_mapClickTeleport_TimeLimit;
	player removeAction f_mapClickTeleportAction;
};
