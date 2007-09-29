//------------------------------------------------------------------------------
//GMCommands                                                                UNIT
//------------------------------------------------------------------------------
//	What it does-
//      	Holds all of our GMCommand related routines.
//
//	Changes -
//		March 19th, 2007 - RaX - Created.
//		[2007/03/28] CR - Cleaned up uses clauses, using Icarus as a guide.
//
//------------------------------------------------------------------------------
unit GMCommands;


interface


uses
	{RTL/VCL}
	Classes,
	{Project}
	Character,
	GMCommandsOptions,
	CustomGMCommandNameOptions,
	{3rd Party}
	List32
	;

const
	TYPE_BROADCAST  = 0;  //All zone receive, no player involved
	TYPE_RETURNBACK = 1;  //Orignal zone receiv, no player involved
	TYPE_ALLPLAYERS = 2;  //All players in all zone involved
	TYPE_TARGETCHAR = 3;  //Specific player(character) involved
	TYPE_TARGETMAP  = 4;  //All players in specific map involved

	GMFLAG_NORMAL   = 0;  //Normal mode, argument will be splitted for use
	GMFLAG_NOSPLIT  = 1;  //NO Split mode, use for only one argument, eg #broadcast, prevent split space and ","
type
	TGMCommand = procedure(
		const
			Arguments  : array of String;
			FromChar   : String;
			TargetChar : TCharacter;
		var
			Error : TStringList
		);

	TGMCommands = class(TObject)
	protected
		fCommands : TStringList;
		fTmpCommandList : TStringList; // Initial use only
//		fNames  : TStringList;
//		fLevels : TIntList32;
//		fTypes  : TIntList32;
//		fFlag   : TIntList32;
//		fSyntax : TStringList;

		LevelOptions : TGMCommandsOptions;
		NameOptions  : TCustomGMCommandNameOptions;
	public
//		Commands : array of TGMCommand;
		// Replacement XD
		function GetCommandFunc(Index: Integer): TGMCommand;

		property Commands[Index: Integer]: TGMCommand read GetCommandFunc;

		Constructor Create;
		Destructor  Destroy; override;
		function AddCommand(
			const
				Name        : String;
			const
				CommandFunc : TGMCommand;
			const
				Level       : Byte;
			const
				AType       : Byte;
			const
				AFlag       : Byte;
			const
				ASyntax     : String
			) : Word;

		function IsCommand(
			const
				Chat : String
			) : Boolean;

		function GetCommandID(
			const
				Name : String
			) : Integer;

		function GetCommandGMLevel(
				CommandID : Integer
			): Byte;

		Function  GetCommandName(
			const
				Chat : String
			) : String;

		function GetCommandType(
			const
				CommandID : Word
			): Byte;

		function GetCommandFlag(
			const
				CommandID : Word
			): Byte;

		function GetSyntax(
			const
				CommandID : Word
			): String;
	end;

	TCommand = class
		Name        : String;
		Level       : Byte;
		CommandType : Byte;    //Should the command send to single zone/broadcast? or something else
		Flag        : Byte;    //To tell inter server don't break parameter!
		Syntax      : String;  //Help message XD

		CommandFunc : TGMCommand;
	end;
implementation

uses
	{RTL/VCL}
	SysUtils,
	{Project}
	Main,
	GMCommandExe
	{3rd Party}
	//none
	;

//------------------------------------------------------------------------------
//Create                                                             CONSTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//      	Creates our gm command component.
//
//	Changes -
//		March 19th, 2007 - RaX - Created.
//
//------------------------------------------------------------------------------
Constructor TGMCommands.Create;
begin
	inherited;
	fCommands := TStringList.Create;
	fTmpCommandList := TStringList.Create;
//	fNames  := TStringList.Create;
//	fLevels := TIntList32.Create;
//	fTypes  := TIntList32.Create;
//	fFlag   := TIntList32.Create;
//	fSyntax := TStringList.Create;

	LevelOptions := TGMCommandsOptions.Create(MainProc.Options.ConfigDirectory+'/GMCommandLevels.ini');
	NameOptions := TCustomGMCommandNameOptions.Create(MainProc.Options.ConfigDirectory+'/GMCommandNames.ini');

	//AddCommand(Command Name,   Calling Function, Lvl required, command type, argument parsing mode, Syntax Help Message)
	AddCommand('ZoneStatus',      GMZoneStatus,           1,  TYPE_BROADCAST,  GMFLAG_NORMAL,  '');
	// - - - Warps
	AddCommand('Warp',            GMWarp,                 99, TYPE_RETURNBACK, GMFLAG_NORMAL,  '#Warp <Map Name>,<X>,<Y>');
	AddCommand('WarpDev',         GMWarpDev,              99, TYPE_RETURNBACK, GMFLAG_NORMAL,  '#WarpDev <Map Name>,<X>,<Y>');
	AddCommand('Jump',            GMJump,                 99, TYPE_RETURNBACK, GMFLAG_NORMAL,  '#Jump [X],[Y]');
        // - - - Player Control
	AddCommand('GiveBaseExp',     GMGiveBaseExperience,   99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#GiveBaseExp <Player Name>,<Amount>');
	AddCommand('GiveJobExp',      GMGiveJobExperience,    99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#GiveJobExp <Player Name>,<Amount>');
	AddCommand('BaseLevelUp',     GMBaseLevelUp,          99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#BaseLevelUp <Player Name>,<Amount>');
	AddCommand('JobLevelUp',      GMJobLevelUp,           99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#JobLevelUp <Player Name>,<Amount>');
	AddCommand('AddStatusPoints', GMAddStatusPoints,      99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#AddStatusPoints <Player Name>,<Amount>');
	AddCommand('AddSkillPoints',  GMAddSkillPoints,       99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#AddSkillPoints <Player Name>,<Amount>');
	AddCommand('GiveZeny',        GMGiveZeny,             99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#GiveZeny <Player Name>,<Amount>');
	AddCommand('GiveStat',        GMGiveStat,             99, TYPE_TARGETCHAR, GMFLAG_NORMAL,  '#GiveStat <Player Name>,<Type>,<Amount>');
        AddCommand('ResetStats',      GMResetStats,           99, TYPE_TARGETCHAR, GMFLAG_NOSPLIT, '#ResetStats <Player Name>');
	// - - - Broadcast Sets
	AddCommand('BroadCast',       GMBroadCast,            99, TYPE_ALLPLAYERS, GMFLAG_NOSPLIT, '#BroadCast <Message>');
	AddCommand('BroadCastN',      GMBroadCastNoName,      99, TYPE_ALLPLAYERS, GMFLAG_NOSPLIT, '#BroadCastN <Message>');
	AddCommand('BroadCastL',      GMBroadCastLocal,       99, TYPE_RETURNBACK, GMFLAG_NOSPLIT, '#BroadCastL <Message>');
	AddCommand('BroadCastLN',     GMBroadCastLocalNoName, 99, TYPE_RETURNBACK, GMFLAG_NOSPLIT, '#BroadCastLN <Message>');
	AddCommand('BroadCastLB',     GMBroadCastLocalBlue,   99, TYPE_RETURNBACK, GMFLAG_NOSPLIT, '#BroadCastLB <Message>');

	// Use temperary list!!!
	LevelOptions.Load(fTmpCommandList);
	LevelOptions.Save(fTmpCommandList);

	NameOptions.Load(fTmpCommandList, fCommands);
end;{Create}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Destroy                                                             DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//      	destroys our component.
//
//	Changes -
//		March 19th, 2007 - RaX - Created.
//
//------------------------------------------------------------------------------
Destructor TGMCommands.Destroy;
begin
	fCommands.Free;
	fTmpCommandList.Free;
//	fNames.Free;
//	fLevels.Free;
//	fTypes.Free;
//	fFlag.Free;
//	fSyntax.Free;

	LevelOptions.Free;
	NameOptions.Free;
	inherited;
end;{Create}
//------------------------------------------------------------------------------


(*- Function ------------------------------------------------------------------*
TGMCommands.AddCommand
--------------------------------------------------------------------------------
Overview:
--
	Adds a GM command to the list.

	Returns the index in the Commands array where this newly added command was
	inserted.

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/03/19] RaX - Created
[2007/06/01] CR - Added to explanation of routine (return value).  Made all
	parameters constant.
*-----------------------------------------------------------------------------*)
function TGMCommands.AddCommand(
	const
		Name        : String;
	const
		CommandFunc : TGMCommand;
	const
		Level       : Byte;
	const
		AType       : Byte;
	const
		AFlag       : Byte;
	const
		ASyntax     : String
	) : Word;
var
	Command : TCommand;
Begin
//	SetLength(Commands, Length(Commands)+1);
//	Commands[Length(Commands)-1] := Command;

	Command := TCommand.Create;
	Command.Name := Name;
	Command.Level := Level;
	Command.CommandType := AType;
	Command.Flag := AFlag;
	Command.Syntax := ASyntax;
	Command.CommandFunc := CommandFunc;

	Result := fTmpCommandList.AddObject(Name, Command);

//	fLevels.Add(Level);
//	fTypes.Add(AType);
//	fFlag.Add(AFlag);
//	fSyntax.Add(ASyntax);
//	Result := fNames.Add(Lowercase(Name));
end; (* Func TGMCommands.AddCommand
*-----------------------------------------------------------------------------*)


(*- Function ------------------------------------------------------------------*
TGMCommands.GetCommandName
--------------------------------------------------------------------------------
Overview:
--
	Parses a GM command and returns the command name

--
Pre:
	TODO
Post:
	TODO

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/03/21] RaX - Created.
[2007/06/01] CR - Altered comment header, used try-finally as a resource
	protection for our local Stringlist until freed.
*-----------------------------------------------------------------------------*)
Function  TGMCommands.GetCommandName(
	const
		Chat : String
	) : String;
Var
	TempList : TStringList;
	TempChat : String;
Begin
	TempChat := Trim(Chat);
	TempList := TStringList.Create;
	try
		TempList.DelimitedText := TempChat;
		TempList[0] := Copy(TempList[0], 2, Length(TempList[0]));
		Result := TempList[0];
	finally
		TempList.Free;
	end;//t-f
End; (* Func TGMCommands.GetCommandName
*-----------------------------------------------------------------------------*)

//------------------------------------------------------------------------------
//GetCommandName                                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//      	Parses a gm command and returns the command name
//
//	Changes -
//		March 21st, 2007 - RaX - Created.
//
//------------------------------------------------------------------------------
function TGMCommands.GetCommandGMLevel(CommandID: Integer) : Byte;
var
	Command : TCommand;
begin
	Command := fCommands.Objects[CommandID] as TCommand;
	Result := Command.Level;
end;
//------------------------------------------------------------------------------


(*- Function ------------------------------------------------------------------*
TGMCommands.IsCommand
--------------------------------------------------------------------------------
Overview:
--
	Checks to see if a supplied chat string is a gm command.

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/03/19] RaX - Created.
[2007/06/01] CR - Altered Comment Header.  Boolean simplification for Result
	assignment (no if statement needed).  Used try-finally resource protection for
	local StringList variable.
*-----------------------------------------------------------------------------*)
Function  TGMCommands.IsCommand(
	const
		Chat : String
	) : Boolean;
Var
	TempList : TStringList;
	TempChat : String;
Begin
	Result := FALSE;
	TempChat := Trim(Chat);
	if (TempChat[1] = '#') then
	begin
		TempList := TStringList.Create;
		try
			TempList.DelimitedText := TempChat;
			TempList[0] := Copy(TempList[0], 2, Length(TempList[0]));
			Result := (GetCommandID(TempList[0]) <> -1);
		finally
			TempList.Free;
		end;//t-f
	end;
End; (* Func TGMCommands.IsCommand
*-----------------------------------------------------------------------------*)


(*- Function ------------------------------------------------------------------*
TGMCommands.GetCommandID
--------------------------------------------------------------------------------
Overview:
--
	Gets the command ID for a gm command.


--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/03/19] RaX - Created
[2007/06/01] CR - Made string parameter constant (speedup/efficiency)
*-----------------------------------------------------------------------------*)
Function  TGMCommands.GetCommandID(
	const
		Name : String
	) : Integer;
Begin
	Result := fCommands.IndexOf(LowerCase(Name));
End; (* Func TGMCommands.GetCommandID
*-----------------------------------------------------------------------------*)


(*- Function ------------------------------------------------------------------*
TGMCommands.GetCommandType
--------------------------------------------------------------------------------
Overview:
--
	Gets the command type (used in inter server)

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/08/08] Aeomin - Created
*-----------------------------------------------------------------------------*)
function TGMCommands.GetCommandType(
	const
		CommandID : Word
	): Byte;
var
	Command : TCommand;
begin
	Command := fCommands.Objects[CommandID] as TCommand;
	Result := Command.CommandType;
end; (* Func TGMCommands.GetCommandType
*-----------------------------------------------------------------------------*)


(*- Function ------------------------------------------------------------------*
TGMCommands.GetCommandFlag
--------------------------------------------------------------------------------
Overview:
--
	Gets the command Flag (used in inter server)

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/08/09] Aeomin - Created
*-----------------------------------------------------------------------------*)
function TGMCommands.GetCommandFlag(
	const
		CommandID : Word
	): Byte;
var
	Command : TCommand;
begin
	Command := fCommands.Objects[CommandID] as TCommand;
	Result := Command.Flag;
end; (* Func TGMCommands.GetCommandFlag
*-----------------------------------------------------------------------------*)


(*- Function ------------------------------------------------------------------*
TGMCommands.GetSyntax
--------------------------------------------------------------------------------
Overview:
--
	Gets the command Syntax help message (used in inter server)

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/08/10] Aeomin - Created
*-----------------------------------------------------------------------------*)
function TGMCommands.GetSyntax(
			const
				CommandID : Word
			): String;
var
	Command : TCommand;
begin
	Command := fCommands.Objects[CommandID] as TCommand;
	Result := Command.Syntax;
end; (* Func TGMCommands.GetSyntax
*-----------------------------------------------------------------------------*)

function TGMCommands.GetCommandFunc(Index: Integer): TGMCommand;
var
	Command : TCommand;
begin
	Command := fCommands.Objects[Index] as TCommand;
	Result := Command.CommandFunc;
end;
end{GMCommands}.
