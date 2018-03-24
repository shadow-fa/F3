// F3 - Mission Maker Teleport
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// ====================================================================================

// SET KEY VARIABLES

params [
	"_unit",
	["_pos", [0,0,0], [[]], 3]
];

private _dispersion = 100; // The maximum dispersion for units when HALO jumping

// ====================================================================================

// LOCALITY CHECK
// The component should not run anywhere else but where the unit is local by default
// This check is a redundancy to ensure this

if !(local _unit) exitWith {};

// ====================================================================================

// TELEPORT UNITS

if (f_var_mapClickTeleport_Height == 0) then {
	_pos = _pos vectorAdd [random 10 - random 10, random 10 - random 10, 0];
} else {
	_pos = _pos vectorAdd [random _dispersion - random _dispersion, random _dispersion - random _dispersion, f_var_mapClickTeleport_Height + random 15 - random 15];
};
_unit setPos _pos;

// Display a notification for players
if (_unit == vehicle player) then {["MapClickTeleport",[f_var_mapClickTeleport_textDone]] call BIS_fnc_showNotification};

// HALO - BACKPACK
// If unit is parajumping, spawn the following code to add a parachute and restore the old backpack after landing

if (f_var_mapClickTeleport_Height > 0) then {
	[_unit] spawn f_fnc_mapClickTeleportParachute;
};
