unit LuaNPCCore;

interface

uses
	LuaCoreRoutines;

	procedure PrepLuaForNPCScripts(ALua : TLua; CharaID : integer = 0);

implementation
uses
	LuaPas,
	LuaNPCCommands;


//Takes the passed Lua and applicable character id, and
//loads the registers our delphi functions into it.
procedure PrepLuaForNPCScripts(ALua : TLua; CharaID : integer = 0);
begin
	//Register our npc commands
	LoadNPCCommands(ALua);
	//Push character ID into the global variables.
	lua_pushliteral(ALua, 'char_id'); // Push global key for char_id
	lua_pushnumber(ALua, CharaID); // Push value for char_id
	lua_rawset(ALua,LUA_GLOBALSINDEX); // Tell Lua to set char_id as a global var
end;

end.
