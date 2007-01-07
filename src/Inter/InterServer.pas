//------------------------------------------------------------------------------
//InterServer			                                                        UNIT
//------------------------------------------------------------------------------
//	What it does-
//      The Inter Server.
//    Contains the brunt of the Inter and packet processes.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
unit InterServer;
interface

uses
  IdTCPServer,
  IdTCPClient,
  IdContext,
	SysUtils,
  InterOptions;

type
	TInterServer = class
  protected
  //
	private
		fIP              : String;
    fPort            : Word;

    TCPServer        : TIdTCPServer;
    ToZoneTCPClient : TIdTCPClient;

    Procedure OnExecute(AConnection: TIdContext);
    Procedure OnConnect(AConnection: TIdContext);
    Procedure OnException(AConnection: TIdContext;
      AException: Exception);

    //procedure ProcessInterPacket(AClient : TIdContext);

		Procedure SetIPCardinal(Value : string);
    Procedure SetPort(Value : Word);
    Function GetStarted() : Boolean;

    Procedure LoadOptions;

  public
		IPCardinal    : Cardinal;
		ServerName    : String;

    Options : TInterOptions;

		property IP   : string read fIP write SetIPCardinal;
    property Port : Word read fPort write SetPort;
    property Started : Boolean read GetStarted;

    Constructor Create();
    Destructor  Destroy();Override;
    Procedure   Start(Reload : Boolean = FALSE);
		Procedure   Stop();
	end;
implementation

uses
	//Helios
	WinLinux,
	Database,
	Globals,
	TCPServerRoutines,
	//3rd
	StrUtils;

//------------------------------------------------------------------------------
//Create  ()                                                        CONSTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Initializes our character server
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Constructor TInterServer.Create;
begin
  TCPServer := TIdTCPServer.Create;
  ToZoneTCPClient := TIdTCPClient.Create;

  TCPServer.OnConnect   := OnConnect;
  TCPServer.OnExecute   := OnExecute;
	TCPServer.OnException := OnException;

  LoadOptions;
end;{Create}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Destroy()                                                        DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Destroys our character server
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Destructor TInterServer.Destroy;
begin
  TCPServer.Free;
  ToZoneTCPClient.Free;
  Options.Save;
  Options.Free;
end;{Destroy}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//OnConnect()                                                              EVENT
//------------------------------------------------------------------------------
//	What it does-
//			An event which fires when a user connects to the Inter Server.
//
//	Changes -
//		November 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
procedure TInterServer.OnConnect(AConnection: TIdContext);
begin
	//inter server connect code here
end;{TMainProc.ZoneServerConnect}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//OnExecute()                                                             EVENT
//------------------------------------------------------------------------------
//	What it does-
//			An event which fires when the server is started. It allows the server
//    to accept incoming client connections.
//
//	Changes -
//		November 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
procedure TInterServer.OnExecute(AConnection: TIdContext);
begin
	//add packet parser here
end;{TMainProc.InterServerExecute}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//OnException                                                             EVENT
//------------------------------------------------------------------------------
//	What it does-
//			Handles Socket exceptions gracefully by outputting the exception message
//    and then disconnecting the client.
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TInterServer.OnException(AConnection: TIdContext;
	AException: Exception);
begin
	if AnsiContainsStr(AException.Message, IntToStr(10053)) or
		AnsiContainsStr(AException.Message, IntToStr(10054))
	then begin
		AConnection.Connection.Disconnect;
	end;
end;{OnException}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Start()                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//		 Enables the Inter server to accept incoming connections
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Procedure TInterServer.Start(Reload : Boolean = FALSE);
begin
  if Reload then
  begin
    LoadOptions;
  end;
  Port := Options.Port;
  ActivateServer('Inter',TCPServer);
	//ActivateClient(ToZoneTCPClient);
end;{Start}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Stop()                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//		 Stops the Inter server from accepting incoming connections
//
//	Changes -
//		September 19th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Procedure TInterServer.Stop();
begin
  DeActivateServer('Inter',TCPServer);
  //DeActivateClient(ToZoneTCPClient);
end;{Start}
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
Procedure TInterServer.LoadOptions;
begin
  if Assigned(Options) then
  begin
    FreeAndNIL(Options);
  end;

  Options    := TInterOptions.Create('./Inter.ini');

	Options.Load;
end;{LoadOptions}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//SetIPCardinal   			                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//      The Ragnarok client does not connect to a server using the plain x.x.x.x
//    IP string format.  It uses a cardinal form.  Making the IP a property, we
//    are able to call a function to go ahead and set the Cardinal form at any
//    time.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TInterServer.SetIPCardinal(Value : string);
begin
	fIP         := GetIPStringFromHostname(Value);
	IPCardinal  := GetCardinalFromIPString(fIP);
end; //proc SetIPCardinal
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetPort                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the internal fPort variable to the value specified. Also sets the
//    TCPServer's port.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Procedure TInterServer.SetPort(Value : Word);
begin
  fPort := Value;
  TCPServer.DefaultPort := Value;
end;//SetPort
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetStarted                                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Checks to see if the internal TCP server is active, if it is it returns
//    true.
//
//	Changes -
//		January 4th, 2007 - RaX - Created.
//
//------------------------------------------------------------------------------
Function TInterServer.GetStarted() : Boolean;
begin
  Result := TCPServer.Active;
end;{SetPort}
//------------------------------------------------------------------------------
end.
