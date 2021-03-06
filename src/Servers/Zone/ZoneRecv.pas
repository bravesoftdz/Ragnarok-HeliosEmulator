//------------------------------------------------------------------------------
//ZoneRecv                                                                 UNIT
//------------------------------------------------------------------------------
//  What it does -
//      Receives packets sent by users on the zone server, does whatever they
//    tell us to do =) Contains all routines related to doing as such.
//
//  Changes -
//	[2007/01/18] RaX - Created Header;
//	[2007/03/28] CR - Cleaned up uses clauses, using Icarus as a guide.
//	[2007/10/25] Aeomin - major clean up #1
//
//------------------------------------------------------------------------------
unit ZoneRecv;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}


interface


uses
	{RTL/VCL}
	//none
	{Project}
	GameObject,
	Character,
	PacketTypes,
	{Third Party}
	IdContext
	;


	//----------------------------------------------------------------------
	//NoCommand                                                    PROCEDURE
	//----------------------------------------------------------------------
	Procedure NoCommand(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	); overload;
	procedure NoCommand(
		var
			AChara : TCharacter;
		const
			AvoidSelf:boolean = False
	); overload;
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// General (Procedure required game to run, or anything is not belong to detail category)
	//----------------------------------------------------------------------
	procedure GetNameAndID(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure MapConnect(
		const Version : Integer;
		var AClient : TIdContext;
		const Buffer  : TBuffer;
		const ReadPts : TReadPts
		);

	Procedure ShowMap(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RecvTick(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// Player's Input (Chat, command etc)
	//----------------------------------------------------------------------
	procedure AreaChat(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure GMBroadcast(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure GMMapMove(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure GMShiftChar(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure GMRecall(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure SlashWho(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure Whisper(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);
	//----------------------------------------------------------------------


	//----------------------------------------------------------------------
	// Player's Action (What player wanted to do..)
	//----------------------------------------------------------------------
	procedure CharaRotation(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ActionRequest(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure CancelAttack(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure CharacterWalkRequest(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure NPCClick(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure NPCMenu(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure NPCNext(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure NPCIntegerInput(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure NPCStringInput(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure QuitGame(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ReturnToCharacterSelect(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure StatUP(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RequestToAddFriend(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RemoveFriendFromList(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RequestToAddFriendResponse(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure MailWindowSwitch(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RequestMailRefresh(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ReadMail(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure DeleteMail(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure RequestSendMail(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure DropItem(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure TakeItem(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);
	
	procedure ItemEquip(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ItemUnequip(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ItemUse(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure SaveHotKey(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure EmotionCheck(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure CreateChatroom(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ChatRoomExit(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure JoinChatroom(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure ChatroomOwnerChange(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure KickFromChatroom(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);

	procedure UpdateChatroom(
		var AChara  : TCharacter;
		const InBuffer : TBuffer;
		const ReadPts : TReadPts
	);
	//----------------------------------------------------------------------

	//----------------------------------------------------------------------
	// Packets receive from inter server ( NOT PLAYER )
	//----------------------------------------------------------------------
	procedure RecvGMCommandFromInter(
		const InBuffer : TBuffer
	);

	procedure RecvGMCommandResultFromInter(
		const InBuffer : TBuffer
	);

	procedure RecvRedirectWhisper(
		InBuffer : TBuffer
	);

	procedure RecvWarpRequestReplyFromInter(
		const InBuffer : TBuffer
	);

	procedure RecvWhisperReply(
		InBuffer : TBuffer
	);

	procedure RecvAddFriendRequest(
		InBuffer : TBuffer
	);

	procedure RecvAddFriendRequestReply(
		InBuffer : TBuffer
	);

	procedure RecvFriendOnlineStatus(
		InBuffer : TBuffer
	);
	procedure RecvFriendStatus(
		InBuffer : TBuffer
	);
	procedure RecvMailNotify(
		InBuffer : TBuffer
	);
	procedure RecvCreateInstanceResult(
		InBuffer : TBuffer
	);
	procedure RecvCreateInstance(
		InBuffer : TBuffer
	);
	//----------------------------------------------------------------------

implementation


uses
	{RTL/VCL}
	Math,
	WinLinux,
	Classes,
	SysUtils,
	Types,
	SyncObjs,
	{Project}
	Account,
	Being,
	BufferIO,
	GameConstants,
	Globals,
	GMCommands,
	LuaNPCCore,
	Main,
	Map,
	MapTypes,
	MovementEvent,
	NPC,
	TCPServerRoutines,
	ZoneSend,
	ZoneCharaCommunication,
	ZoneInterCommunication,
	AddFriendEvent,
	AreaLoopEvents,
	Mailbox,
	InstanceMap,
	ParameterList,
	ChatRoom
	{3rd Party}
	//none
	;


//------------------------------------------------------------------------------
//NoCommand                                                            PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This is a dummy command for processes that either don't do anything or
//    don't do anything yet.
//
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure NoCommand(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	//Dummy Command for processes that don't have one.
end;{NoCommand}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NoCommand                                                            PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This is a dummy command for processes that either don't do anything or
//    don't do anything yet.
//
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure NoCommand(
	var
		AChara    : TCharacter;
	const
		AvoidSelf : Boolean = False
);
begin
	//Dummy Command for processes that don't have one.
end;{NoCommand}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetNameAndID                                                         PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This gets a character's name and id from the charalist if it's there,
//    else, it looks through mobs and npcs.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//	[2008/06/08] Aeomin - Updated packet structure
//------------------------------------------------------------------------------
procedure GetNameAndID(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	ID : LongWord;
	idxX,idxY:Integer;
	ObjectIdx : Integer;
	AObject : TGameObject;
begin
	ID := BufferReadLongWord(ReadPts[0], InBuffer);
	if AChara.AccountID = ID then
	begin
		ZoneSendObjectNameAndIDBasic(
			AChara,
			AChara.AccountID,
			AChara.Name
		);
	end else
	begin
		for idxY := Max(0,AChara.Position.Y-MainProc.ZoneServer.Options.CharShowArea) to Min(AChara.Position.Y+MainProc.ZoneServer.Options.CharShowArea, AChara.MapInfo.Size.Y-1) do
		begin
			for idxX := Max(0,AChara.Position.X-MainProc.ZoneServer.Options.CharShowArea) to Min(AChara.Position.X+MainProc.ZoneServer.Options.CharShowArea, AChara.MapInfo.Size.X-1) do
			begin
				for ObjectIdx := AChara.MapInfo.Cell[idxX][idxY].Beings.Count -1 downto 0 do
				begin
					if AChara.MapInfo.Cell[idxX][idxY].Beings.Objects[ObjectIdx] is TBeing then
					begin
						AObject := AChara.MapInfo.Cell[idxX][idxY].Beings.Objects[ObjectIdx] as TGameObject;
						if AObject = AChara then
							Continue;
						if AObject.ID = ID then
						begin
							ZoneSendObjectNameAndIDBasic(
								AChara,
								AObject.ID,
								AObject.Name
							);
							Break;
						end;
					end;
				end;
			end;
		end;
	end;
end;{GetNameAndID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//MapConnect                                                           PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This is executed when a character requests to conenct ot the map server.
//    It first checks to see if a character should be able to connect to the
//    zone (to stop hacking attempts) and then it links the chosen character to
//    the connection.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//    April 10th, 2007 - Aeomin - Added SendZoneCharaLogon.
//    April 12th, 2007 - Aeomin - Append check to disallow 0 of LoginKey
//    May 25th, 2007 - Tsusai - Removed Mapload. Wrong spot for it.  Added
//		the zone increase here.
//------------------------------------------------------------------------------
procedure MapConnect(
	const Version : Integer;
	var AClient : TIdContext;
	const Buffer  : TBuffer;
	const ReadPts : TReadPts
);
var
	AccountID   : LongWord;
	CharacterID : LongWord;
	ValidateID1 : LongWord;
	//ClientTick  : LongWord;
	Gender      : Byte;
	AnAccount   : TAccount;
	ACharacter  : TCharacter;

//	Key1,Key2   : LongWord;
begin
	AccountID      	:= BufferReadLongWord(ReadPts[0], Buffer);
	CharacterID    	:= BufferReadLongWord(ReadPts[1], Buffer);
	ValidateID1    	:= BufferReadLongWord(ReadPts[2], Buffer);
	{ClientTick     := }BufferReadLongWord(ReadPts[3], Buffer);
	Gender         	:= BufferReadByte    (ReadPts[4], Buffer);

	AnAccount				:=  TAccount.Create(AClient);
	AnAccount.ID		:= AccountID;
	TThreadLink(AClient.Data).DatabaseLink.Account.Load(AnAccount);

	ACharacter := TCharacter.Create(AClient);
	ACharacter.ID := CharacterID;
	TThreadLink(AClient.Data).DatabaseLink.Character.Load(ACharacter);

	TClientLink(AClient.Data).AccountLink := AnAccount;
	TClientLink(AClient.Data).CharacterLink := ACharacter;

	if (AnAccount.LoginKey[1] = ValidateID1) and
		 (AnAccount.LoginKey[1] > 0) and
		 (AnAccount.GenderNum = Gender) then
	begin
		// Duplicate session safe check!
		if MainProc.ZoneServer.CharacterList.IndexOf(ACharacter.ID) > -1 then
		begin
			ACharacter.Free;
			//Disconnect frees the account
			ACharacter.ClientInfo.Connection.Disconnect;
		end else
		begin

			ACharacter.ClientVersion := Version;
			ACharacter.EAPACKETVER := PacketDB.GetEAPacketVer(Version);
			ACharacter.Online  := 1;
			MainProc.ZoneServer.CharacterList.Add(ACharacter);

			SendZoneCharaLogon(MainProc.ZoneServer.ToCharaTCPClient, ACharacter);

//			SendPadding(ACharacter.ClientInfo);
			SendCharID(ACharacter);

			{Key1:=Random($FFFFFF)+10;
			Key2:=Random($FFFFFF)+10;
			SendEncryptKeys(AClient,Key1,Key2);
			TClientLink(AClient.Data).InitializeMessageID(Key1,Key2);}

			ZoneSendMapConnectReply(ACharacter);
			SendZoneCharaIncrease(MainProc.ZoneServer.ToCharaTCPClient,MainProc.ZoneServer);

			//Friendslist (No longer placeholder XD)
			ACharacter.SendFriendList;

			ZoneSendPlayerOnlineStatus(
				MainProc.ZoneServer.ToInterTCPClient,
				ACharacter.AccountID,
				ACharacter.ID,
				0 //0 = online; 1=offline
			);

			ACharacter.CalculateCharacterStats;

			//Load Inventory
			ACharacter.LoadInventory;
		end;
	end else
	begin
		//disconnect frees the account.
		ACharacter.Free;
		ZoneSendMapConnectDeny(AClient);
	end;
end;{MapConnect}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ShowMap                                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This is executed on a character showing the map, it sends them all the
//    information they need, such as their skill list, stats, friends list,
//    guild, etc. Anything that would be used by the character.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//    March 30th, 2007 - Aeomin - Move SendZoneCharaIncrease to here.
//    May 25th, 2007 - Tsusai - Moved MapLoad here, removed Zone increase.
//	  May 28th, 2007 - Tsusai - Removed MapPointer.
//------------------------------------------------------------------------------
procedure ShowMap(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	OutBuffer   : TBuffer;
	AMap        : TMap;
	MapIndex    : Integer;
	Loaded      : Boolean;
	function LoadMap:Boolean;
	begin
		Result := False;
		//Load map cells if they are not already loaded
		MapIndex := MainProc.ZoneServer.MapList.IndexOf(AChara.Map);
		if MapIndex > -1 then
		begin
			if MainProc.ZoneServer.MapList[MapIndex].State = UNLOADED then
			begin
				MainProc.ZoneServer.MapList[MapIndex].SafeLoad;

				AMap := MainProc.ZoneServer.MapList[MapIndex];
				AChara.MapInfo := AMap;
			end else
			begin
				AMap := MainProc.ZoneServer.MapList[MapIndex];
				AChara.MapInfo := AMap;
			end;
			Result := True;
		end;
	end;
	function LoadInstanceMap:Boolean;
	begin
		MapIndex := MainProc.ZoneServer.MapList.IndexOf(AChara.Map);
		Result := MapIndex > -1;
		if Result then
		begin
			AChara.MapInfo := MainProc.ZoneServer.MapList.Items[MapIndex];
		end;
	end;
begin
	AChara.EventList.Clear;

	//Check Instance map special character
	if (Pos('#',AChara.Map)>0) then
	begin
		//Load Instance map first, if fail then normal
		Loaded := LoadInstanceMap OR LoadMap;
	end else
	begin
		Loaded := LoadMap;
	end;

	if Loaded then
	begin
		AChara.OnTouchIDs.Clear;

		//Update character options
		//Clear all vending/trading/etc id storages.
		//Clear some possible events from the event list.


		if (AChara.HP = 0) then
		begin
			if ((AChara.JID = JOB_NOVICE) or
				(AChara.JID = HJOB_HIGH_NOVICE) or
				(AChara.JID = HJOB_BABY) {OR
			 AChara can fully recover (Osiris card?) }) then
			begin
				AChara.CalcMaxHP;
				AChara.HP := AChara.MaxHP;
				AChara.SP := AChara.MaxSP;
			end else begin
				AChara.HP := 1;
				AChara.SP := 1;
			end;
		end;

		//skilllist placeholder
		WriteBufferWord(0, $010F, OutBuffer);
		WriteBufferWord(2, 4, OutBuffer);
		SendBuffer(AChara.ClientInfo, OutBuffer, 4);

		//Arrow Placeholder
		WriteBufferWord(0, $013c, OutBuffer);
		WriteBufferWord(2, 0, OutBuffer);
		SendBuffer(AChara.ClientInfo, OutBuffer, PacketDB.GetLength($013c,AChara.ClientVersion));

		AChara.BeingState := BeingStanding;

		//Weather updates
		//Various other tweaks
		AChara.AddToMap;
		AChara.ZoneStatus := isOnline;

		//Teleport the person in
		AChara.ShowTeleportIn;
		AChara.AreaLoop(ShowInitialAction);
		//Calculate the rest of the stats
		AChara.SendCharacterStats;

		//Inventory
		SendInventory(
			AChara.ClientInfo,
			AChara.Inventory
		);

		AChara.GenerateWeight;

		if (AChara.Position.X = High(Word)) or
			(AChara.Position.Y = High(Word)) then
		begin
			AChara.Position := AChara.MapInfo.RandomCell;
			ZoneSendWarp(AChara,AChara.Map,AChara.Position.X,AChara.Position.Y);
		end;

	end else
	begin
		AChara.ClientInfo.Connection.Disconnect;
	end;
end;{ShowMap}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvTick                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This sends a simple ping command basically to the client on receiving a
//    "tick" from them. It ensures that the client is still connected to the
//    game server.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    January 18th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure RecvTick(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	ZoneSendTickToClient(AChara);
end;{RecvTick}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//AreaChat                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive and Send local speech
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 18th, 2007 - Aeomin - Created Header
//	[2007/08/09] Aeomin - change + 3 to + 4, otherwise theres extra space
//------------------------------------------------------------------------------
procedure AreaChat(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	ChatLength     : Word;
	Chat           : String;
	TempChat       : String;
	CommandID      : Word;
begin
	ChatLength	:= BufferReadWord(ReadPts[0], InBuffer)-4;
	Chat		:= BufferReadString(ReadPts[1], ChatLength, InBuffer);

	//First, we remove the character's name and the colon after it from the
	//chat string.
	TempChat := Copy(Chat, Length(AChara.Name) + 4, Length(Chat));
	//We then check if it is a command.
	if MainProc.ZoneServer.Commands.IsCommand(TempChat) then
	begin
		CommandID := MainProc.ZoneServer.Commands.GetCommandID(
									MainProc.ZoneServer.Commands.GetCommandName(TempChat)
								 );
		//if it is a command, we check the account's access level to see if it is
		//able to use the gm command.
		if TClientLink(AChara.ClientInfo.Data).AccountLink.Level >= MainProc.ZoneServer.Commands.GetCommandGMLevel(CommandID) then
		begin
			ZoneSendGMCommandtoInter(MainProc.ZoneServer.ToInterTCPClient, AChara.AccountID, AChara.ID, TempChat);
		end else
		begin
			SendAreaChat(Chat, ChatLength, AChara);
		end;
	end else
	begin
		SendAreaChat(Chat, ChatLength, AChara);
	end;
end;{AreaChat}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GMBroadcast                                                          PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Convert /b , /nb command (apparently, /bb works too)
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/08/09] Aeomin - Created.
//------------------------------------------------------------------------------
procedure GMBroadcast(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Size     : Word;
	Announce : String;
	CommandID: Integer;
	RequiredGMLevel : Byte;
begin
	CommandID := MainProc.ZoneServer.Commands.GetCommandID('BroadCastN');
	RequiredGMLevel := MainProc.ZoneServer.Commands.GetCommandGMLevel(CommandID);
	if TClientLink(AChara.ClientInfo.Data).AccountLink.Level >= RequiredGMLevel then
	begin
		Size     := BufferReadWord(2, InBuffer);
		Announce := BufferReadString(4, Size - 4, InBuffer);
		//Convert XD
		ZoneSendGMCommandtoInter(MainProc.ZoneServer.ToInterTCPClient, AChara.AccountID, AChara.ID, '#BroadCastN ' + Announce);
	end;
end;{GMBroadcast}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GMMapMove                                                            PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Convert /mm /mapmove command
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/08/12] Aeomin - Created.
//------------------------------------------------------------------------------
procedure GMMapMove(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	MapName : String;
	X       : Word;
	Y       : Word;
	CommandID: Integer;
	RequiredGMLevel : Byte;
begin
	CommandID := MainProc.ZoneServer.Commands.GetCommandID('Warp');
	RequiredGMLevel := MainProc.ZoneServer.Commands.GetCommandGMLevel(CommandID);
	if TClientLink(AChara.ClientInfo.Data).AccountLink.Level >= RequiredGMLevel then
	begin
		//get the request
		MapName := BufferReadString(ReadPts[0], ReadPts[1] - ReadPts[0], InBuffer);
		X       := BufferReadWord(ReadPts[1], InBuffer);
		Y       := BufferReadWord(ReadPts[2], InBuffer);
		ZoneSendGMCommandtoInter(MainProc.ZoneServer.ToInterTCPClient, AChara.AccountID, AChara.ID, '#Warp "' + MapName +'",' + IntToStr(X) + ',' + IntToStr(Y));
	end;
end;{GMMapMove}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GMShiftChar                                                          PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Alias of #Goto
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2008/08/11] Aeomin - Created.
//------------------------------------------------------------------------------
procedure GMShiftChar(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GMRecall                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Alias of #Recall
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2008/08/11] Aeomin - Created.
//------------------------------------------------------------------------------
procedure GMRecall(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	CharName : String;
	CommandID: Integer;
	RequiredGMLevel : Byte;
begin
	CommandID := MainProc.ZoneServer.Commands.GetCommandID('CharMove');
	RequiredGMLevel := MainProc.ZoneServer.Commands.GetCommandGMLevel(CommandID);
	if TClientLink(AChara.ClientInfo.Data).AccountLink.Level >= RequiredGMLevel then
	begin
		//Get the request
		CharName := BufferReadString(ReadPts[0], NAME_LENGTH, InBuffer);
		ZoneSendGMCommandtoInter(
			MainProc.ZoneServer.ToInterTCPClient,
			AChara.AccountID,
			AChara.ID,
			'#CharMove "' + CharName + '",' + AChara.Map + ',' + IntToStr(AChara.Position.X) + ',' + IntToStr(AChara.Position.Y)
		);
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SlashWho                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Check how many player(s) were online.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    April 5th, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure SlashWho(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	ZoneSendConnectionsCount(AChara.ClientInfo);
end;{SlashWho}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Whisper                                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive Whisper request from client.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure Whisper(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Len : Word;
	TargetName : String;
	Msg : String;
begin
	Len := BufferReadWord(ReadPts[0], InBuffer);
	TargetName := BufferReadString(ReadPts[1], 24, InBuffer);
	Msg := BufferReadString(ReadPts[2], Len - 28, InBuffer);
	SendWhisperToInter(MainProc.ZoneServer.ToInterTCPClient, AChara, TargetName, Msg);
end;{Whisper}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//CharaRotation                                                        PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Rotate Character, check,  set and send to other characters.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 20th, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure CharaRotation(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	AChara.HeadDirection := BufferReadWord(ReadPts[0], InBuffer);
	AChara.Direction     := BufferReadByte(ReadPts[1], InBuffer);
	AChara.UpdateDirection;
end;{CharaRotation}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ActionRequest                                                       PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      This sends a client an action command, actions can be anything from
//			sitting to critical hits. SEE GAMECONSTANTS.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    December 24th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure ActionRequest(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	ActionType	: Byte;
	TargetID		: LongWord;
begin
	TargetID := BufferReadLongWord(ReadPts[0], InBuffer);
	ActionType := BufferReadByte(ReadPts[1], InBuffer);
	case ActionType of

		ACTION_ATTACK ://Hit target one time
			begin
				AChara.EventList.DeleteAttackEvents;
				AChara.EventList.DeleteMovementEvents;
				if NOT (AChara.BeingState = BeingAttacking) then
				begin
					AChara.BeingState := BeingAttacking;
				end;
				AChara.Attack(TargetID, FALSE, FALSE);
			end;

		ACTION_SIT://Sit
			begin
				//TODO -- basic skill checks here
				AChara.BeingState := BeingSitting;
			end;

		ACTION_STAND://Stand
			begin
				AChara.BeingState := BeingStanding;
			end;

		ACTION_CONTINUE_ATTACK : //Hit target continuously
			begin
				AChara.EventList.DeleteAttackEvents;
				AChara.EventList.DeleteMovementEvents;
				if NOT (AChara.BeingState = BeingAttacking) then
				begin
					AChara.BeingState := BeingAttacking;
				end;
				AChara.Attack(TargetID, TRUE, FALSE);
			end;
	end;
end;{ActionRequest}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//CancelAttack                                                      PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      ?
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    December 24th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure CancelAttack(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	AChara.EventList.DeleteAttackEvents;
end;{CancelAttack}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//CharaWalkRequest                                                    PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Processes a Character's request to walk to a certain point.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    February 27th, 2007 - RaX - Created Header;
//    May 28th, 2007 - Tsusai - Changed Rebruary to February, and added conditionals
//     for walking
//------------------------------------------------------------------------------
procedure CharacterWalkRequest(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	MoveEvent : TMovementEvent;
	DestPoint : TPoint;
	spd       : LongWord;
begin
	DestPoint := BufferReadOnePoint(ReadPts[0], InBuffer);
	if (AChara.ScriptStatus = SCRIPT_NOTRUNNING) and
	(AChara.BeingState in [BeingStanding,BeingAttacking,BeingWalking]) then
	begin
		if AChara.GetPath(AChara.Position, DestPoint, AChara.Path) then
		begin
			with AChara do
			begin

				//Remove previous attack events from the event list
				EventList.DeleteAttackEvents;

				//Remove previous movement events from the event list
				EventList.DeleteMovementEvents;

				BeingState := BeingStanding;
				PathIndex := 0;

				//Setup first speed
				//Check to see if we're moving diagonally, if we are, we adjust the speed
				//accordingly.
				if (Direction in Diagonals) then
				begin
					spd := Speed * 3 DIV 2;
				end else begin
					spd := Speed;
				end;

				MoveTick := GetTick + spd DIV 2;

				MoveEvent := TMovementEvent.Create(MoveTick,AChara);
				EventList.Add(MoveEvent);

				ZoneSendWalkReply(AChara,DestPoint);
				ShowBeingWalking;
			end;
		end;
	end;
end;{CharaWalkRequest}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NPCClick                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Runs a NPC script when someone clicks it (if conditions are ok)
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    [2007/05/27] Tsusai - Created
//------------------------------------------------------------------------------
procedure NPCClick(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	NPCID : LongWord;
	ANPC : TNPC;
	Index : Integer;
begin
	if (AChara.ScriptStatus = SCRIPT_NOTRUNNING) and
		(AChara.BeingState = BeingStanding) then
	begin
		NPCID := BufferReadLongWord(ReadPts[0], InBuffer);

		Index := AChara.MapInfo.NPCList.IndexOf(NPCID);
		if Index > -1 then
		begin
			ANPC := AChara.MapInfo.NPCList.Objects [Index] as TNPC;
			if ANPC is TScriptNPC then
			begin
				//Map is guaranteed
				if (AChara.InPointRange(ANPC.Position)) then
				begin
					AChara.ScriptBeing := ANPC;
					TScriptNPC(ANPC).OnClick(AChara);
				end;
			end;
		end;
	end;
end;{NPCClick}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NPCMenu                                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Resumes a npc script with a menu selection
//      First menu choice returns a 1, 2nd returns 2, etc.  $ff = cancel
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    June 03rd, 2007 - Tsusai - Created
//------------------------------------------------------------------------------
procedure NPCMenu(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	NPCID : LongWord;
	Choice : Byte;
begin
	NPCID := BufferReadLongWord(ReadPts[0], InBuffer);
	Choice := BufferReadByte(ReadPts[1], InBuffer);
	if (AChara.ScriptBeing.ID = NPCID) and
		(AChara.ScriptStatus = SCRIPT_YIELD_MENU) then
	begin
		if Choice <> $FF then
		begin
			AChara.ScriptStatus := SCRIPT_RUNNING;
			ResumeLuaNPCScriptWithInteger(AChara,Choice);
		end else
		begin
			AChara.ScriptStatus := SCRIPT_NOTRUNNING;
		end;
	end;
end;{NPCMenu}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NPCNext                                                              PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Resumes a npc script
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 25th, 2007 - Tsusai - Created
//------------------------------------------------------------------------------
procedure NPCNext(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	NPCID : LongWord;
begin
	NPCID := BufferReadLongWord(ReadPts[0], InBuffer);
	if (AChara.ScriptBeing.ID = NPCID) and
		(AChara.ScriptStatus = SCRIPT_YIELD_WAIT) then
	begin
		AChara.ScriptStatus := SCRIPT_RUNNING;
		ResumeLuaNPCScript(AChara);
	end;
end;{NPCNext}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NPCIntegerInput                                                      PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Receive an int input from player
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//	Changes -
//		[2008/10/11] Aeomin - Created
//------------------------------------------------------------------------------
procedure NPCIntegerInput(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	NPCID : LongWord;
	Number : LongWord;
begin
	NPCID := BufferReadLongWord(ReadPts[0], InBuffer);
	Number := BufferReadLongWord(ReadPts[1], InBuffer);
	if (AChara.ScriptBeing.ID = NPCID) and
		(AChara.ScriptStatus = SCRIPT_YIELD_INPUT) then
	begin
		AChara.ScriptStatus := SCRIPT_RUNNING;
		ResumeLuaNPCScriptWithInteger(AChara,Number);
	end;
end;{NPCIntegerInput}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//NPCStringInput                                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Receive a str input from player
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//	Changes -
//		[2008/10/11] Aeomin - Created
//------------------------------------------------------------------------------
procedure NPCStringInput(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Size : Word;
	NPCID : LongWord;
	Value : String;
begin
	Size := BufferReadWord(ReadPts[0], InBuffer);
	NPCID := BufferReadLongWord(ReadPts[1], InBuffer);
	Value := BufferReadString(ReadPts[2],Size-6, InBuffer);
	if (AChara.ScriptBeing.ID = NPCID) and
		(AChara.ScriptStatus = SCRIPT_YIELD_INPUT) then
	begin
		AChara.ScriptStatus := SCRIPT_RUNNING;
		ResumeLuaNPCScriptWithString(AChara,Value);
	end;
end;{NPCIntegerInput}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//QuitGame                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Fired when a player clicks Exit to windows button ingame.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 17th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure QuitGame(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	//send client response.
	SendQuitGameResponse(AChara);
end;{QuitGame}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ReturnToCharacterSelect                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Fired when a player clicks the return to chara select button.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 17th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure ReturnToCharacterSelect(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	ActionByte : Byte;
	OutBuffer  : TBuffer;

begin
	FillChar(OutBuffer,3,0);
	ActionByte := BufferReadByte(ReadPts[0], InBuffer);
	case ActionByte of
	0:
		begin
			if AChara.BeingState = BeingDead then
			begin
				//Send Leave with '0' as byte modifier
				//Only runs when dead.
				//Return to save point, and load map
				AChara.BeingState := BeingStanding;
				ZoneSendWarp(
					AChara,
					AChara.SaveMap,
					AChara.SavePoint.X,
					AChara.SavePoint.Y
				);
			end;
		end;
	1:
		begin
			if not false {in combat} then
			begin
				//Send Leave 2
				SendCharacterSelectResponse(AChara);
			end;
		end;
	end;
end;{ReturnToCharacterSelect}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//StatUP                                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive stat up request from client.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/08/20] - Aeomin - Created
//------------------------------------------------------------------------------
procedure StatUP(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	StatType  : Word;
	LocalType : Byte;
	Amount    : Byte;
	Index     : Integer;
	OldAmount : Integer;
	Def       : Byte;
begin
	StatType   := BufferReadWord(ReadPts[0], InBuffer);
	Amount     := BufferReadByte(ReadPts[1], InBuffer);
	if Amount > 0 then
	begin
		//Gravity loves to play, so lets play then
		if (StatType >= $000d) and (StatType <= $0012) then
		begin
			LocalType := StatType - $000d;
		end else
		begin
			LocalType := 0;
		end;
		OldAmount := AChara.ParamBase[LocalType];
		//Loop, 1 stat a time
		for Index := 1 to Amount do
		begin
			if AChara.ParamUp[LocalType] <= AChara.StatusPts then
			begin
				if OldAmount < CHAR_STAT_MAX then
				begin
					if AChara.ParamBase[LocalType] < MainProc.ZoneServer.Options.MaxCharacterStats then
					begin
						AChara.StatusPts := AChara.StatusPts - AChara.ParamUp[LocalType];
						AChara.ParamBase[LocalType] := AChara.ParamBase[LocalType] + 1;
					end else
					begin
						Break;
					end;
				end else
				begin
					//Too much already!
					Break;
				end;
			end else
			begin
				//Not enough status point
				Break;
			end;
		end;

		//How many stats added?
		Def := AChara.ParamBase[LocalType] - OldAmount;
		AChara.SendCharacterStats;
		
		if Def = 0 then
		begin
			//Nothing has changed, assume failed
			SendStatUPResult(AChara, True, Def);
		end else
		begin
			SendStatUPResult(AChara, False, Def);
		end;
	end;
end;{StatUp}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RequestToAddFriend                                                   PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Request add friend.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    [2007/12/7] Aeomin - Created.
//------------------------------------------------------------------------------
procedure RequestToAddFriend(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	TargetName : String;  //The character name want to add to friend list
	TargetChara : TCharacter;
	ZoneID      : Integer;
	AFriendRequestEvent : TFriendRequestEvent;
	AlreadyFriend : Boolean;
begin
	TargetName := BufferReadString(ReadPts[0], NAME_LENGTH, InBuffer);
	with TThreadLink(AChara.ClientInfo.Data).DatabaseLink.Character do
	begin
		TargetChara := TCharacter.Create(AChara.ClientInfo);
		TargetChara.Name := TargetName;
		Load(TargetChara);
		AlreadyFriend :=
			TThreadLink(AChara.ClientInfo.Data).DatabaseLink.Friend.IsFriend(
				AChara.ID,
				TargetChara.ID
			);
	end;
	if not AlreadyFriend then
	begin
		with TThreadLink(AChara.ClientInfo.Data).DatabaseLink.Map do
		begin
			ZoneID := GetZoneID(TargetChara.Map);
		end;

		if ZoneID > -1 then
		begin
			if AChara.Friends >= MAX_FRIENDS then
			begin
				// Too much friends
				SendAddFriendRequestReply(
						AChara.ClientInfo,
						TargetChara.AccountID,
						TargetChara.ID,
						TargetChara.Name,
						2
				);

			end else
			begin
				AFriendRequestEvent := TFriendRequestEvent.Create(GetTick + 10000, AChara);
				AFriendRequestEvent.PendingFriend := TargetChara.ID;
				AChara.EventList.Add(AFriendRequestEvent);
				// Just let inter server handle it ^_^
				ZoneSendAddFriendRequest(
						MainProc.ZoneServer.ToInterTCPClient,
						AChara.AccountID,
						AChara.ID,
						AChara.Name,
						TargetChara.ID,
						ZoneID
				);
			end;
		end;
		TargetChara.Free;
	end;
end;{RequestToAddFriend}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RemoveFriendFromList                                                 PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Delete a friend from friend list.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    [2007/12/5] Aeomin - Created.
//------------------------------------------------------------------------------
procedure RemoveFriendFromList(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	AccountID  : LongWord;
	CharID     : LongWord;
begin
	AccountID   := BufferReadLongWord(ReadPts[0], InBuffer);
	CharID      := BufferReadLongWord(ReadPts[1], InBuffer);

	TThreadLink(AChara.ClientInfo.Data).DatabaseLink.Friend.Delete(AChara.ID, CharID);
	SendDeleteFriend(AChara.ClientInfo, AccountID, CharID);
	Dec(AChara.Friends);
end;{RemoveFriendFromList}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RequestToAddFriendResponse                                           PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive player's reply of add firend request
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    [2007/12/07] Aeomin - Created.
//------------------------------------------------------------------------------
procedure RequestToAddFriendResponse(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	AccID  : LongWord;
	CharID : LongWord;
	Reply  : Byte;
begin
	AccID   := BufferReadLongWord(ReadPts[0], InBuffer);
	CharID  := BufferReadLongWord(ReadPts[1], InBuffer);
	Reply   := BufferReadByte(ReadPts[2], InBuffer);

	// Nop... no way...
	if (AChara.AccountID <> AccID) and (AChara.ID <> CharID) then
	begin
		if Reply = 0 then
		begin
			// Denied, just forward..
			ZoneSendAddFriendReply(
				MainProc.ZoneServer.ToInterTCPClient,
				CharID,
				AChara.AccountID,
				AChara.ID,
				AChara.Name,
				1
			);
		end else
		begin
			// Accepted, tell request char to add data in database
			ZoneSendAddFriendReply(
				MainProc.ZoneServer.ToInterTCPClient,
				CharID,
				AChara.AccountID,
				AChara.ID,
				AChara.Name,
				0
			);
		end;
	end;
end;{RequestToAddFriendResponse}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//MailWindowSwitch                                                     PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//		Client close mailbox window or switch.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//		[2008/08/10] - Aeomin - Created
//------------------------------------------------------------------------------
procedure MailWindowSwitch(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Flag : Word;
begin
	Flag := BufferReadWord(ReadPts[0], InBuffer);
	if (Flag = 0) OR (Flag = 1) then
	begin
		{TODO:Remove item}
	end;
	if (Flag = 0) OR (Flag = 2) then
	begin
		{TODO:Remove Zeny}
	end;
end;{MailWindowSwitch}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RequestMailRefresh                                                   PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//		Client requests mail inbox refresh
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//		[2008/06/11] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RequestMailRefresh(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
begin
	SendMailList(
		AChara
	);
end;{RequestMailRefresh}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ReadMail                                                             PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//		Client requests to read a mail.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//		[2008/06/12] - Aeomin - Created
//------------------------------------------------------------------------------
procedure ReadMail(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	MailID : LongWord;
	Mail : TMail;
begin
	MailID := BufferReadLongWord(ReadPts[0], InBuffer);
	Mail := AChara.Mails.Get(MailID);
	if Mail <> nil then
	begin
		SendMailContent(
			AChara.ClientInfo,
			Mail
		);
	end;
end;{ReadMail}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//DeleteMail                                                           PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//		Client wants delete mail.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//		[2008/08/09] - Aeomin - Created
//------------------------------------------------------------------------------
procedure DeleteMail(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	MailID : LongWord;
begin
	MailID := BufferReadLongWord(ReadPts[0], InBuffer);
	SendDeleteMailResult(
		AChara,
		MailID,
		AChara.Mails.Delete(MailID)
	);
end;{DeleteMail}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RequestSendMail                                                      PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//		Client wants to send a mail!
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//		[2008/08/10] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RequestSendMail(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Len        : Word;
	Receiver   : String;
	Title      : String;
	ContentLen : Byte;
	Content    : String;


begin
	{TODO:Trading detection}
	{TODO:Mail Tick to prevent spam}
	Len   := BufferReadWord(ReadPts[0], InBuffer);
	Receiver  := BufferReadString(ReadPts[1],24, InBuffer);
	Title := BufferReadString(ReadPts[2],40, InBuffer);
	ContentLen := BufferReadByte(ReadPts[3], InBuffer);
	Content := BufferReadString(ReadPts[3]+1,ContentLen, InBuffer);

	if Len = (ContentLen+70) then
	begin
		{TODO:ITEMS!!!!ZENY!!!!!}
		SendMailResult(
			AChara,
			(not AChara.Mails.Send(
					Receiver, Title, Content
					)
				)
			);
	end;
end;{RequestSendMail}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//DropItem                                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Drop item.
//--
//	Pre:
//		TODO
//	Post:
//		TODO
//--
//  Changes -
//		[2008/09/23] - Aeomin - Created
//------------------------------------------------------------------------------
procedure DropItem(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Index : Word;
	Quantity : Word;
begin
	Index := BufferReadWord(ReadPts[0], InBuffer);
	Quantity := BufferReadWord(ReadPts[1], InBuffer);
	if Index > 0 then
	begin
		AChara.Inventory.Drop(Index-1,Quantity);
	end;
end;{DropItem}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TakeItem                                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Try to pickup an item
//--
//	Pre:
//		TODO
//	Post:
//		TODO
//--
//  Changes -
//		[2008/10/03] - Aeomin - Created
//------------------------------------------------------------------------------
procedure TakeItem(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	ID : LongWord;
	CriticalSection : TCriticalSection;
begin
	CriticalSection := TCriticalSection.Create;
	CriticalSection.Enter;
	try
	if AChara.BeingState in [BeingStanding,BeingWalking,BeingAttacking] then
	begin
		ID := BufferReadLongWord(ReadPts[0], InBuffer);
		AChara.Inventory.Pickup(ID);
	end;
	finally
		CriticalSection.Leave;
		CriticalSection.Free;
	end;

end;{TakeItem}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ItemEquip                                                            PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Equip item
//--
//	Pre:
//		TODO
//	Post:
//		TODO
//--
//  Changes -
//		[2008/10/05] - Aeomin - Created
//------------------------------------------------------------------------------
procedure ItemEquip(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Index:Word;
begin
	if AChara.BeingState in [BeingSitting,BeingStanding,BeingWalking,BeingAttacking] then
	begin
		Index := BufferReadWord(ReadPts[0], InBuffer);
		if Index > 0 then
		begin
			AChara.Inventory.Equip(Index-1);
		end;
	end;
end;{ItemEquip}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ItemUnequip                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Unequip item
//--
//	Pre:
//		TODO
//	Post:
//		TODO
//--
//  Changes -
//		[2008/10/10] - Aeomin - Created
//------------------------------------------------------------------------------
procedure ItemUnequip(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Index:Word;
begin
	if AChara.BeingState in [BeingSitting,BeingStanding,BeingWalking,BeingAttacking] then
	begin
		Index := BufferReadWord(ReadPts[0], InBuffer);
		if Index > 0 then
		begin
			AChara.Inventory.Unequip(Index-1);
		end;
	end;
end;{ItemUnequip}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ItemUse                                                              PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Use an item
//--
//	Pre:
//		TODO
//	Post:
//		TODO
//--
//  Changes -
//		[2008/10/18] - Aeomin - Created
//------------------------------------------------------------------------------
procedure ItemUse(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Index:Word;
begin
	if AChara.BeingState in [BeingSitting,BeingStanding,BeingWalking,BeingAttacking] then
	begin
		Index := BufferReadWord(ReadPts[0], InBuffer);
		if Index > 0 then
		begin
			AChara.Inventory.Use(Index-1);
		end;
	end;
end;{ItemUse}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SaveHotKey                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Redirect whisper message from Inter to client
//	Changes -
//		[2008/12/06] Aeomin - Created
//------------------------------------------------------------------------------
procedure SaveHotKey(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
{var
	Index : Word;
	AType : Byte;
	ID    : LongWord;
	SkillLevel : Word;}
begin
	{Index := BufferReadWord(ReadPts[0], InBuffer);
	AType := BufferReadByte(ReadPts[1], InBuffer);
	ID    := BufferReadLongWord(ReadPts[2], InBuffer);
	SkillLevel := BufferReadWord(ReadPts[3], InBuffer);} {Wonder why is word?}
end;{SaveHotKey}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//EmotionCheck                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Emotion? EMOTION!
//	Changes -
//		[2009/01/17] Aeomin - Created
//------------------------------------------------------------------------------
procedure EmotionCheck(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	EmotionID : Byte;
	Parameters : TParameterList;
begin
	EmotionID := BufferReadByte(ReadPts[0], InBuffer);
	if EmotionID <> 34 then
	begin
		Parameters := TParameterList.Create;
		Parameters.AddAsLongWord(1, EmotionID);
		AChara.AreaLoop(Emotion,False,Parameters);
		Parameters.Free;
	end;
end;{EmotionCheck}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//CreateChatroom                                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Wanna create a chatroom? ya? here we go.. and FAIL ..MUAHAHA
//
//	Changes -
//		[2009/01/17] Aeomin - Created
//------------------------------------------------------------------------------
procedure CreateChatroom(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Len : Word;
	Limit : Word;
	isPublic : Boolean;
	Password : String;
	Title : String;
	ParameterList : TParameterList;
begin
	Len := BufferReadWord(ReadPts[0], InBuffer) - 15;
	Limit := BufferReadWord(ReadPts[1], InBuffer);
	//Hard coded CAP!
	if Limit > 100 then
		Exit;
	isPublic := Boolean(BufferReadByte(ReadPts[2], InBuffer));
	Password := BufferReadString(ReadPts[3],8,InBuffer);
	Title := BufferReadString(ReadPts[4],Len,InBuffer);
	if NOT Assigned(AChara.ChatRoom) then
	begin
		AChara.ChatRoom := TChatRoom.Create(AChara);
		AChara.ChatRoom.isPublic := isPublic;
		AChara.ChatRoom.PassWord := Password;
		AChara.ChatRoom.Title := Title;
		AChara.ChatRoom.Limit := Limit;
		SendCreateChatRoomResult(AChara, False);

		ParameterList := TParameterList.Create;
		ParameterList.AddAsObject(1,AChara.ChatRoom);
		AChara.AreaLoop(ShowChatroom,False,ParameterList);
		ParameterList.Free;
	end else
	begin
		SendCreateChatRoomResult(AChara, True);
	end;
end;{CreateChatroom}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ChatRoomExit                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Exit chatroom
//
//	Changes -
//		[2009/01/18] Aeomin - Created
//------------------------------------------------------------------------------
procedure ChatRoomExit(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Chatroom : TChatroom;
begin
	//No extra data in packet
	if Assigned(AChara.ChatRoom) then
	begin
		Chatroom := AChara.ChatRoom;
		AChara.ChatRoom.Quit(AChara.ID);
		if Chatroom.Characters.Count = 0 then
			Chatroom.Free;
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//JoinChatroom                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Joint a chatroom
//
//	Changes -
//		[2009/01/18] Aeomin - Created
//------------------------------------------------------------------------------
procedure JoinChatroom(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	RoomID : LongWord;
	Password : String;

	Index : Integer;
	Room : TChatRoom;
begin
	RoomID := BufferReadLongWord(ReadPts[0], InBuffer);
	Password := BufferReadString(ReadPts[1],8, InBuffer);

	Index := AChara.MapInfo.ChatroomList.IndexOf(RoomID);
	if Index > -1 then
	begin
		Room := AChara.MapInfo.ChatroomList.Objects[Index] as TChatRoom;
		Room.Join(AChara,Password);
	end else
	begin
		SendJoinChatFailed(
			AChara,
			0
		);
	end;
end;{JoinChatroom}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ChatroomOwnerChange                                                  PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Change ownership.
//
//	Changes -
//		[2009/06/27] Aeomin - Created
//------------------------------------------------------------------------------
procedure ChatroomOwnerChange(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	NewOwnerName : String;
	Index : Integer;
begin
	NewOwnerName := BufferReadString(ReadPts[1], NAME_LENGTH, InBuffer);
	if Assigned(AChara.ChatRoom) then
	begin
		if (AChara = AChara.ChatRoom.Owner) AND (AChara.Name <> NewOwnerName) then
		begin
			Index := AChara.ChatRoom.Characters.IndexOfName(NewOwnerName);
			if Index > -1 then
			begin
				AChara.ChatRoom.Owner := AChara.ChatRoom.Characters[Index];
			end;
		end;
	end;
end;{ChatroomOwnerChange}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//UpdateChatroom                                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Setup chatroom
//
//	Changes -
//		[2009/06/27] Aeomin - Created
//------------------------------------------------------------------------------
procedure UpdateChatroom(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Len : Word;
	Limit : Word;
	isPublic : Boolean;
	Password : String;
	Title : String;
begin
	Len := BufferReadWord(ReadPts[0], InBuffer) - 15;
	Limit := BufferReadWord(ReadPts[1], InBuffer);
	//Hard coded CAP!
	if Limit > 100 then
		Exit;
	isPublic := Boolean(BufferReadByte(ReadPts[2], InBuffer));
	Password := BufferReadString(ReadPts[3],8,InBuffer);
	Title := BufferReadString(ReadPts[4],Len,InBuffer);
	if Assigned(AChara.ChatRoom) AND (AChara = AChara.ChatRoom.Owner) then
	begin
		AChara.ChatRoom.isPublic := isPublic;
		AChara.ChatRoom.PassWord := Password;
		AChara.ChatRoom.Title := Title;
		AChara.ChatRoom.Limit := Limit;
		AChara.ChatRoom.UpdateStatus;
	end;
end;{UpdateChatroom}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//KickFromChatroom                                                     PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Kick the user from chatroom
//
//	Changes -
//		[2009/06/27] Aeomin - Created
//------------------------------------------------------------------------------
procedure KickFromChatroom(
	var AChara  : TCharacter;
	const InBuffer : TBuffer;
	const ReadPts : TReadPts
);
var
	Target : String;
	Index : Integer;
begin
	Target:= BufferReadString(ReadPts[0], NAME_LENGTH, InBuffer);
	if Assigned(AChara.ChatRoom) then
	begin
		if (AChara = AChara.ChatRoom.Owner) AND (AChara.Name <> Target) then
		begin
			Index := AChara.ChatRoom.Characters.IndexOfName(Target);
			if Index > -1 then
			begin
				AChara.ChatRoom.Quit(
					AChara.ChatRoom.Characters[Index].ID,
					True
				);
			end;
		end;
	end;
end;{KickFromChatroom}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvRedirectWhisper                                                  PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Redirect whisper message from Inter to client
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure RecvRedirectWhisper(
	InBuffer : TBuffer
);
var
	Size : Word;
	ZoneID : LongWord;
	FromID : LongWord;
	ToID   : LongWord;
	FromName : String;
	Whisper : String;
	Idx : Integer;
	Chara : TCharacter;
begin
	Size := BufferReadWord(2, InBuffer);
	ZoneID := BufferReadLongWord(4, InBuffer);
	FromID := BufferReadLongWord(8, InBuffer);
	ToID := BufferReadLongWord(12, InBuffer);
	FromName := BufferReadString(16, 24, InBuffer);
	Whisper := BufferReadString(40, Size - 40, InBuffer);
	Idx := MainProc.ZoneServer.CharacterList.IndexOf(ToID);
	if Idx > -1 then
	begin
		Chara := MainProc.ZoneServer.CharacterList.Items[idx] as TCharacter;
		SendWhisper(FromName, Whisper, Chara.ClientInfo);

		if not ((ZoneID = 0) and (FromID = 0)) then
		begin
			SendWhisperReplyToInter(MainProc.ZoneServer.ToInterTCPClient, ZoneID, FromID, WHISPER_SUCCESS);
		end;
		{TODO: Check if ignored}
	end else
	begin
		SendWhisperReplyToInter(MainProc.ZoneServer.ToInterTCPClient, ZoneID, FromID, WHISPER_FAILED);
	end;
end;{RecvRedirectWhisper}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvWarpRequestReplyFromInter                                        PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Gets the warp request reply from the inter server and tells the client
//		to warp.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    April 29th, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure RecvWarpRequestReplyFromInter(
	const InBuffer : TBuffer
);
var
	CharacterID     : LongWord;
	MapName         : String;
	MapNameLength   : Word;
	IP              : LongWord;
	Port            : Word;
	X, Y            : Word;
	ACharacter      : TCharacter;
	OutBuffer       : TBuffer;
	Position        : Integer;
	Index           : Integer;
begin
	CharacterID 	:= BufferReadLongWord(4, InBuffer);
	IP						:= BufferReadLongWord(8, InBuffer);
	Port					:= BufferReadWord(12, InBuffer);
	X							:= BufferReadWord(14, InBuffer);
	Y							:= BufferReadWord(16, InBuffer);
	MapNameLength := BufferReadWord(18, InBuffer);
	MapName				:= BufferReadString(20, MapNameLength, InBuffer);
	Index := MainProc.ZoneServer.CharacterList.IndexOf(CharacterID);
	if Index > -1 then
	begin
		ACharacter		:= MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;

		ACharacter.Map := MapName;
		ACharacter.Position := Point(X,Y);
		Position := Pos('#',MapName);
		if Position >0 then
		begin
			//Remove it! gotta tell lie!
			Delete(MapName,1, Position);
		end;
		WriteBufferWord(0, $0092, OutBuffer);
		WriteBufferString(2, MapName+'.rsw', 16, OutBuffer);
		WriteBufferWord(18, X, OutBuffer);
		WriteBufferWord(20, Y, OutBuffer);
		WriteBufferLongWord(22, IP, OutBuffer);
		WriteBufferWord(26, Port, Outbuffer);
		SendBuffer(ACharacter.ClientInfo, OutBuffer, 28);
	end;
end;{RecvWarpRequestReplyFromInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvWhisperReply                                                     PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Redirect whisper result from Inter to client
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    May 3rd, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure RecvWhisperReply(
	InBuffer : TBuffer
);
var
	CharacterID : LongWord;
	Code : Byte;
	idx : Integer;
	Chara : TCharacter;
begin
	CharacterID := BufferReadLongWord(2, InBuffer);
	Code := BufferReadByte(6, InBuffer);
	Idx := MainProc.ZoneServer.CharacterList.IndexOf(CharacterID);
	if Idx > -1 then
	begin
		Chara := MainProc.ZoneServer.CharacterList.Items[idx] as TCharacter;
		SendWhisperReply(Chara, Code);
	end;
end;{RecvWhisperReply}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvGMCommandFromInter                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Gets the gm command information from the buffer.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 21st, 2007 - RaX - Created.
//	[2007/08/09] Aeomin - "Upgraded" Almost everything..
//------------------------------------------------------------------------------
procedure RecvGMCommandFromInter(
	const InBuffer : TBuffer
);
var
	CommandID	: Word;
	GMID		: LongWord;
	CharacterID	: LongWord;
	ZoneID		: LongWord;
	TargetID	: LongWord;
	ArgCount	: Word;
	Arguments	: array of String;
	ArgumentLen	: Integer;
	Index		: Integer;
	BufferIndex	: Integer;
	Error		: TStringList;
	FromChar	: TCharacter;
	TargetChar	: TCharacter;
	idxY		: SmallInt;
	idxX		: SmallInt;
	Map		: TMap;
begin
	CommandID 	:= BufferReadWord(4,InBuffer);
	GMID		:= BufferReadLongWord(6, InBuffer);
	CharacterID	:= BufferReadLongWord(10, InBuffer);
	ZoneID		:= BufferReadLongWord(14, InBuffer);
	TargetID	:= BufferReadLongWord(22, InBuffer);
	ArgCount	:= BufferReadWord(26, InBuffer);

	BufferIndex := 28;

	//We need extra for store syntax help message
	SetLength(Arguments, ArgCount + 1);
	for Index := 0 to ArgCount - 1 do
	begin
		ArgumentLen := BufferReadWord(BufferIndex, InBuffer);
		inc(BufferIndex, 2);
		Arguments[Index] := BufferReadString(BufferIndex,ArgumentLen,InBuffer);
		Inc(BufferIndex, ArgumentLen);
	end;
	//Since array is 0 based, this would be perfect index
	Arguments[ArgCount] := MainProc.ZoneServer.Commands.GetSyntax(CommandID);
	FromChar := TCharacter.Create(nil);
	FromChar.ID := CharacterID;
	MainProc.ZoneServer.Database.Character.Load(FromChar);

	Error := TStringList.Create;

	try
		case MainProc.ZoneServer.Commands.GetCommandType(CommandID) of
			//Whole zone server, no player involved
			TYPE_BROADCAST:
			begin
				//Server only, no player involved
				MainProc.ZoneServer.Commands.Commands[CommandID](Arguments, FromChar, nil, Error);
			end;

			//The Orignal GM
			TYPE_RETURNBACK:
			begin
				//Recycle
				Index := MainProc.ZoneServer.CharacterList.IndexOf(CharacterID);
				if Index > -1 then
				begin
					TargetChar := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;
					MainProc.ZoneServer.Commands.Commands[CommandID](Arguments, FromChar, TargetChar, Error);
				end;
			end;

			//All players
			TYPE_ALLPLAYERS:
			begin
				for Index := MainProc.ZoneServer.CharacterList.Count -1 downto 0 do
				begin
					TargetChar := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;
					MainProc.ZoneServer.Commands.Commands[CommandID](Arguments, FromChar, TargetChar, Error);
				end;
			end;

			//Specific Character
			TYPE_TARGETCHAR:
			begin
				Index := MainProc.ZoneServer.CharacterList.IndexOf(TargetID);
				if Index > -1 then
				begin
					TargetChar := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;
					MainProc.ZoneServer.Commands.Commands[CommandID](Arguments, FromChar, TargetChar, Error);
				end else
				begin
					Error.Add('Character ' + Arguments[0] + ' not found!');
				end;
			end;

			//All players in Specific map
			TYPE_TARGETMAP:
			begin
				//Arguments[0] should be map name
				Index := MainProc.ZoneServer.MapList.IndexOf(Arguments[0]);
				if Index > -1 then
				begin
					Map := MainProc.ZoneServer.MapList.Items[Index];
					//Every player will be executed!
					//more checking should done in actual gm command code
					for idxY := Map.Size.Y - 1 downto 0 do
					begin
						for idxX := Map.Size.X - 1 downto 0 do
						begin
							for Index := Map.Cell[idxX, idxY].Beings.Count - 1 downto 0 do
							begin
								if not (Map.Cell[idxX,idxY].Beings.Objects[Index] is TCharacter) then
								begin
									Continue;
								end;
								TargetChar := Map.Cell[idxX,idxY].Beings.Objects[Index] as TCharacter;
								MainProc.ZoneServer.Commands.Commands[CommandID](Arguments, FromChar, TargetChar, Error);
							end;
						end;
					end;
				end else
				begin
					Error.Add('Map ' + Arguments[0] + ' not found!');
				end;
			end;
		end;
	finally
		FromChar.Free;
	end;

	if Error.Count > 0 then
	begin
		ZoneSendGMCommandResultToInter(GMID, CharacterID, ZoneID, Error);
	end;

	Error.Free;
end;{RecvGMCommandFromInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvGMCommandResultFromInter                                         PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Gets the gm command result information from the buffer.
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//    March 21st, 2007 - RaX - Created.
//------------------------------------------------------------------------------
procedure RecvGMCommandResultFromInter(
	const InBuffer : TBuffer
);
var
	CharacterID : LongWord;
	ACharacter	: TCharacter;
	Index : Integer;
	ErrCount    : Word;
	BufferIndex : Integer;
	ErrLen      : Word;
	Error       : TStringList;
	LoopTrials  : Byte;
begin
	CharacterID := BufferReadLongWord(4, InBuffer);
	ErrCount   := BufferReadWord(8, InBuffer);
	if (ErrCount > 0) then
	begin
		Error := TStringList.Create;
		BufferIndex := 10;

		for Index := 0 to ErrCount - 1 do
		begin
			ErrLen := BufferReadWord(BufferIndex, InBuffer);
			inc(BufferIndex, 2);
			Error.Add(BufferReadString(BufferIndex,ErrLen,InBuffer));
			inc(BufferIndex, ErrLen);
		end;

		LoopTrials := 0;
		While LoopTrials < 10 do
		begin
			Index := MainProc.ZoneServer.CharacterList.IndexOf(CharacterID);
			if Index > -1 then
			begin
				ACharacter	:= MainProc.ZoneServer.CharacterList[Index] as TCharacter;
				for Index := 0 to Error.Count - 1 do
				begin
					ZoneSendCharacterMessage(ACharacter, Error[Index]);
				end;
				Break;
			end else
			begin
				Inc(LoopTrials);
				Sleep(1000);
			end;
		end;
		Error.Free;
	end;
end;{RecvGMCommandFromInter}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvAddFriendRequest                                                 PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive add friend request from inter server
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/12/07] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvAddFriendRequest(
	InBuffer : TBuffer
);
var
	ReqAID, ReqID  : LongWord;
	ReqName        : String;
	TargetChar     : LongWord;

	Index  : Integer;
	Chara  : TCharacter;
begin
	ReqAID      := BufferReadLongWord(2, InBuffer);
	ReqID       := BufferReadLongWord(6, InBuffer);
	TargetChar  := BufferReadLongWord(10, InBuffer);
	ReqName     := BufferReadString(14, NAME_LENGTH, InBuffer);

	Index := MainProc.ZoneServer.CharacterList.IndexOf(TargetChar);
	if Index > -1 then
	begin
		Chara := MainProc.ZoneServer.CharacterList[Index] as TCharacter;
		if Chara.Friends >= MAX_FRIENDS then
		begin
			// to much..
			ZoneSendAddFriendReply(
				MainProc.ZoneServer.ToInterTCPClient,
				ReqID,
				Chara.AccountID,
				Chara.ID,
				Chara.Name,
				3
			);
		end else
		begin
			SendAddFriendRequest(Chara.ClientInfo, ReqAID, ReqID, ReqName);
		end;
	end;
end;{RecvAddFriendRequest}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvAddFriendRequestReply                                            PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive reply from inter server
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/12/08] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvAddFriendRequestReply(
	InBuffer : TBuffer
);
var
	OrigID    : LongWord;
	AccID     : LongWord;
	CharID    : LongWord;
	CharName  : String;
	Reply     : Byte;

	Index  : Integer;
	Chara  : TCharacter;
	Send : Boolean;

	FriendRequestEvent : TFriendRequestEvent;

	EventList : TList;
begin
	OrigID   := BufferReadLongWord(2, InBuffer);
	AccID    := BufferReadLongWord(6, InBuffer);
	CharID   := BufferReadLongWord(10, InBuffer);
	Reply    := BufferReadByte(14, InBuffer);
	CharName := BufferReadString(15, NAME_LENGTH, InBuffer);
	Send := True;
	Index := MainProc.ZoneServer.CharacterList.IndexOf(OrigID);
	if Index > -1 then
	begin
		Chara := MainProc.ZoneServer.CharacterList[Index] as TCharacter;
		if Reply = 0 then
		begin
			EventList := Chara.EventList.LockList;
			try
				for Index := 0 to EventList.Count -1 do
				begin
					if TObject(EventList.Items[Index]) is TFriendRequestEvent then
					begin
						FriendRequestEvent := TObject(EventList.Items[Index]) as TFriendRequestEvent;
						if FriendRequestEvent.PendingFriend = CharID then
						begin
							EventList.Delete(Index);
							//Accept
							with TThreadLink(Chara.ClientInfo.Data).DatabaseLink.Friend do
							begin
								//Add target first
								if not IsFriend(OrigID, CharID) then
									Add(OrigID, CharID);

								// Use 255 here!
								ZoneSendAddFriendReply(
									MainProc.ZoneServer.ToInterTCPClient,
									CharID,
									Chara.AccountID,
									Chara.ID,
									Chara.Name,
									255
								);
								Break;
							end;
						end else
							Send := False;
					end else
						Send := False;
				end;
			finally
				Chara.EventList.UnlockList;
			end;
		end;

		// Why? to make sure not trigger again -.-
		if Reply = 255 then
			Reply := 0;
		if Reply = 0 then
			Inc(Chara.Friends);
		if Send then
			SendAddFriendRequestReply(Chara.ClientInfo, AccID, CharID, CharName, Reply);
	end;
end;{RecvAddFriendRequestReply}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvFriendOnlineStatus                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Receive friend status check from inter server. if target character is
// online then send to both players (send back via inter server)
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/12/??] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvFriendOnlineStatus(
	InBuffer : TBuffer
);
var
	AID		: LongWord;
	CID		: LongWord;
//	TargetAID	: LongWord;
	TargetCID	: LongWord;
	ZoneID		: LongWord;
	Offline		: Byte;

	Index		: Integer;
	Chara		: TCharacter;
begin
	AID		:= BufferReadLongWord(2, InBuffer);
	CID		:= BufferReadLongWord(6, InBuffer);
//	TargetAID	:= BufferReadLongWord(10, InBuffer);
	TargetCID	:= BufferReadLongWord(14, InBuffer);
	ZoneID		:= BufferReadLongWord(18, InBuffer);
	Offline		:= BufferReadByte(22, InBuffer);

	Index := MainProc.ZoneServer.CharacterList.IndexOf(TargetCID);
	if (Index > -1) then
	begin
		Chara := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;

		if Offline = 0 then
		begin
			ZoneSendPlayerOnlineReply(
				MainProc.ZoneServer.ToInterTCPClient,
				Chara.AccountID,
				Chara.ID,
				CID,
				Offline,
				ZoneID
			);
		end;

		SendFirendOnlineStatus(
			Chara.ClientInfo,
			AID,
			CID,
			Offline
		);
	end;
	// We don't send if is online..
end;{RecvFriendOnlineStatus}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvFriendStatus                                                     PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      After everything else, the last step would find origin character and
// tell status about starget one
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2007/12/??] - Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvFriendStatus(
	InBuffer : TBuffer
);
var
	AID       : LongWord;
	CID       : LongWord;
	TargetID  : LongWord;
	Offline   : Byte;

	Index     : Integer;
	Chara     : TCharacter;
begin
	AID        := BufferReadLongWord(2, InBuffer);
	CID        := BufferReadLongWord(6, InBuffer);
	TargetID   := BufferReadLongWord(10, InBuffer);
	Offline    := BufferReadByte(14, InBuffer);

	Index := MainProc.ZoneServer.CharacterList.IndexOf(TargetID);

	if (Index > -1) then
	begin
		Chara := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;

		SendFirendOnlineStatus(
			Chara.ClientInfo,
			AID,
			CID,
			Offline
		);
	end;
end;{RecvFriendStatus}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvMailNotify                                                       PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Okay, received notify, let's parse it
//--
//   Pre:
//	TODO
//   Post:
//	TODO
//--
//  Changes -
//	[2008/08/11] Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvMailNotify(
	InBuffer : TBuffer
);
var
	CharID : LongWord;
	MailID : LongWord;
	Sender : String;
	Title  : String;

	Index     : Integer;
	Chara     : TCharacter;
begin
	CharID := BufferReadLongWord(2, InBuffer);
	MailID := BufferReadLongWord(6, InBuffer);
	Sender := BufferReadString(10,NAME_LENGTH, InBuffer);
	Title  := BufferReadString(10+NAME_LENGTH, 40, InBuffer);

	Index := MainProc.ZoneServer.CharacterList.IndexOf(CharID);

	if (Index > -1) then
	begin
		Chara := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;

		SendNewMailNotify(
			Chara,
			MailID,
			Sender,
			Title
		);
	end;
end;{RecvMailNotify}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvCreateInstanceResult                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		Received result, let's see...
//
//	Changes -
//	[2008/12/06] Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvCreateInstanceResult(
	InBuffer : TBuffer
);
var
	Size : Word;
	CharID : LongWord;
	ScriptID : LongWord;
	FullName : String;
	Flag : Byte;

	Index : Integer;
	AChara : TCharacter;
begin
	Size       := BufferReadWord(2, InBuffer);
	CharID     := BufferReadLongWord(4, InBuffer);
	ScriptID   := BufferReadLongWord(8, InBuffer);
	Flag       := BufferReadByte(12, InBuffer);
	FullName := BufferReadString(13, Size-13, InBuffer);


	Index := MainProc.ZoneServer.CharacterList.IndexOf(CharID);
	if Index > -1 then
	begin
		AChara := MainProc.ZoneServer.CharacterList.Items[Index] as TCharacter;
		if Flag = 0 then
		begin
			if ScriptID > 0 then
			begin
				AChara.ScriptStatus := SCRIPT_RUNNING;
				ResumeLuaNPCScriptWithString(AChara,FullName);
			end else
			begin
				ZoneSendCharacterMessage(
					AChara,
					'Instance map '+ FullName + ' created'
				);
			end;
		end else
		begin
			if ScriptID > 0 then
			begin
				AChara.ScriptStatus := SCRIPT_RUNNING;
				//Failed, return empty string
				ResumeLuaNPCScriptWithString(AChara,'');
			end else
			begin
				ZoneSendCharacterMessage(
					AChara,
					'Request create instance map failed'
				);
			end;
		end;
	end;
end;{RecvCreateInstanceResult}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RecvCreateInstance                                                   PROCEDURE
//------------------------------------------------------------------------------
//	What it does -
//		YESH, Let's CREATE..
//
//	Changes -
//	[2008/12/07] Aeomin - Created
//------------------------------------------------------------------------------
procedure RecvCreateInstance(
	InBuffer : TBuffer
);
var
	Size : Word;
	Identifier : String;
	MapName : String;
	ZoneID: LongWord;
	CharID : LongWord;
	ScriptID : LongWord;
	FullName : String;

	AMap : TInstanceMap;
begin
	Size       := BufferReadWord(2, InBuffer);
	ZoneID     := BufferReadLongWord(4, InBuffer);
	CharID     := BufferReadLongWord(8, InBuffer);
	ScriptID   := BufferReadLongWord(12, InBuffer);
	MapName    := BufferReadString(16, 16, InBuffer);
	Identifier := BufferReadString(32, Size-32, InBuffer);

	FullName := Identifier + '#' + MapName;

	AMap := TInstanceMap.Create;
	AMap.Load(Identifier,MapName);
	MainProc.ZoneServer.MapList.Add(AMap);

	ZoneSendCreatedInstance(
		MainProc.ZoneServer.ToInterTCPClient,
		ZoneID,
		CharID,
		ScriptID,
		FullName
	);
end;{RecvCreateInstance}
//------------------------------------------------------------------------------
end{ZoneRecv}.
