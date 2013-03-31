// Configuration
_tpdist = 10; //distance in front of player to land Vehicle

// End of configuration

#define KINDOF_ARRAY(a,b) [##a,##b] call {_veh = _this select 0;_types = _this select 1;_res = false; {if (_veh isKindOf _x) exitwith { _res = true };}forEach _types;_res}

_n2sh = 10;
_n2c = "Select Vehicle:";
selecteditem = ""; shnext = false;
if (isNil "vhnlist") then
{
	vhnlist = [];
	_kindOf = ["LandVehicle","Air","Ship"];
	_filter = ["BIS_Steerable_Parachute","ParachuteBase"];      
	_cfgvehicles = configFile >> "cfgVehicles";
	titleText ["Generating Vehicle list... Wait...","PLAIN DOWN"];titleFadeOut 2;
	for "_i" from 0 to (count _cfgvehicles)-1 do 
	{
	        _vehicle = _cfgvehicles select _i;
	        if (isClass _vehicle) then 
		{
	                _veh_type = configName(_vehicle);
	                if (
				(getNumber(_vehicle >> "scope")==2) and 
				(getText(_vehicle >> "picture")!="") and 
				(KINDOF_ARRAY(_veh_type,_kindOf)) and 
				!(KINDOF_ARRAY(_veh_type,_filter))) 
	
			then 
			{vhnlist set [count vhnlist,_veh_type];};
	        };
	};
	titleText ["List is ready...","PLAIN DOWN"];titleFadeOut 2;
};

shnext = false;

shnmenu = 
{
	_pmenu = [["",true],[_n2c, [-1], "", -5, [["expression", ""]], "1", "0"]];
	for "_i" from (_this select 0) to (_this select 1) do
	{_arr = [format['%1',vhnlist select (_i)], [_i - (_this select 0) + 2],  "", -5, [["expression", format["selecteditem = vhnlist select %1;",_i]]], "1", "1"];_pmenu set [_i+2, _arr];};
	_pmenu set [(_this select 1)+2, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];
	if (count vhnlist >  (_this select 1)) then 
	{_pmenu set [(_this select 1)+3, ["Next", [12], "", -5, [["expression", "shnext = true;"]], "1", "1"]];}
	else {_pmenu set [(_this select 1)+3, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];};
	_pmenu set [(_this select 1)+4, ["Exit", [13], "", -5, [["expression", "selecteditem = 'exitscript';"]], "1", "1"]];
	showCommandingMenu "#USER:_pmenu";
};
_j=0;if (_n2sh>9) then {_n2sh=10;};

while {selecteditem==""} do
{
	[_j,(_j+_n2sh) min (count vhnlist)] call shnmenu;_j=_j+_n2sh;
	WaitUntil {selecteditem!="" or shnext};	
	shnext = false;
};




if (selecteditem != "exitscript" and selecteditem != "") then
{	
	_allUnits = allUnits;
	player setVehicleInit "allUnits = [];";
	processInitCommands;
	clearVehicleInit player;
	allUnits = _allUnits;
	
	_dir = getdir vehicle player;
	_pos = getPos vehicle player;
	_pos = [(_pos select 0)-5*sin(_dir),(_pos select 1)-5*cos(_dir),0]; // 50 meters behind
	
	hangender = createVehicle [selecteditem, _pos, [], 0, "CAN_COLLIDE"];
	hangender setVariable ["ObjectUID", "skript made by Hangender", true];
	
};