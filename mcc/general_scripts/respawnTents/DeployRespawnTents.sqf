/*
Deploy respawn tents

*/
#define REQUIRE_MEMBERS 2
#define REQUIRE_DISTANCE 10

private ["_object","_caller","_index","_vars","_nearby","_pos","_safePos","_tentType","_obj"];

// Who activated the action?
_object 	= _this select 0;
_caller 	= _this select 1;
_index 		= _this select 2; 
_vars 		= _this select 3;

//How many players from my squads are near
_nearby = {alive _x && {_x in (units _caller)}} count (getPosATL _caller nearEntities ["CAManBase", REQUIRE_DISTANCE]);

if (_nearby < REQUIRE_MEMBERS) exitWith 
{
	systemchat format ["You require %1 more squad members within %2m",REQUIRE_MEMBERS-_nearby,REQUIRE_DISTANCE];
};
_pos = ATLtoASL(_caller modelToWorld [0,3,0]);

while {!lineIntersects [_pos, [_pos select 0, _pos select 1, (_pos select 2) + 1]] && _pos select 2 > getTerrainHeightASL _pos} do
{
	_pos set [2, (_pos select 2) - 0.1];
};

if (_pos select 2 < getTerrainHeightASL _pos) then
{
	_pos set [2, getTerrainHeightASL _pos];
};

while {lineIntersects [_pos, [_pos select 0, _pos select 1, (_pos select 2) + 1]]} do
{
	_pos set [2, (_pos select 2) + 0.01];
};

_obj = lineIntersectsObjs [_pos, getposASL player, player, player, true, 32];

if (lineIntersects [getPosASL player, _pos] || count _obj > 0) exitWith
{
	systemchat "No suitable position found";
};

_tentType = secondaryWeapon player;
_safePos = ASLtoATL _pos;

["Deploying",10] call MCC_fnc_interactProgress; 
player removeWeaponGlobal _tentType; 
[[group player, _safePos, getDir player, _tentType], "MCC_fnc_createRespawnTent", false] call BIS_fnc_mp;