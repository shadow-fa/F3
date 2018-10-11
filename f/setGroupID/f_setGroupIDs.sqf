// F3 - Set Group IDs
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================

// Automatically assigns intelligible names to groups

// SET GROUP IDS
// Execute setGroupID Function for all factions
{
	_x params ["_grp", "", "", "", "_id"];
	if (_id != "") then {
		[_grp, _id] call f_fnc_setGroupID;
	}
} forEach f_var_groupData_all;
