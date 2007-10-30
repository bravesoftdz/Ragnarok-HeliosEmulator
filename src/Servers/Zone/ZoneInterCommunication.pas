//------------------------------------------------------------------------------
//ZoneInterCommunication	                                            UNIT
//------------------------------------------------------------------------------
//  What it does -
//      Houses our Zone<->Inter server communication routines. These are
//    used in ZoneServer.pas and also in InterServer.pas.
//
//  Changes -
//    March 18th, 2007 - RaX - Created.
//	[2007/10/25] Aeomin - Major clean up #1
//	[2007/10/25] Aeomin - Major clean up #1b
//------------------------------------------------------------------------------
unit ZoneInterCommunication;

interface
uses
	Classes,
	Types,
	ZoneServer,
	CommClient,
	IdContext,
	Character;

const
	WHISPER_SUCCESS  = 0;
	WHISPER_FAILED   = 1;
	WHISPER_BLOCKED  = 2;

	//----------------------------------------------------------------------
	// Server Validation
	//----------------------------------------------------------------------
	procedure ValidateWithInterServer(
		AClient : TInterClient;
		ZoneServer : TZoneServer
	);

	procedure SendValidateFlagToZone(
		AClient : TIdContext;
		Validated : byte
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// Update IP Address
	//----------------------------------------------------------------------
	procedure SendZoneWANIPToInter(
		AClient : TInterClient;
		ZoneServer : TZoneServer
	);
	procedure SendZoneLANIPToInter(
		AClient : TInterClient;
		ZoneServer : TZoneServer
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	//  Update Online player count
	//----------------------------------------------------------------------
	procedure SendZoneOnlineUsersToInter(
		AClient : TInterClient;
		ZoneServer : TZoneServer
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	//  Whisper handle
	//----------------------------------------------------------------------
	procedure SendWhisperToInter(
		AClient : TInterClient;
		const AChara: TCharacter;
		const TargetName, Whisper: String
	);
	procedure SendWhisperReplyToZone(
		AClient : TIdContext;
		CharID:LongWord;
		Code : byte
	);
	procedure RedirectWhisperToZone(
		AClient : TIdContext;
		const ZoneID,FromID,CharID:LongWord;
		const FromName,Whisper: String
	);
	procedure SendWhisperReplyToInter(
		AClient : TInterClient;
		const ZoneID, CharID:LongWord;
		Code : byte
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// GM Command Handle
	//----------------------------------------------------------------------
	procedure ZoneSendGMCommandtoInter(
		AClient : TInterClient;
		const AID, CharID:LongWord;
		const Command : string
	);
	procedure ZoneSendGMCommandResultToInter(
		const AccountID : LongWord;
		const CharacterID : LongWord;
		const ZoneID : LongWord;
		const Error : TStringList
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// Map Warp request
	//----------------------------------------------------------------------
	procedure ZoneSendMapWarpRequestToInter(
		AClient : TInterClient;
		const CharID, ZoneID : LongWord;
		const MapName: String;
		const APoint:TPoint
	);
	procedure ZoneSendMapWarpResultToInter(
		AClient : TInterClient;
		const CharID, ZoneID : LongWord;
		const MapName: String;
		const APoint:TPoint
	);
	//----------------------------------------------------------------------

implementation
uses
	Main,
	BufferIO,
	Globals,
	PacketTypes,
	TCPServerRoutines,
	SysUtils;

//------------------------------------------------------------------------------
//ValidateWithInterServer                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Sends the Inter server key, zone id, and zoneport to the inter
//    server for validation.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure ValidateWithInterServer(
	AClient : TInterClient;
	ZoneServer : TZoneServer
	);
var
	OutBuffer : TBuffer;
begin
	WriteBufferWord(0, $2200, OutBuffer);
	WriteBufferLongWord(2, ZoneServer.Options.ID, OutBuffer);
	WriteBufferWord(6, ZoneServer.Port, OutBuffer);
	WriteBufferMD5String(8, GetMD5(ZoneServer.Options.InterKey), OutBuffer);
	SendBuffer(AClient,OutBuffer,GetPacketLength($2200));
end;{ValidateWithInterServer}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendValidateFlagToZone                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      After validation, if a zone server checks out it is sent this flag back
//    which contains a simple TRUE/FALSE flag that lets a zone know that it
//    passed or not.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure SendValidateFlagToZone(
	AClient : TIdContext;
	Validated : byte
	);
var
	OutBuffer : TBuffer;
begin
	WriteBufferWord(0, $2201, OutBuffer);
	WriteBufferByte(2, Validated, OutBuffer);
	SendBuffer(AClient,OutBuffer,GetPacketLength($2201));
end;{SendValidateFlagToZone}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendZoneWANIPToChara                                                 PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Sends the zone's WANIP to the inter server.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure SendZoneWANIPToInter(
	AClient : TInterClient;
	ZoneServer : TZoneServer
	);
var
	OutBuffer : TBuffer;
	Size : integer;
begin
	Size := Length(ZoneServer.Options.WANIP);
	WriteBufferWord(0,$2202,OutBuffer);
	WriteBufferWord(2,Size+4,OutBuffer);
	WriteBufferString(4,ZoneServer.Options.WANIP,Size,OutBuffer);
	SendBuffer(AClient,OutBuffer,Size+4);
end;{SendZoneWANIPToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendZoneLANIPToInter                                                 PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Sends the zone's LANIP to the inter server.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure SendZoneLANIPToInter(
	AClient : TInterClient;
	ZoneServer : TZoneServer
	);
var
	OutBuffer : TBuffer;
	Size : integer;
begin
	Size := Length(ZoneServer.Options.LANIP);
	WriteBufferWord(0,$2203,OutBuffer);
	WriteBufferWord(2,Size+4,OutBuffer);
	WriteBufferString(4,ZoneServer.Options.LANIP,Size,OutBuffer);
	SendBuffer(AClient,OutBuffer,Size+4);
end;{SendZoneLANIPToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendZoneOnlineUsersToInter                                           PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Updates the inter server's internal list of online inters.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure SendZoneOnlineUsersToInter(
	AClient : TInterClient;
	ZoneServer : TZoneServer
	);
var
	OutBuffer : TBuffer;
begin
	WriteBufferWord(0,$2204,OutBuffer);
	WriteBufferWord(2,ZoneServer.OnlineUsers,OutBuffer);
	SendBuffer(AClient,OutBuffer,GetPacketLength($2204));
end;{SendZoneOnlineUsersToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendWhisperToInter                                                   PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Send Whisper to Inter server
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure SendWhisperToInter(
	AClient : TInterClient;
	const AChara: TCharacter;
	const TargetName,Whisper: String
	);
var
	OutBuffer : TBuffer;
	Size : Integer;
begin
	//Strlen is used here to count..since length count 2 byte character as one (UNICODE)
	Size := StrLen(PChar(Whisper));
	WriteBufferWord(0,$2210,OutBuffer);
	WriteBufferWord(2,Size + 56,OutBuffer);
	WriteBufferLongWord(4,AChara.CID,OutBuffer);
	WriteBufferString(8,AChara.Name, 24, OutBuffer);
	WriteBufferString(32,TargetName, 24, OutBuffer);
	WriteBufferString(56,Whisper,Size,OutBuffer);
	SendBuffer(AClient,OutBuffer,Size + 56);
end;{SendWhisperToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendWhisperReplyToZone                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Send Zone of whisper reply from Inter
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure SendWhisperReplyToZone(
	AClient : TIdContext;
	CharID:LongWord;
	Code : byte
	);
var
	OutBuffer : TBuffer;
begin
	WriteBufferWord(0,$2212,OutBuffer);
	WriteBufferLongWord(2,CharID,OutBuffer);
	WriteBufferByte(6, Code, OutBuffer);
	SendBuffer(AClient, OutBuffer, GetPacketLength($2212));
end;{SendWhisperReplyToZone}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RedirectWhisperToZone                                                PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Inter redirect whisper message to proper Zone
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure RedirectWhisperToZone(
	AClient : TIdContext;
	const ZoneID,FromID,CharID:LongWord;
	const FromName,Whisper: String
	);
var
	OutBuffer : TBuffer;
	Size : Integer;
begin
	Size := StrLen(PChar(Whisper));
	WriteBufferWord(0,$2210,OutBuffer);
	WriteBufferWord(2,Size + 40,OutBuffer);
	WriteBufferLongWord(4,ZoneID,OutBuffer);
	WriteBufferLongWord(8,FromID,OutBuffer);
	WriteBufferLongWord(12,CharID,OutBuffer);
	WriteBufferString(16,FromName,24,OutBuffer);
	WriteBufferString(40,Whisper,Size,OutBuffer);
	SendBuffer(AClient, OutBuffer, Size + 40);
end;{RedirectWhisperToZone}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendWhisperReplyToInter                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Zone send whisper status reply to Inter
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure SendWhisperReplyToInter(
	AClient : TInterClient;
	const ZoneID, CharID:LongWord;
	Code : byte
	);
var
	OutBuffer : TBuffer;
begin
	WriteBufferWord(0,$2211,OutBuffer);
	WriteBufferLongWord(2,ZoneID,OutBuffer);
	WriteBufferLongWord(6,CharID,OutBuffer);
	WriteBufferByte(10, Code, OutBuffer);
	SendBuffer(AClient, OutBuffer, GetPacketLength($2211));
end;{SendWhisperReplyToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ZoneSendGMCommandtoInter                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Sends the received GM command to the inter server.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//[2007/03/19] RaX - Created Header;
//[2007/05/01] Tsusai - Added const to the parameters
//[2007/06/01] CR - Altered Comment Header, minor formatting/bracketing changes,
//	use of try-finally to ensure no leaks if errors occur before our local
//	Stringlist is freed.
//[2007/7/23] Aeomin - Moved from ZoneSend.pas
//------------------------------------------------------------------------------
procedure ZoneSendGMCommandtoInter(
	AClient : TInterClient;
	const AID, CharID:LongWord;
	const Command : string
	);
var
	TotalLength : Integer;
	OutBuffer   : TBuffer;
begin
	TotalLength := 19 + StrLen(PChar(Command));
	WriteBufferWord(0, $2205, OutBuffer);
	WriteBufferWord(2, TotalLength, OutBuffer);

	WriteBufferLongWord(4, AID, OutBuffer);
	WriteBufferLongWord(8, CharID, OutBuffer);
	WriteBufferWord(12, Length(Command), OutBuffer);
	WriteBufferString(14, Command, Length(Command), OutBuffer);
	SendBuffer(AClient, OutBuffer, TotalLength);
end;{ZoneSendGMCommandtoInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ZoneSendGMCommandResultToInter                                       PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Sends the received gm command to the inter server.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 19th, 2007 - RaX - Created Header;
//		May 1st, 2007 - Tsusai - Added const to the parameters
//------------------------------------------------------------------------------
procedure ZoneSendGMCommandResultToInter(
	const AccountID : LongWord;
	const CharacterID : LongWord;
	const ZoneID : LongWord;
	const Error : TStringList
	);
var
	ReplyBuffer : TBuffer;
	BufferIndex : Integer;
	CSLength    : Integer;
	Index       : Integer;
begin
	WriteBufferWord(0, $2207, ReplyBuffer);
	WriteBufferLongWord(4, AccountID, ReplyBuffer);
	WriteBufferLongWord(8, CharacterID, ReplyBuffer);
	WriteBufferLongWord(12, ZoneID, ReplyBuffer);
	WriteBufferWord(16, Error.Count, ReplyBuffer);
	BufferIndex := 18;
	for Index := 0 to Error.Count - 1 do
	begin
		CSLength := Length(Error[Index]);
		WriteBufferWord(BufferIndex, CSLength, ReplyBuffer);
		Inc(BufferIndex, 2);
		WriteBufferString(
			BufferIndex,
			Error[Index],
			CSLength,
			ReplyBuffer
		);
	Inc(BufferIndex, CSLength);
	end;
	WriteBufferWord(2, BufferIndex + 1, ReplyBuffer);
	SendBuffer(MainProc.ZoneServer.ToInterTCPClient,ReplyBuffer,BufferIndex + 1);
end;{ZoneSendGMCommandResultToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ZoneSendMapWarpRequestToInter                                        PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Send a warp request
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/08/13] Aeomin - Creaed.
//------------------------------------------------------------------------------
procedure ZoneSendMapWarpRequestToInter(
	AClient : TInterClient;
	const CharID, ZoneID : LongWord;
	const MapName: String;
	const APoint:TPoint
	);
var
	OutBuffer   : TBuffer;
	Size        : Byte;
begin
	Size := Length(MapName);
	WriteBufferWord(0, $2213, OutBuffer);
	WriteBufferWord(2, Size + 17, OutBuffer);
	WriteBufferLongWord(4, CharID, OutBuffer);
	WriteBufferLongWord(8, ZoneID, OutBuffer);
	WriteBufferWord(12, APoint.X, OutBuffer);               //X, Y is before map name XD
	WriteBufferWord(14, APoint.Y, OutBuffer);
	WriteBufferByte(16, Size, OutBuffer);
	WriteBufferString(17, MapName, Size, OutBuffer);
	SendBuffer(AClient, OutBuffer, Size + 17);
end;{ZoneSendMapWarpRequestToInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ZoneSendMapWarpResultToInter                                         PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Send warp request result back to inter then used to "convert" to command
//	Packet structure is same as request -.-
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/08/13] Aeomin - Creaed.
//------------------------------------------------------------------------------
procedure ZoneSendMapWarpResultToInter(
	AClient : TInterClient;
	const CharID, ZoneID : LongWord;
	const MapName: String;
	const APoint:TPoint
	);
var
	OutBuffer   : TBuffer;
	Size        : Byte;
begin
	Size := Length(MapName);
	WriteBufferWord(0, $2214, OutBuffer);
	WriteBufferWord(2, Size + 17, OutBuffer);
	WriteBufferLongWord(4, CharID, OutBuffer);
	WriteBufferLongWord(8, ZoneID, OutBuffer);
	WriteBufferWord(12, APoint.X, OutBuffer);
	WriteBufferWord(14, APoint.Y, OutBuffer);
	WriteBufferByte(16, Size, OutBuffer);
	WriteBufferString(17, MapName, Size, OutBuffer);
	SendBuffer(AClient, OutBuffer, Size + 17);
end;{ZoneSendMapWarpResultToInter}
//------------------------------------------------------------------------------

end{ZoneInterCommunication}.
