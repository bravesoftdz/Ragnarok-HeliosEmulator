//------------------------------------------------------------------------------
//Console()				                                                         UNIT
//------------------------------------------------------------------------------
//	What it does-
//			This is the main process, it handles each server and the starting/
//    stopping of each.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
unit Console;

interface

uses
	Classes,
  Database,
  LoginServer,
	CharacterServer,
  InterServer,
  ZoneServer,
  HeliosOptions;

type

//------------------------------------------------------------------------------
//TMainProc                                                               CLASS
//------------------------------------------------------------------------------
	TMainProc = class(TComponent)
	public
		Run : Boolean;

		LoginServer 		: TLoginServer;
		CharacterServer : TCharacterServer;
		ZoneServer  		: TZoneServer;
		InterServer 		: TInterServer;

    Options         : THeliosOptions;

		procedure Console(Line : string);

    procedure LoadOptions;

		procedure Startup;
		procedure Shutdown;

		procedure ThirdPartyCredits;

		constructor Create(AOwner : TComponent); override;
		destructor  Destroy; override;
	end;{TMainProc}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//                            Published Variables
//------------------------------------------------------------------------------
var
	MainProc : TMainProc;
//------------------------------------------------------------------------------


implementation
uses
	SysUtils,
	{Helios}
	Globals,
	CharacterServerInfo,
	WinLinux
	{Third Party}
	;

//------------------------------------------------------------------------------
//TMainProc.Console()                                                 PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Alias of WriteLn. Makes a bit more sense here =)
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TMainProc.Console(Line : string);
begin
	WriteLn(Line);
end;{TMainProc.Console}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TMainProc.StartUp()                                                 PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Initializes each server to it's default values, then it activates them.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//		January 20th, 2007 - Tsusai - If server passes PreLoad check (packet_db
//			and database connect), then start the servers.  Readded Failed to 
//			Start message.
//
//------------------------------------------------------------------------------
procedure TMainProc.Startup;
var
	PreloadOK : boolean;
begin
	ThirdPartyCredits; //Load external credits file.
	AppPath  := ExtractFilePath(ParamStr(0));

	SetupTerminationCapturing;
	PreloadOK := InitGlobals;

	if PreloadOK then
	begin
		LoadOptions;

		//Start and create Enabled Servers
		if Options.LoginEnabled then
		begin
			LoginServer      := TLoginServer.Create;
			LoginServer.Start;
		end;
		//NOTE: Prior
		if Options.CharaEnabled then
		begin
			CharacterServer  := TCharacterServer.Create;
			CharacterServer.Start;
		end;

		if Options.InterEnabled then
		begin
			InterServer       := TInterServer.Create;
			InterServer.Start;
		end;

		if Options.ZoneEnabled then
		begin
			ZoneServer       := TZoneServer.Create;
			ZoneServer.Start;
		end;
	end;
	MainProc.Console('');

	Run := TRUE;

	if PreloadOK
		{and servers started ok} then
	begin
		Console('- Startup Success');
		Console('  For a list of console commands, input "/help".');
	end else
	begin
		Console('- Startup Failed');
		Console('  Please see what error was mentioned above, close this program '+
			'and correct');
	end;
	Console('');

end;{TMainProc.Startup}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TMainProc.Shutdown()                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Gracefully disconnects clients, Saves online characters,  then calls
//    Destroy Globals.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//		January 20th, 2007 - Tsusai - Reversed shutdown order so server clients
//			aren't disconnected and attempt to reconnect (cleaner shutdown 
//			messages)
//
//------------------------------------------------------------------------------
procedure TMainProc.Shutdown;
begin
	Console('- Helios is shutting down...');
	//Go backwards (so zone doesn't try and connect to character while shutting down)

	//Disconnect clients.
  if Assigned(ZoneServer) then
	begin
		ZoneServer.Stop;
		ZoneServer.Free;
	end;

	if Assigned(InterServer) then
	begin
		InterServer.Stop;
		InterServer.Free;
	end;

	//NOTE: Prior
	if Assigned(CharacterServer) then
	begin
		CharacterServer.Stop;
		CharacterServer.Free;
	end;

	if Assigned(LoginServer) then
	begin
		LoginServer.Stop;
		LoginServer.Free;
	end;

  Options.Save;
  Options.Free;

	//Make sure globals are Free'd on Application exit.
	DestroyGlobals;

end;{TMainProc.Shutdown}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TMainProc.ThirdPartyCredits()                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Writes the credits defined in thirdparty.txt to the console.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TMainProc.ThirdPartyCredits;
var
	ThirdParty  : TStringList;
	LineIndex   : Integer;
begin
	if FileExists(AppPath + '3rdParty.txt') then
	begin
		ThirdParty := TStringList.Create;
		ThirdParty.LoadFromFile(AppPath + '3rdParty.txt');
		for LineIndex := 0 to ThirdParty.Count - 1 do
		begin
			Console('  '+ThirdParty.Strings[LineIndex]);
		end;
		ThirdParty.Free;
	end;
end;{TMainProc.ThirdPartyCredits}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//LoadOptions                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Creates and Loads the inifile.
//
//	Changes -
//		January 4th, 2007 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Procedure TMainProc.LoadOptions;
begin
  if Assigned(Options) then
  begin
    FreeAndNIL(Options);
  end;

  Options    := THeliosOptions.Create('./Helios.ini');

	Options.Load;
end;{LoadOptions}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//TMainProc.Create()                                                CONSTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Initializes the servers and starts them.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
constructor TMainProc.Create(AOwner : TComponent);
begin
	inherited Create(AOwner);
end;{TMainProc.Create}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TMainProc.Destroy()                                               DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Shutdown all servers and free em' up!
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
destructor  TMainProc.Destroy;
begin
	inherited Destroy;
end;{TMainProc.Destroy}
//------------------------------------------------------------------------------


end{Console}.
