//------------------------------------------------------------------------------
//Being                                                                   UNIT
//------------------------------------------------------------------------------
//	What it does-
//			Contains RO environment type TBeing.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
unit Being;

interface
uses
	Types,
	GameConstants,
	Map,
	EventList,
	PointList;

//------------------------------------------------------------------------------
//TBeing                                                                  CLASS
//------------------------------------------------------------------------------
type TBeing = class
	protected
		fName             : String;
		fJID              : Word;
		fBaseLV           : Byte;
		fJobLV            : Byte;
		fBaseEXP          : LongWord;
		fJobEXP           : LongWord;
		fZeny             : LongWord;
		fParamBase        : Array[STR..LUK] of Byte;
		fMaxHP            : Word;
		fHP               : Word;
		fMaxSP            : Word;
		fSP               : Word;
		fOption           : Word;
		fMap              : String;
		fMapPt            : TPoint;

		procedure SetName(Value : string); virtual;
		procedure SetClass(Value : word); virtual;
		procedure SetBaseLV(Value : byte); virtual;
		procedure SetJobLV(Value : byte); virtual;
		procedure SetBaseEXP(Value : LongWord); virtual;
		procedure SetJobEXP(Value : LongWord); virtual;
		procedure SetZeny(Value : LongWord); virtual;
		function  GetBaseStats(Index : Byte) : byte;  virtual;
		procedure SetBaseStats(Index: byte; Value: byte); virtual;
		procedure SetMaxHP(Value : word); virtual;
		procedure SetHP(Value : word); virtual;
		procedure SetMaxSP(Value : word); virtual;
		procedure SetSP(Value : word); virtual;
		Procedure SetOption(Value : word); virtual;
		procedure SetMap(Value : string); virtual;
		procedure SetMapPt(Value : TPoint); virtual;

	public
		ID        : LongWord;
		MapPointer: Pointer;
		Speed : word;
		Direction : byte;

		AttackRange : word;
		//No idea what 0..5 is from.  Stats?
		ATK : Word;

		//For Mobs and NPCs, Leave #2's alone (0), and use #1s
		MATK1 : word;
		MATK2 : word;
		DEF1 : word;
		DEF2 : word;
		MDEF1 : word;
		MDEF2 : word;
		HIT : word;
		FLEE1 : word;
		Lucky : word;
		Critical : word;
		ASpeed : word;

		MapInfo : TMap;
		EventList : TEventList;
		Path      : TPointList;
		PathIndex : Word;
		MoveTick : LongWord;

		property Name      : string     read fName write SetName;
		property JID       : Word       read fJID write SetClass;
		property BaseLV    : Byte       read fBaseLV write SetBaseLV;
		property JobLV     : Byte       read fJobLV write SetJobLV;
		property ParamBase[Index : byte] : byte read GetBaseStats write SetBaseStats;
		property MaxHP     : Word       read fMaxHP write SetMaxHP;
		property HP        : Word       read fHP write SetHP;
		property MaxSP     : Word       read fMaxSP write SetMaxSP;
		property SP        : Word       read fSP write SetSP;
		property Option    : Word       read fOption write SetOption;
		property Map       : string     read fMap write SetMap;
		property Point     : TPoint     read fMapPt write SetMapPt;

		procedure Walk;
		procedure CalcMaxHP; virtual;
		procedure CalcMaxSP; virtual;
		procedure CalcSpeed; virtual;

		Constructor Create();
		Destructor Destroy();override;
end;{TBeing}
//------------------------------------------------------------------------------


implementation
uses
	Event,
	MovementEvent,
	Character,
	Globals,
	Math,
	SysUtils,
	WinLinux,
	Main;


//------------------------------------------------------------------------------
//Walk								                                                PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      The internal walk routine, moves a character cell by cell attempting to
//		follow the way the client is moving on screen.
//
//  Changes -
//    February 27th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
procedure TBeing.Walk;
var
	spd : word;
	AMoveEvent : TMovementEvent;
	OldPt : TPoint;
	ABeing : TBeing;
	dx : ShortInt;
	dy : ShortInt;
	idxY : SmallInt;
	idxX : SmallInt;
	BIdx : integer;
begin
	if Self is TCharacter then
	begin
		TCharacter(Self).CharaState := charaWalking;
	end;

	MapInfo.Cell[Point.X,Point.Y].Beings.Delete(
		MapInfo.Cell[Point.X,Point.Y].Beings.IndexOfObject(Self));

	Console.Message(Format('Old (%d,%d) Index: %d Count: %d',[Point.X,Point.Y,PathIndex,Path.Count]),'TBeing.Walk',MS_DEBUG);
	OldPt := Point;
	Point := Path[PathIndex];
	Console.Message(Format('New (%d,%d) Index: %d Count: %d',[Point.X,Point.Y,PathIndex,Path.Count]),'TBeing.Walk',MS_DEBUG);

	MapInfo.Cell[Point.X,Point.Y].Beings.AddObject(Self.ID,Self);

	dx := Point.X - OldPt.X;
	dy := Point.Y - OldPt.Y;

	//16 covers the old 15x15 grid, no matter which dir we go I think
	for idxY := Max(OldPt.Y-MainProc.ZoneServer.Options.CharShowArea,0) to Min(OldPt.Y+MainProc.ZoneServer.Options.CharShowArea,MapInfo.Size.Y) do
	begin
		for idxX := Max(OldPt.X-MainProc.ZoneServer.Options.CharShowArea,0) to Min(OldPt.X+MainProc.ZoneServer.Options.CharShowArea,MapInfo.Size.X) do
		begin
			for BIdx := MapInfo.Cell[idxX,idxY].Beings.Count - 1 downto 0 do
			begin
				ABeing := MapInfo.Cell[idxX,idxY].Beings.Objects[BIdx] as TBeing;
				if Self = ABeing then Continue;

				if ((dx <> 0) and (abs(OldPt.Y - ABeing.Point.Y) < MainProc.ZoneServer.Options.CharShowArea) and (OldPt.X = ABeing.Point.X + dx * (MainProc.ZoneServer.Options.CharShowArea-1))) OR
					((dy <> 0) and (abs(OldPt.X - ABeing.Point.X) < MainProc.ZoneServer.Options.CharShowArea) and (OldPt.Y = ABeing.Point.Y + dy * (MainProc.ZoneServer.Options.CharShowArea-1))) then
				begin
					//Packets for base being if its a character
					if Self is TCharacter then
					begin
						if ABeing is TCharacter then
						begin
							//Send First Being disapearing to ABeing
						end;
						//if ABeing is NPC
						//Special npc packets
						//else
						//Send basic disapear packet of ABeing to First Being
					end;
				end;

				if ((dx <> 0) and (abs(Point.Y - ABeing.Point.Y) < MainProc.ZoneServer.Options.CharShowArea) and (Point.X = ABeing.Point.X - dx * (MainProc.ZoneServer.Options.CharShowArea-1))) or
					((dy <> 0) and (abs(Point.X - ABeing.Point.X) < MainProc.ZoneServer.Options.CharShowArea) and (Point.Y = ABeing.Point.Y - dy * (MainProc.ZoneServer.Options.CharShowArea-1))) then
				begin
					if Self is TCharacter then
					begin
						if ABeing is TCharacter then
						begin
							//Send First Being apearing to ABeing
							{if Point in range with ABeing, 15 then
							begin
								SendWalking packet
							end;}
						end;
						//if ABeing is NPC
						//Special npc packets
						//else
						//Send basic Appear packet of ABeing to First Being
					end;
				end;
			end;
		end;
	end;

	if Self is TCharacter then
	begin
		if not (TCharacter(Self).CharaState = charaWalking) then
		begin
			PathIndex := Path.Count -1;
		end;
	end;

	if (PathIndex = Path.Count - 1) then
	begin
		Console.Message('Path Ended','TBeing.Walk',MS_DEBUG);
		if Self is TCharacter then
		begin
			TCharacter(Self).CharaState := charaStanding;
		end;
		PathIndex := 0;

		{if GameState = charaStand then
		begin
			//UpdateLocation
			//So we can make as if we just steped on a trap or were frozen, etc, stop where
			//we are and update location.
		end;}

		//GameState := charaStand;

		{if (AChara.Skill[144].Lv = 0) then
		begin
			HPTick := Tick;
		end;

		HPRTick := Tick - 500;
		SPRTick := Tick;
		PathIndex := 0;}
	end else
	begin
		Console.Message('Adding Next Event','TBeing.Walk',MS_DEBUG);
		//Setup first speed
		PathIndex := Min(PathIndex+1,Path.Count-1);
		dx := Path[PathIndex].X - Point.X;
		dy := Path[PathIndex].Y - Point.Y;
		if not (abs(dx) = abs(dy)) then
		begin
			spd := Speed * 7 div 5;
		end else begin
			spd := Speed;
		end;
		MoveTick := MoveTick + spd;

		AMoveEvent := TMovementEvent.Create(Self);
		AMoveEvent.ExpiryTime := MoveTick;
		Self.EventList.Add(AMoveEvent);
	end;

end;//Walk
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Create							                                                PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Creates our TBeing.
//
//  Changes -
//    February 27th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
Constructor TBeing.Create;
begin
	inherited;
	EventList := TEventList.Create(TRUE);
	Path := TPointList.Create;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Destroy							                                                PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Destroys our TBeing
//
//  Changes -
//    February 27th, 2007 - RaX - Created Header;
//------------------------------------------------------------------------------
Destructor TBeing.Destroy;
begin
	inherited;
	EventList.Free;
	Path.Free;
end;
//------------------------------------------------------------------------------

procedure TBeing.SetName(Value : string); begin fName := Value; end;
procedure TBeing.SetClass(Value : Word); begin fJID := Value; end;
procedure TBeing.SetBaseLV(Value : byte); begin fBaseLV := Value; end;
procedure TBeing.SetJobLV(Value : byte); begin fJobLV := Value; end;
procedure TBeing.SetBaseEXP(Value : LongWord); begin fBaseEXP := Value; end;
procedure TBeing.SetJobEXP(Value : LongWord); begin fJobEXP := Value; end;
procedure TBeing.SetZeny(Value : LongWord); begin fZeny := Value; end;
function  TBeing.GetBaseStats(Index : Byte) : byte; begin Result := fParamBase[Index]; end;
procedure TBeing.SetBaseStats(Index: byte; Value: byte); begin fParamBase[Index] := Value; end;
procedure TBeing.SetMaxHP(Value : word); begin fMaxHP := Value; end;
procedure TBeing.SetHP(Value : word); begin fHP := Value; end;
procedure TBeing.SetMaxSP(Value : word); begin fMaxSP := Value; end;
procedure TBeing.SetSP(Value : word); begin fSP := Value; end;
Procedure TBeing.SetOption(Value : word); begin fOption := Value; end;
procedure TBeing.SetMap(Value : string); begin fMap := Value; end;
procedure TBeing.SetMapPt(Value : TPoint); begin fMapPt := Value; end;

procedure TBeing.CalcMaxHP; begin end;
procedure TBeing.CalcMaxSP; begin end;
procedure TBeing.CalcSpeed; begin Speed := 150; end;


end.
