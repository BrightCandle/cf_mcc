//===============================================================MCC_fnc_handleDamage=========================================================================================
// Handle damage on players and AI
//==============================================================================================================================================================================
private ["_unit","_selectionName","_damage","_source","_bleeding","_unconscious","_string"];
_unit 			= _this select 0;
_selectionName	= tolower (_this select 1);
_damage			= _this select 2;
_source			= _this select 3;
_fatal			= true;

if (_damage < 0.0001) exitWith {};

//Get params
_severeInjury 	= _unit getVariable ["MCC_medicSeverInjury",false];
_unconscious 	= _unit getVariable ["MCC_medicUnconscious",false];

if (!local _unit || (damage _unit >=1)) then
{
	0;
}
else
{
	//Effects
	if (_unit == player) then
	{
		//Effects
		"dynamicBlur" ppEffectEnable true;
		"dynamicBlur" ppEffectAdjust [3];
		"dynamicBlur" ppEffectCommit 0;

		"dynamicBlur" ppEffectAdjust [0];
		"dynamicBlur" ppEffectCommit (_damage*10 max 0.5);
	};


	if (_selectionName in ["","head","body"] && _damage >= 1) then
	{
		//AI will not always get unconscious and sometimes just die
		if  (!(isPlayer _unit) && (random 1 > 0.3)) then
		{
			//GetXP
			if (CP_activated) then
			{
				_string = if (missionNamespace getVariable ["MCC_medicXPmesseges",false]) then {format ["For killing %1",name _unit]} else {""};
				[[getplayeruid _source, 500,_string], "MCC_fnc_addRating", _source] spawn BIS_fnc_MP;
			};

			_damage;
		}
		else
		{
			_damage = 0.9;
			[_unit,_source] spawn MCC_fnc_unconscious;
			_damage;
		}
	}
	else
	{
		_bleeding = (getDammage _unit) max (_unit getVariable ["MCC_medicBleeding",0]);
		_unit setVariable ["MCC_medicBleeding",_bleeding min 1,true];

		//Set damage coef
		(_damage * (if (isPlayer _unit) then {(missionNamespace getVariable ["MCC_medicDamageCoef",0.6])} else {1.6}));
	};
};