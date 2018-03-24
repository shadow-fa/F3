// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// SET KEY VARIABLES

f_var_mapClickTeleport_telePos = nil;
if (isNil "f_var_mapClickTeleport_Used") then {f_var_mapClickTeleport_Used = 0};

// ====================================================================================

// TELEPORT FUNCTIONALITY
// Open the map for the player and display a notification, then set either the player's vehicle
// or the unit to the new position. If the group needs to be teleported too, set the group's position
// as well.

["MapClickTeleport",[f_var_mapClickTeleport_textSelect]] call BIS_fnc_showNotification;

["mapClickTeleportEH", "onMapSingleClick", {f_var_mapClickTeleport_telePos = _pos;}] call BIS_fnc_addStackedEventHandler;
openMap [true, false];
waitUntil {!isNil "f_var_mapClickTeleport_telePos"};
["mapClickTeleportEH", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//Select units to be teleported
private _units = [player];
if (f_var_mapClickTeleport_GroupTeleport) then {
	_units = units group player;
};

// Move player/group
// If the player is in a vehicle and not HALO-ing, the complete vehicle is moved.
// Otherwise the players are teleported individually.

if (vehicle player != player && f_var_mapClickTeleport_Height == 0) then {
	(vehicle player) setPos (f_var_mapClickTeleport_telePos findEmptyPosition [0,150,typeOf (vehicle player)]);

	["MapClickTeleport",[f_var_mapClickTeleport_textDone]] call BIS_fnc_showNotification;

	//Filter for units that are not in the group-leader's vehicle
	//These units still need to be teleported.
	_units = _units select {vehicle _x != vehicle player};
};

{
	[_x,f_var_mapClickTeleport_telePos] remoteExec ["f_fnc_mapClickTeleportSetPos", _x];
} forEach _units;

openMap [false, false];

// ====================================================================================

// REMOVE ACTION
// Remove the action if we don't have any uses left

f_var_mapClickTeleport_Used = f_var_mapClickTeleport_Used + 1;

if (f_var_mapClickTeleport_Uses != 0 && f_var_mapClickTeleport_Used >= f_var_mapClickTeleport_Uses) then {
	player removeAction f_mapClickTeleportAction;
};
