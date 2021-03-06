(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*

Unit
Being

*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*

[2006/??/??] Helios - No author stated

================================================================================
License:  (FreeBSD, plus commercial with written permission clause.)
================================================================================

Project Helios - Copyright (c) 2005-2007

All rights reserved.

Please refer to Helios.dpr for full license terms.

================================================================================
Overview:
================================================================================

Class, interface, and common defaults for a "Being" are defined here.
Characters, NPCs, and Monsters will all be derived from this base.

================================================================================
Revisions:
================================================================================
(Format: [yyyy/mm/dd] <Author> - <Desc of Changes>)
[2006/12/22] RaX - Created Header.
[2007/03/28] CR - Cleaned up uses clauses - unneeded units removed.
[2007/03/28] CR - Made changes to parameter lists for the TLoopCall
	declaration.  All parameteters are constant, and eliminated the entirely
	uncalled X,Ys so that we only have 2 parameters left (faster calls this
	way, especially when called repeatedly in triple nested loops!).
[2007/03/28] CR - Cleaned up uses clauses using Icarus as a guide.
[2007/04/28] CR - Altered unit header.  Improved unit description.  Added class
	header for TBeing, described minor changes to the interface there.
*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*)
unit Being;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}


interface


uses
	{RTL/VCL}
	Types,
	Classes,
	SysUtils,
	{Project}
	GameConstants,
	EventList,
	Map,
	PointList,
	GameObject,
	ParameterList
	{Third Party}
	//none
	;

type

StatArray = array [STR..LUK] of Integer;

TBeingState = (
	BeingDead,
	BeingPlayDead,
	BeingSitting,
	BeingStanding,
	BeingWalking,
	BeingAttacking
);

TBeing = class; //Forward Declaration.

(*= CLASS =====================================================================*
TBeing

*------------------------------------------------------------------------------*
Overview:
*------------------------------------------------------------------------------*

	Common class for the Character, NPC, and Monster classes (some of which have
yet to be defined).  The base properties and routines common to all will be
contained here.

*------------------------------------------------------------------------------*
Revisions:
*------------------------------------------------------------------------------*
(Format: [yyyy/mm/dd] <Author> - <Description of Change>)
[2007/04/28] CR - Altered header, included description.  Made empty routines
	CalcMaxHP and CalcMaxSP abstract.  Eliminated private section, moved
	AreaLoop into protected.
[2007/04/28] CR - Changed fParamBase from an array to an equivalent type of
	ByteStatArray.
[2007/05/28] Tsusai - Removed MapPointer
*=============================================================================*)
TBeing = class(TGameObject)
protected
	fJID              : Word;
	fBaseLV           : Word;
	fJobLV            : Word;
	fBaseEXP          : LongWord;
	fJobEXP           : LongWord;
	fBaseEXPToNextLevel: LongWord;
	fJobEXPToNextLevel: LongWord;
	fZeny             : Integer;
	fParamBase        : StatArray;
	fMaxHP            : LongWord;
	fHP               : LongWord;
	fMaxSP            : Word;
	fSP               : Word;
	fStatus           : Word;
	fAilments         : Word;
	fOption           : Word;
	fSpeed            : Word;
	fASpeed						: Word;
	//Added Min and max hit for MobQueries.pas [Spre]
	fMinimumHit       : Integer;
	fMaximumHit       : Integer;
	// Attack Damage and time motions. [Spre]
	fAttackDmgTime			:	Integer;
	fAttack_Motion			:	Integer;
	//Skill Range [Spre]
	fEnemySight				:	Byte;
	fElement	:	Word;
	AttackDelay				: LongWord;

	fBeingState : TBeingState;

	procedure SetBeingState(Value : TBeingState);
	procedure SetJID(Value : word); virtual;
	procedure SetBaseLV(Value : word); virtual;
	procedure SetJobLV(Value : word); virtual;
	procedure SetBaseEXP(Value : LongWord); virtual;
	procedure SetJobEXP(Value : LongWord); virtual;
	procedure SetZeny(Value : Integer); virtual;

	Function  GetBaseStats(
		const
			Index : Byte
		) : Integer;  virtual;

	procedure SetBaseStats(
		const
			Index : Byte;
		const
			Value : Integer
		); virtual;

	procedure SetMaxHP(Value : LongWord); virtual;
	procedure SetHP(Value : LongWord); virtual;
	procedure SetMaxSP(Value : Word); virtual;
	procedure SetSP(Value : Word); virtual;
	Procedure SetStatus(Value : word); virtual;
	Procedure SetAilments(Value : word); virtual;
	Procedure SetOption(Value : word); virtual;
	procedure SetSpeed(Value : Word); virtual;
	procedure SetASpeed(Value : Word); virtual;
	procedure SetMinimumHit(Value : Integer); virtual;
	procedure SetMaximumHit(Value : Integer); virtual;
	procedure SetAttackDmgTime(Value	:	Integer);	virtual;
	procedure SetAttack_Motion(Value	:	Integer);	virtual;
	procedure SetEnemySight(Value	:	Byte);	virtual;
	procedure SetElement(Value	:	Word);	virtual;
	function GetHpPercent: Byte;
	procedure SetHPPercent(Value : Byte);
	function GetSpPercent: Byte;
	procedure SetSPPercent(Value : Byte);

public
	HeadDirection	: Word;
	Direction 	: Byte;

	AttackRange	: Word;
	//No idea what 0..5 is from.  Stats?
	ATK					: Word;

	MATK1				: Word;
	MATK2				: Word;
	DEF1				: Word;
	DEF2				: Word;
	MDEF1				: Word;
	MDEF2				: Word;
	HIT					: Word;
	FLEE1				: Word;
	PerfectDodge: Byte;
	FalseCritical	: Word;
	Critical		: Word;

	SaveMapID		: LongWord;
	EventList		: TEventList;
	Path				: TPointList;
	PathIndex		: Word;
	MoveTick		: LongWord;

	TargetID		: LongWord;

	property JID       : Word       read fJID     write SetJID;
	property BaseLV    : Word       read fBaseLV  write SetBaseLV;
	property JobLV     : Word       read fJobLV   write SetJobLV;
	property BaseEXP   : LongWord   read fBaseEXP write fBaseEXP;
	property JobEXP    : LongWord   read fJobEXP  write fJobEXP;
	property BaseEXPToNextLevel : LongWord read fBaseEXPToNextLevel write fBaseEXPToNextLevel;
	property JobEXPToNextLevel  : LongWord read fJobEXPToNextLevel  write fJobEXPToNextLevel;
	property ParamBase[const Index : Byte] : Integer
		read  GetBaseStats
		write SetBaseStats;
	property MaxHP     : LongWord       read fMaxHP write SetMaxHP;
	property HP        : LongWord       read fHP write SetHP;
	property HPPercent : Byte       read GetHpPercent write SetHPPercent;
	property SPPercent : Byte       read GetSpPercent write SetSPPercent;
	property MaxSP     : Word       read fMaxSP write SetMaxSP;
	property SP        : Word       read fSP write SetSP;
	property Status    : Word       read fStatus write SetStatus;
	property Ailments  : Word       read fAilments write SetAilments;
	property Option    : Word       read fOption write SetOption;
	property Speed     : Word       read fSpeed write SetSpeed;
	property ASpeed		 : Word				read fASpeed write SetASpeed;
	property MinimumHit		 : Integer				read fMinimumHit write SetMinimumHit;
	property MaximumHit		 : Integer				read fMaximumHit write SetMinimumHit;
	property AttackDmgTime	:	Integer				read fAttackDmgTime	write	SetAttackDmgTime;
	property Attack_Motion	:	Integer				read fAttack_Motion	write	SetAttack_Motion;
	property EnemySight	:	Byte				read	fEnemySight	write	SetEnemySight;
	property Element	:	Word			read	fElement	write	SetElement;

	property BeingState  : TBeingState read fBeingState write SetBeingState;

	Procedure Walk;

	Procedure CalcMaxHP; virtual; abstract;

	Procedure CalcMaxSP; virtual; abstract;

	Procedure CalcSpeed; virtual;
	procedure CalcASpeed; virtual;
	procedure DelayDisconnect(ExpireTime:Integer);

	procedure ShowBeingWalking;
	procedure ShowTeleportIn;
	procedure ShowTeleportOut;
	procedure UpdateDirection;
	procedure ShowEffect(EffectID:LongWord);
	procedure ShowEmotion(EmotionID:Byte);
	procedure Attack(ATargetID : LongWord; AttackContinuous : Boolean; JustAttacked : Boolean);virtual;
	Function GetTargetIfInRange(
		const ID						: LongWord;
		const Distance			: Word;
		var TargetBeing			: TBeing
	) : Boolean;
	Function GetPath(
			const
				StartPoint : TPoint;
			const
				EndPoint   : TPoint;
			var
				APath      : TPointList
	) : Boolean;

	function InPointRange(const TargetPoint:TPoint):Boolean;

	procedure Death; virtual;



	procedure RemoveFromMap;
	procedure AddToMap;
	Constructor Create;
	Destructor Destroy;override;

End;(* TBeing
*== CLASS ====================================================================*)


implementation


uses
	{RTL/VCL}
	Math,
	WinLinux,
	SyncObjs,
	{Project}
	AreaLoopEvents,
	Character,
	Main,
	MovementEvent,
	DelayDisconnectEvent,
	ZoneSend,
	OnTouchCellEvent,
	MapTypes,
	AttackEvent,
	ItemInstance,
	Mob
	{Third Party}
	//none
	;


(*- Procedure -----------------------------------------------------------------*
TBeing.Walk
--------------------------------------------------------------------------------
Overview:
--
	The internal walk routine, moves a character cell by cell attempting to
follow the way the client is moving on screen.

--
Pre:
	TODO
Post:
	TODO

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/02/27] RaX - Created Header
[2007/04/28] CR - Altered comment header.  Added scathing comments for the lack
	of explanation for what REALLY goes in within this routine when two of the
	devs working on this project had to deal with poorly documented code before-
	hand and SHOULD KNOW BETTER than to leave code of this complexity unadorned
	with ANY sensible comments.  On a positive note, the explanation for the
	routine was fine.
[2007/05/28] Tsusai - Mixed OnTouch to only run just once if a character is
	in the walking ontouch field.
Halloween 2008 - Tsusai - Updated WriteBufferTwoPoints settings
*-----------------------------------------------------------------------------*)
Procedure TBeing.Walk;
Var
	spd        : Word;
	Index      : Integer;
	AMoveEvent : TMovementEvent;
	OldPt      : TPoint;
	idxY       : SmallInt;
	idxX       : SmallInt;
	Radius     : Word;
	OnTouchCellFound : boolean;
	OnTouchCell : TOnTouchCellEvent;

	CriticalSection : TCriticalSection;

	ParameterList : TParameterList;


	(*. local function ...................*
	Gets our new direction
	Using basic mathematics and an existing array, we are able to get a direction in the form of the following
	where X is the current cell, 0 = North, 4 = South, 2 = West, 6 = East
		107
		2X6
		345

	[2007/04/28] CR - Header, made parameters constant, changed for loop Index
		from Integer to Byte, to eliminate a cast to Byte.

	*....................................*)
	function GetDirection(
		const
			OldPoint : TPoint;
		const
			NewPoint : TPoint
		) : Byte;
	var
		DirectionPoint : TPoint;
		Index          : Byte;
	begin
		Result := 0;
		DirectionPoint := Point(NewPoint.X-OldPoint.X, NewPoint.Y-OldPoint.Y);

		for Index := 0 to 7 do
		begin
			if PointsEqual(DirectionPoint, Directions[Index]) then
			begin
				Result := Index;
				Break;
			end;
		end;
	end;(*. local function .............*)

	procedure HideBeings;
	var
		ABeing : TBeing;
		ObjectIdx : Integer;
	begin
		//Ok this took me some time to setup just right
		//First, what we're trying to determine is if we moved in a particular
		//location, a row or column of cells should be leaving the being's field
		//of view

		//Example (using change of X), We are changing X.  Then we see if they are
		//within our Y visual range. Last check is that they left our visual range
		//on the X factor

		//Check to make sure that we're inside the map edges by one to prevent
		//looking outside of the map bounds.
		if (IdxX < Mapinfo.Size.X-1) AND (IdxX > 0) AND
			 (IdxY < MapInfo.Size.Y-1) AND (IdxY > 0) then
		begin
			if {X axis}((Directions[Direction].X <> 0) and
				(abs(OldPt.Y - idxY) < Radius) and
				(OldPt.X = idxX + Directions[Direction].X * (Radius - 1 )))
			OR {Y axis}((Directions[Direction].Y <> 0) and
				(abs(OldPt.X - idxX) < Radius) and
				(OldPt.Y = idxY + Directions[Direction].Y * (Radius - 1))) then
			begin
				for ObjectIdx := MapInfo.Cell[idxX,idxY].Beings.Count -1  downto 0 do
				begin
					if MapInfo.Cell[idxX,idxY].Beings.Objects[ObjectIdx] is TBeing then
					begin
						ABeing := MapInfo.Cell[idxX,idxY].Beings.Objects[ObjectIdx] as TBeing;
						if ABeing = Self then Continue;

						//Packets for base being if its a character
						if Self is TCharacter then
						begin
							//if the target is also a TCharacter, they need OUR info
							if ABeing is TCharacter then
							begin
								ZoneDisappearBeing(Self,   TCharacter(ABeing).ClientInfo);
								ZoneDisappearBeing(ABeing, TCharacter(Self).ClientInfo);
								//Send First Being disapearing to ABeing
							end else  //Npc/Mob/Pet/Homunculus/Mercenary
							begin
								{Todo: events for NPC}
								if NOT (ABeing.BeingState = BeingWalking) then
								begin
									ZoneDisappearBeing(ABeing,TCharacter(Self).ClientInfo);
								end;
							end;
						end else
						begin
							if ABeing is TCharacter then
							begin
								ZoneDisappearBeing(Self,   TCharacter(ABeing).ClientInfo);
							end;
						end;
					end;
				end;
				if Self is TCharacter then
				begin
					if MapInfo.Cell[idxX,idxY].Items.Count > 0 then
					begin
						for ObjectIdx := MapInfo.Cell[idxX,idxY].Items.Count -1  downto 0 do
						begin
							SendRemoveGroundItem(
								TCharacter(Self),
								TItemInstance(MapInfo.Cell[idxX,idxY].Items.Objects[ObjectIdx]).ID
							);
						end;
					end;
				end;
			end;
		end;
	end;

	procedure ShowBeings;
	var
		ABeing : TBeing;
		ObjectIdx : Integer;
	begin
		//Check to make sure that we're inside the map edges by one to prevent
		//looking outside of the map bounds.
		if (IdxX < Mapinfo.Size.X-1) AND (IdxX > 0) AND
			 (IdxY < MapInfo.Size.Y-1) AND (IdxY > 0) then
		begin
			//This is the opposite of the above.  We check to see if we are making the apropriate change, and seeing if a tbeing will be in the visual range if we made the step forward
			if {X axis}((Directions[Direction].X <> 0) and
				(abs(Position.Y - idxY) < Radius) and
				(Position.X = idxX - Directions[Direction].X * (Radius - 1)))
			OR {Y axis}((Directions[Direction].Y <> 0) and
				(abs(Position.X - idxX) < Radius) and
				(Position.Y = idxY - Directions[Direction].Y * (Radius - 1))) then
			begin
				for ObjectIdx := MapInfo.Cell[idxX,idxY].Beings.Count -1  downto 0 do
				begin
					if MapInfo.Cell[idxX,idxY].Beings.Objects[ObjectIdx] is TBeing then
					begin
						ABeing := MapInfo.Cell[idxX,idxY].Beings.Objects[ObjectIdx] as TBeing;
						if ABeing = Self then Continue;

						//If we are a tcharacter, we need packets!
						if Self is TCharacter then
						begin
							//If the target TBeing is also a character, they need info on us.
							ZoneSendBeing(ABeing,TCharacter(Self));
							if ABeing is TCharacter then
							begin
								ZoneSendBeing(Self, TCharacter(ABeing));
								ZoneWalkingBeing(Self,Position,Path[Path.count-1],TCharacter(ABeing).ClientInfo);
								if Assigned(TCharacter(ABeing).ChatRoom) then
								begin
									if TCharacter(ABeing).ChatRoom.Owner = ABeing then
									begin
										DisplayChatroomBar(TCharacter(Self),TCharacter(ABeing).ChatRoom);
									end;
								end;
								
							end else  //Npc/Mob/Pet/Homunculus/Mercenary packets to the client
							begin
								if ABeing is TMob then
								begin
									TMob(ABeing).AI.ObjectNear(Self);
								end;
								{Todo: events for NPC}
								if ABeing.BeingState = BeingWalking then
								begin
									ZoneWalkingBeing(ABeing,ABeing.Position,ABeing.Path[ABeing.Path.count-1],TCharacter(Self).ClientInfo);
								end;
							end;
						end else
						begin
							if ABeing is TCharacter then
							begin
								ZoneSendBeing(Self, TCharacter(ABeing));
								ZoneWalkingBeing(Self,Position,Path[Path.count-1],TCharacter(ABeing).ClientInfo);
							end;
						end;
					end;
				end;
				if Self is TCharacter then
				begin
					if MapInfo.Cell[idxX,idxY].Items.Count > 0 then
					begin
						for ObjectIdx := MapInfo.Cell[idxX,idxY].Items.Count - 1 downto 0 do
						begin
							SendGroundItem(
								TCharacter(Self),
								TItemInstance(MapInfo.Cell[idxX,idxY].Items.Objects[ObjectIdx])
							);
						end;
					end;
				end;
			end;
		end;
	end;

Begin
	CriticalSection := TCriticalSection.Create;
	CriticalSection.Enter;
	if PathIndex < Path.Count then
	begin
		//Setup visual radius
		Radius := MainProc.ZoneServer.Options.CharShowArea + 1;
		OnTouchCellFound := false;

		Self.BeingState := BeingWalking;

		OldPt     := Position;

		Position	:= Path[PathIndex];
		Direction := GetDirection(OldPt, Position);

		//This is for debug, disable if needed.
		ParameterList := TParameterList.Create;
		ParameterList.AddAsLongWord(1,Random($FFFFFFF));
		ParameterList.AddAsLongWord(2,Path[PathIndex].X);
		ParameterList.AddAsLongWord(3,Path[PathIndex].Y);
		ParameterList.AddAsLongWord(4,$83);
		AreaLoop(ShowSkillUnit,FALSE,ParameterList);
		ParameterList.Free;

	//-Tsusai
	//17 (Radius) covers the old 16x16 grid, no matter which dir we go I think
	//This is some complicated mathematics here, so I hope I do explain this right.

	//Bounds are set on the for loop from -> to to prevent searching from outside
	//the known map if the being is close to the edge or corner.
	//In a pure situation, first two rows and last 2 rows, and first 2 columns and
	//the last two columns are checked.
	// This is how things should look on a 9x9 grid.
	(*
	XXXXXXXXXX
	XXXXXXXXXX
	XXOOOOOOXX
	XXOOOOOOXX
	XXOOOOOOXX
	XXOOOOOOXX
	XXOOOOOOXX
	XXXXXXXXXX
	XXXXXXXXXX
	*)

		//Go up the entire vertical axis
		for idxY := Max(OldPt.Y - Radius,0) to
			Min(OldPt.Y + Radius,MapInfo.Size.Y-1) do
		begin
			//if we are on the top 2 or bottom 2 rows, go across
			if (idxY = OldPt.Y - Radius) or
				(idxY = (OldPt.Y - Radius) + 1) or
				(idxY = OldPt.Y + Radius) or
				(idxY = (OldPt.Y + Radius) - 1) then
			begin
				//Go across the entire row
				for idxX := Max(OldPt.X - Radius,0) to
					Min(OldPt.X + Radius,MapInfo.Size.X-1) do
				begin
					HideBeings;
					ShowBeings;
				end;
			end else
			begin
				//Left most side
				idxX := Max(OldPt.X - Radius,0);
				HideBeings;
				ShowBeings;
				//Left 2nd column
				idxX := Max((OldPt.X - Radius) + 1,0);
				HideBeings;
				ShowBeings;
				//Right most side
				idxX := Min(OldPt.X + Radius,MapInfo.Size.X);
				HideBeings;
				ShowBeings;
				//2nd from right
				idxX := Min((OldPt.X + Radius) -1 ,MapInfo.Size.X);
				HideBeings;
				ShowBeings;

			end;
		end;

		if NOT (Self.BeingState = BeingWalking) then
		begin
			PathIndex := Path.Count;
		end;

		if Self is TCharacter then
		begin
			//Check for ontouch events.
			for Index := MapInfo.Cell[Position.X][Position.Y].Beings.Count-1 downto 0 do
			begin
				if MapInfo.Cell[Position.X][Position.Y].Beings.Objects[Index] is TOnTouchCellEvent then
				begin
					OnTouchCellFound := true;
					OnTouchCell := TOnTouchCellEvent(MapInfo.Cell[Position.X][Position.Y].Beings.Objects[Index]);
					if TCharacter(Self).OnTouchIDs.IndexOf(OnTouchCell.ScriptNPC.ID) = -1 then
					begin
						TCharacter(Self).OnTouchIDs.Add(OnTouchCell.ScriptNPC.ID);
						TCharacter(Self).BeingState := BeingStanding;
						OnTouchCell.Execute(TCharacter(Self));
					end;
				end;
			end;

			if (not OnTouchCellFound) and (Self is TCharacter) then
			begin
				if TCharacter(Self).OnTouchIDs.Count > 0 then
				begin
					TCharacter(Self).OnTouchIDs.Clear;
				end;
			end;
		end;

		//Move to the next element in the path list.
		Inc(PathIndex);

		{[2007/04/28] CR - Why isn't this if branch part of the Speed Property? }
		if (Self.Direction IN Diagonals) then
		begin
			spd := Speed * 3 DIV 2;
		end else begin
			spd := Speed;
		end;
		MoveTick := MoveTick + spd;

		AMoveEvent := TMovementEvent.Create(MoveTick, Self);
		Self.EventList.Add(AMoveEvent);
	end else
	begin
		PathIndex := 0;


		Self.BeingState := BeingStanding;
		if Self is TMob then
		begin
			TMob(Self).AI.FinishWalk;
		end;

	end;
	CriticalSection.Leave;
	CriticalSection.Free;
end; (* Proc TBeing.Walk
*-----------------------------------------------------------------------------*)


//------------------------------------------------------------------------------
//DelayDisconnect                                                      PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//      Disconnect after time expire
//
//  Changes -
//    April 6h, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure TBeing.DelayDisconnect(ExpireTime:Integer);
var
	ADelayEvent:	TDelayDisconnectEvent;
begin
	ADelayEvent := TDelayDisconnectEvent.Create(ExpireTime,Self);
	ADelayEvent.ExpiryTime := ExpireTime;
	EventList.Add(ADelayEvent);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ShowBeingWalking                                                     PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
//	Show other character that you are walking...
//
//  Changes -
//	March 20th, 2007 - Aeomin - Created Header
//	March 23th, 2007 - Aeomin - Rename from ShowCharWalking to ShowBeingWalking
//------------------------------------------------------------------------------
procedure TBeing.ShowBeingWalking;
begin
	AreaLoop(ShowBeingWalk, True);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ShowTeleportIn                                                       PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
// 	Show teleport in effect to other characters
//
//  Changes -
//	March 20th, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure TBeing.ShowTeleportIn;
begin
	AreaLoop(ShowAreaObjects, True);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//ShowTeleportOut                                                      PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
// 	Show teleport out effect to other characters
//
//  Changes -
//	March 20th, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure TBeing.ShowTeleportOut;
begin
	AreaLoop(TeleOut, True);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//UpdateDirection                                                      PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
// 	Update Direction to other characters
//
//  Changes -
//	March 20th, 2007 - Aeomin - Created Header
//------------------------------------------------------------------------------
procedure TBeing.UpdateDirection;
begin
	AreaLoop(UpdateDir, True);
end;{UpdateDirection}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetTargetIfInRange                                                  PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
// 	Attempts to return the selected tbeing by id in range of this being.
//
//  Changes -
//	March 20th, 2007 - RaX - Moved out of Attack as an inline function
//------------------------------------------------------------------------------
Function TBeing.GetTargetIfInRange(
	const ID						: LongWord;
	const Distance			: Word;
	var TargetBeing			: TBeing
) : Boolean;
var
	idxX, idxY, BeingIdx : Integer;
begin
	Result := FALSE;
	for idxY := Max(0,Position.Y-Distance) to Min(Position.Y+Distance, MapInfo.Size.Y-1) do
	begin
		for idxX := Max(0,Position.X-Distance) to Min(Position.X+Distance, MapInfo.Size.X-1) do
		begin
			for BeingIdx := MapInfo.Cell[idxX][idxY].Beings.Count -1 downto 0 do
			begin
				if TBeing(MapInfo.Cell[idxX][idxY].Beings.Objects[BeingIdx]).ID = ID then
				begin
					Result			:= TRUE;
					TargetBeing	:= TBeing(MapInfo.Cell[idxX][idxY].Beings.Objects[BeingIdx]);
					Exit;
				end;
			end;
		end;
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Attack                                                               PROCEDURE
//------------------------------------------------------------------------------
//  What it does -
// 	Shows an attack and calculates damage.
//
//  Changes -
//	December 26th, 2007 - RaX - Created Header
//------------------------------------------------------------------------------
procedure TBeing.Attack(
	ATargetID					: LongWord;
	AttackContinuous	: Boolean;
	JustAttacked			: Boolean
);
var
	idxY							: integer;
	idxX							: integer;
	BeingIdx					: integer;
	ABeing						: TBeing;
	ATarget						: TBeing;
	Pass							: Boolean;
//	AMoveDelay				: LongWord;
	AnAttackDelay			: LongWord;
	CriticalSection		: TCriticalSection;
	Found							: Boolean;
	Parameters				: TParameterList;
	spd       : LongWord;
begin
	Found := false;
	CriticalSection := TCriticalSection.Create;

	try
		//Try to find the target if it's in range of us.
		//Needs range implemented here in place of the 1
		if GetTargetIfInRange(ATargetID, 1, ATarget) then
		begin
			//If we found the target, then we pass...but if we're looking at a character...
			Pass := TRUE;
			if ATarget is TCharacter then
			begin
				//We check to see if the character is either dead or playing dead, to see if
				//they are able to be targetted.
				Pass := NOT (TCharacter(ATarget).BeingState in [BeingDead, BeingPlayDead]);
			end;

			//Clear movement events, we cannot move and attack at the same time.
			EventList.DeleteMovementEvents;

			if Pass then
			begin
				//Call calculate damage routine and apply damage here.
				
				//show character attack motion
				Parameters := TParameterList.Create;
				Parameters.AddAsLongWord(1, AttackDelay);
				Parameters.AddAsLongWord(2, TargetID);
				Parameters.AddAsLongWord(3, 0);//Damage, right hand
				Parameters.AddAsLongWord(4, 0);//Damage, left hand
				Parameters.AddAsLongWord(5, 1);//Number of divisions
				Parameters.AddAsLongWord(6, self.ID);//this being's ID
				AreaLoop(ShowAttack, false, Parameters);//show the attack
				Parameters.Free;

				//if we're continually attacking then add a new attack event to replace this one
				if AttackContinuous = true then
				begin
					EventList.Add(
						TAttackEvent.Create(GetTick+AttackDelay, self, ATarget, TRUE)
					);
				end;
			end;

		end else
		begin
			//More temporary code, gotta figure out a better way to do this stuff...
			//all this nasty loop code does is find a target that has moved out of range
			//so we can walk to it and attempt to attack it again.
			//it then creates a new attack event.
			for idxY := Max(0,Position.Y-MainProc.ZoneServer.Options.CharShowArea) to Min(Position.Y+MainProc.ZoneServer.Options.CharShowArea, MapInfo.Size.Y-1) do
			begin
				for idxX := Max(0,Position.X-MainProc.ZoneServer.Options.CharShowArea) to Min(Position.X+MainProc.ZoneServer.Options.CharShowArea, MapInfo.Size.X-1) do
				begin
					for BeingIdx := MapInfo.Cell[idxX][idxY].Beings.Count -1 downto 0 do
					begin
						if MapInfo.Cell[idxX][idxY].Beings.Objects[BeingIdx] is TBeing then
						begin
							if MapInfo.Cell[idxX][idxY].Beings.Objects[BeingIdx] is TBeing then
							begin
								ABeing := MapInfo.Cell[idxX][idxY].Beings.Objects[BeingIdx] as TBeing;
								if ABeing.ID = ATargetID then
								begin
									CriticalSection.Enter;
									EventList.DeleteMovementEvents;
									TargetID := ATargetID;
									ATarget := ABeing;
									PathIndex := 0;
									writeln('[1]',Position.X,' ',Position.Y);
									writeln('[2]',ABeing.Position.X,' ',ABeing.Position.Y);
									if GetPath(Position, ABeing.Position, Path) then
									begin
										//We've gotta figure out a way to do this without having
										//being-conditional code in tbeing.
										if self IS TCharacter then
										begin
											writeln('[3]',Path[Path.Count-1].X,' ',Path[Path.Count-1].Y);
											ZoneSendWalkReply(TCharacter(self), Path[Path.Count-1]);
										end;

										ShowBeingWalking;

										if (Direction in Diagonals) then
										begin
											spd := Speed * 3 DIV 2;
										end else
										begin
											spd := Speed;
										end;

										//If we just attacked, add events with a bit more delay
										if (JustAttacked) then
										begin
											MoveTick := GetTick + AttackDelay + (spd DIV 2);
											AnAttackDelay := GetTick + AttackDelay + Speed * Word(Max(Path.Count,0));
										end else
										begin
											MoveTick := GetTick + (spd DIV 2);
											AnAttackDelay := GetTick + Speed * Word(Max(Path.Count,0));
										end;
										EventList.Add(
											TMovementEvent.Create(MoveTick, self)
										);

										EventList.Add(
											TAttackEvent.Create(AnAttackDelay, self, ATarget, FALSE)
										);
									end;
									CriticalSection.Leave;
									break;
								end;
							end;
						end;
					end;
					if(Found) then
						break;
				end;
				if(Found) then
					break;
			end;
		end;
	finally
		CriticalSection.Free;
	end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//ShowEffect                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//		Send effect packet
//
//	Changes-
//		[2007/11/24] Aeomin - Created.
//------------------------------------------------------------------------------
procedure TBeing.ShowEffect(EffectID:LongWord);
var
	ParameterList : TParameterList;
begin
	ParameterList := TParameterList.Create;
	ParameterList.AddAsLongWord(1,EffectID);
	AreaLoop(Effect, False, ParameterList);
	ParameterList.Free;
end;{ShowEffect}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//ShowEmotion                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//		Send emote packet
//
//	Changes-
//		[2008/03/12] Tsusai - Created.
//------------------------------------------------------------------------------
procedure TBeing.ShowEmotion(EmotionID:Byte);
var
	ParameterList : TParameterList;
begin
	ParameterList := TParameterList.Create;
	ParameterList.AddAsLongWord(1,EmotionID);
	AreaLoop(Emotion, False, ParameterList);
	ParameterList.Free;
end;

//------------------------------------------------------------------------------
//Death                                                                PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//		Fires when character dead.
//
//	Changes-
//		[2007/12/28] Aeomin - Created.
//------------------------------------------------------------------------------
procedure TBeing.Death;
begin
	if HP > 0 then
		fHP := 0;
end;{Death}
//------------------------------------------------------------------------------


(*- Cons ----------------------------------------------------------------------*
TBeing.Create
--------------------------------------------------------------------------------
Overview:
--

Creates our TBeing.

--
Post:
	EventList and Path lists are both created and initialized.

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/02/27] RaX - Created Header
[2007/04/28] CR - Altered Comment Header.  Added comment regarding inherited
	behavior.
*-----------------------------------------------------------------------------*)
Constructor TBeing.Create;
begin
	inherited;
	//Set inherited properties AFTER inherited call - ditto for creating owned
	//objects

	EventList := TEventList.Create(TRUE);
	Path := TPointList.Create;
End; (* Cons TBeing.Create
*-----------------------------------------------------------------------------*)


(*- Dest ----------------------------------------------------------------------*
TBeing.Destroy

--
Overview:
--
	Cleans up EventList and Path objects before the ancestor frees up its owned
resources.

--
Pre:
	EventList and Path are NON-NIL Objects
Post:
	EventList and Path are freed.

--
Revisions:
--
[2007/02/27] RaX - Created Header
[2007/04/28] CR - Altered header, added a better description.  Defined Pre and
	Post Conditons.  Added a comment stating that the inherited call must come
	last.  Bugfix: moved inherited call last so ancestor's cleanup happens after
	the EventList/Path are freed.
[yyyy/mm/dd] <Author> - <Comment>
*-----------------------------------------------------------------------------*)
Destructor TBeing.Destroy;
Begin
	//Pre
	Assert(Assigned(EventList), 'Pre: EventList is NIL');
	Assert(Assigned(Path), 'Pre: Path is NIL');
	//--

	EventList.Free;
	Path.Free;

	//Always clean up your owned objects/memory first, then call ancestor.
	inherited;
End;(* Dest TBeing.Destroy
*-----------------------------------------------------------------------------*)


//------------------------------------------------------------------------------
//SetCharaState                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets Character State
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		March 12th, 2007 - Aeomin - Created Header
//
//------------------------------------------------------------------------------
procedure TBeing.SetBeingState(
	Value : TBeingState
);
var
	OldState : TBeingState;
begin
	OldState := fBeingState;
	fBeingState := Value;

	if ZoneStatus = isOnline then
	begin
		if (fBeingState = BeingSitting) AND (OldState = BeingStanding) then
		begin
			AreaLoop(ShowSitStand, FALSE);
		end else
		if (fBeingState = BeingStanding) AND (OldState = BeingSitting) then
		begin
			AreaLoop(ShowSitStand, FALSE);
		end else
		if (fBeingState = BeingDead) then
		begin
			AreaLoop(ShowDeath, FALSE);
		end;
	end;

end;{SetCharaState}
//------------------------------------------------------------------------------

procedure TBeing.SetJID(
		Value : Word
	);
begin
	fJID := EnsureRange(Value, 0, High(Word));
end;

procedure TBeing.SetBaseLV(
		Value : Word
	);
begin
	fBaseLV := EnsureRange(Value, 0, High(Word));
end;

procedure TBeing.SetJobLV(
		Value : Word
	);
begin
	fJobLV := EnsureRange(Value, 0, High(Word));
end;

procedure TBeing.SetBaseEXP(
		Value : LongWord
	);
begin
	fBaseEXP := EnsureRange(Value, 0, High(LongWord));
end;

procedure TBeing.SetJobEXP(
		Value : LongWord
	);
begin
	fJobEXP := EnsureRange(Value, 0, High(LongWord));
end;

procedure TBeing.SetZeny(
		Value : Integer
	);
begin
	fZeny := EnsureRange(Value, 0, High(Integer));
end;


(*- Function ------------------------------------------------------------------*
TBeing.GetBaseStats
--------------------------------------------------------------------------------
Overview:
--

	Returns the given base stat at Index.  Development-time Asserts included for
range checking.

--
Pre:
	Index must be between STR..LUK

--
Revisions:
--
[2007/04/28] CR - Added Comment Header. Added precondition for Index range.
[yyyy/mm/dd] <Author> - <Comment>
*-----------------------------------------------------------------------------*)
Function  TBeing.GetBaseStats(
	const
		Index : Byte
	) : Integer;
Begin
	//Pre
	Assert(InRange(Index, STR, LUK), 'Pre: Index not in range for ParamBase.');
	//--

	Result := fParamBase[Index];
End; (* Func TBeing.GetBaseStats
*-----------------------------------------------------------------------------*)


(*- Procedure -----------------------------------------------------------------*
TBeing.SetBaseStats
--------------------------------------------------------------------------------
Overview:
--

	Sets the given Value for the base stat at Index.  Development-time Asserts
used for checking Index range.

--
Pre:
	Index must be within STR..LUK

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/04/28] CR - Added Comment Header. Added precondition for Index range.
*-----------------------------------------------------------------------------*)
Procedure TBeing.SetBaseStats(
	const
		Index: Byte;
	const
		Value: Integer
	);
Begin
	//Pre
	Assert(InRange(Index, STR, LUK), 'Pre: Index not in range for ParamBase.');
	//--

	fParamBase[Index] := EnsureRange(Value, 0, 9999);
End; (* Proc TBeing.SetBaseStats
*-----------------------------------------------------------------------------*)

Procedure TBeing.SetMaxHP(Value : LongWord);
Begin
	fMaxHP := Value;
End; (* Proc TBeing.SetMaxHP
*-----------------------------------------------------------------------------*)

Procedure TBeing.SetHP(Value : LongWord);
Begin
	fHP := Value;
End; (* Proc TBeing.SetHP
*-----------------------------------------------------------------------------*)
procedure TBeing.SetMaxSP(Value : word); begin fMaxSP := Value; end;
procedure TBeing.SetSP(Value : word); begin fSP := Value; end;
Procedure TBeing.SetStatus(Value : word); begin fStatus := Value; end;
Procedure TBeing.SetAilments(Value : word); begin fAilments := Value; end;
Procedure TBeing.SetOption(Value : word); begin fOption := Value; end;

procedure TBeing.SetSpeed(Value : Word); begin fSpeed := Value; end;

procedure TBeing.SetASpeed(Value : Word);
begin
	fASpeed := Value;
end;
// Mob Minimum and Maximum Attack [Spre]
procedure TBeing.SetMinimumHit(Value : Integer);
begin
	fMinimumHit := Value;
end;

procedure TBeing.SetMaximumHit(Value : Integer);
begin
	fMaximumHit := Value;
end;
// Mob attack delays and motions [Spre]
procedure TBeing.SetAttackDmgTime(Value	:	Integer);
begin
	fAttackDmgTime	:=	Value;
end;

procedure TBeing.SetAttack_Motion(Value	:	Integer);
begin
	fAttack_Motion	:=	Value;
end;

//Mob Sight Range [Spre]
procedure TBeing.SetEnemySight(Value	:	Byte);
begin
	fEnemySight	:=	Value;
end;

//Mob Property  [Spre]
procedure TBeing.SetElement(Value	:	Word);
begin
	fElement	:=	Value;
end;


(*- Procedure -----------------------------------------------------------------*
TBeing.CalcSpeed
--------------------------------------------------------------------------------
Overview:
--

Sets Speed to default of 150.

--
Revisions:
--
(Format: [yyyy/mm/dd] <Author> - <Comment>)
[2007/04/28] CR - Added Comment Header
*-----------------------------------------------------------------------------*)
Procedure TBeing.CalcSpeed;
Begin
	Speed := 150;
End; (* Proc TBeing.CalcSpeed
*-----------------------------------------------------------------------------*)


//------------------------------------------------------------------------------
//GetHpPercent                                                          FUNCTION
//------------------------------------------------------------------------------
//  What it does-
//	Get current HP percentage
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2007/12/31] Aeomin - Added
//
//------------------------------------------------------------------------------
function TBeing.GetHpPercent: Byte;
begin
	Result := Trunc(HP/MaxHP*100);
end;{GetHpPercent}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHpPercent                                                          FUNCTION
//------------------------------------------------------------------------------
//  What it does-
//	Set current HP percentage
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2007/12/31] Aeomin - Added
//
//------------------------------------------------------------------------------
procedure TBeing.SetHPPercent(Value : Byte);
begin
	Value := EnsureRange(Value,0,100);
	HP    := Trunc(Value/100*MaxHP);
end;{SetHPPercent}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetSpPercent                                                          FUNCTION
//------------------------------------------------------------------------------
//  What it does-
//	Get current SP percentage
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2007/12/31] Aeomin - Added
//
//------------------------------------------------------------------------------
function TBeing.GetSpPercent: Byte;
begin
	Result := Trunc(SP/MaxSP*100);
end;{GetHpPercent}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetSpPercent                                                          FUNCTION
//------------------------------------------------------------------------------
//  What it does-
//	Set current SP percentage
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2007/12/31] Aeomin - Added
//
//------------------------------------------------------------------------------
procedure TBeing.SetSPPercent(Value : Byte);
begin
	Value := EnsureRange(Value,0,100);
	SP    := Trunc(Value/100*MaxSP);
end;{SetHPPercent}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RemoveFromMap                                                       Procedure
//------------------------------------------------------------------------------
//  What it does-
//	Removes this being from the map
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2008/01/02] RaX - Created
//
//------------------------------------------------------------------------------
procedure TBeing.RemoveFromMap;
var
	Index : Integer;
begin
	if MapInfo.PointInRange(Position) then
	begin
		Index := MapInfo.Cell[Position.X][Position.Y].Beings.IndexOf(ID);
		if Index <> -1 then
		begin
			MapInfo.Cell[Position.X][Position.Y].Beings.Delete(
				Index
			);
		end;
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//AddToMap                                                       Procedure
//------------------------------------------------------------------------------
//  What it does-
//	Adds this being to the map
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2008/01/02] RaX - Created
//
//------------------------------------------------------------------------------
procedure TBeing.AddToMap;
begin
	if MapInfo.PointInRange(Position) then
	begin
		if MapInfo.Cell[Position.X][Position.Y].Beings.IndexOf(ID) = -1 then
		begin
			MapInfo.Cell[Position.X][Position.Y].Beings.AddObject(ID, self);
		end;
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//CalcASpeed                                                      Procedure
//------------------------------------------------------------------------------
//  What it does-
//	Attack speed calculation
// --
//   Pre:
//	TODO
//   Post:
//	TODO
// --
//	Changes -
//		[2008/01/06] RaX - Created
//
//------------------------------------------------------------------------------
procedure TBeing.CalcASpeed;
begin
	ASpeed := EnsureRange(
		200-(Round((250-ParamBase[AGI]-(ParamBase[DEX]/4))*(200{-ASPD Base}-150)/250)) {* DelayDecrease}
	, 0, ASPEED_MAX);
	AttackDelay := 20*(200-ASpeed);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetPath()                                                      FUNCTION
//------------------------------------------------------------------------------
//  What it does -
//      This is a pathing algorithm that I like to call a "wave" algorithm
//    because of the way it propagates out from the starting point much like the
//    behavior of a wave. It finds paths by searching all possible paths to a
//    certain extent and using the one that arrives at the target first, the
//    shortest path.
//
//  Changes -
//    October 30th, 2006 - RaX - Created.
//    November 1st, 2006 - Tsusai - moved the check for passability into
//     IsBlocked. Changed to a boolean function and our path is assigned via a
//     TPointList parameter passed by address, APath.
//		April 29th, 2007 - RaX - Commented this routine thoroughly, to allow others
//		 to understand it and perhaps learn something =)
//		January 9th, 2008 - RaX - Moved to TBeing
//
//------------------------------------------------------------------------------
function TBeing.GetPath(
	const StartPoint  : TPoint;
	const EndPoint    : TPoint;
	var APath : TPointList
) : boolean;

var
	AFloodList				: TList;//Our main flood list, contains FloodItems
	AFloodItem				: TFloodItem;
	NewFloodItem			: TFloodItem;//Created with supplied data to test if an item
																	//is valid. If it is, it is added to the floodlist
	Index							: Integer;
	WriteIndex        : Integer;
	DirectionIndex		: Integer;
	PossiblePosition	: TPoint;
	CharClickArea			: Integer;

	CostTick					: Cardinal;

	XMod							: Integer;//The modifier between AnArea(a piece of the map)
															//and the real X Index for that cell.
	YMod							: Integer;//y version of XMod

	AnArea						: TGraph;//A section of the map used for keeping track of
															//where a flood item is.
	AnAreaSize				: TPoint;

	Done							: Boolean;
	EndPointMod				: TPoint;

	BeingIndex				: Integer;

begin
	//Initialize data
	Result				:= FALSE;
	Done 					:= FALSE;
	CostTick			:=  0;
	CharClickArea := MainProc.ZoneServer.Options.CharClickArea;
	AFloodItem		:= TFloodItem.Create;
	AFloodList		:= TList.Create;

	//grab our area from the map
	XMod := Max(EndPoint.X-CharClickArea, 0);//get our modifiers
	YMod := Max(EndPoint.Y-CharClickArea, 0);
	//copy the X axis' cells from the map from the modifier to CharClickAres*2+1
	//(33 by default. 16 away from the character in any direction + 1 for the
	//space the character is on)
	AnArea := Copy(MapInfo.Cell, XMod, Min((CharClickArea*2)+1, MapInfo.Size.X-XMod));
	for Index := 0 to Length(AnArea)-1 do
	begin
		//copy each of the Y axis' cells in the area constraints
		AnArea[Index] := Copy(MapInfo.Cell[XMod+Index], YMod, Min((CharClickArea*2)+1, MapInfo.Size.Y-YMod));
	end;
	//Grab the length of the area's X+Y axis' as a TPoint
	AnAreaSize := Point(Length(AnArea),Length(AnArea[0]));

	//Get the endpoint's position in AnArea, we are searching from the end to the
	//start to emulate the client.
	EndPointMod := Point(StartPoint.X-XMod,StartPoint.Y-YMod);

	//initialize our first flood item, the start point is the endpoint that we're
	//searching. This is to emulate the client.
	AFloodItem.Position.X := EndPoint.X-XMod;
	AFloodItem.Position.Y := EndPoint.Y-YMod;
	AFloodItem.Path.Add(AnArea[AFloodItem.Position.X][AFloodItem.Position.Y].Position);
	AFloodItem.Cost := 0;
	AFloodList.Add(AFloodItem);

	//While we havn't found the endpoint and we havn't run out of cells to check do
	While (NOT Result) AND (NOT Done) do
	begin
		//start from the end of the list, and go to the beginning(so removing items
		//is FAST)
		Index := AFloodList.Count;
		//While we've still got items on our floodlist to search and we havn't found
		//the endpoint, do.
		While (Index > 0) AND (NOT Result) do
		begin
			//decrease the index and grab a flood item for spawning new items in each
			//direction
			Dec(Index);
			AFloodItem := AFloodList[Index];
			//To see if this flood item is ready to propagate, we check it's weight.
			//If this "Cost" weight is less than the cost we are currently at then we
			//propagate the flood item. Increasing costs are a problem many large
			//corporations face today! It's a good thing here.
			if AFloodItem.Cost <= CostTick then
			begin
				//Loop backwards through the directions, emulating gravity's client.
				DirectionIndex := 8;
				//While there are still directions to search and we havn't found the endpoint,
				//do
				While (DirectionIndex > 0) AND (NOT Result) do
				begin
					//decrease our direction index(remember, we started at 8 for a reason!)
					Dec(DirectionIndex);
					//grab our possible position
					PossiblePosition.X := AFloodItem.Position.X + Directions[DirectionIndex].X;
					PossiblePosition.Y := AFloodItem.Position.Y + Directions[DirectionIndex].Y;

					//Make sure the new point is inside our search boundaries.
					if	(PossiblePosition.X < AnAreaSize.X) AND
							(PossiblePosition.X >= 0)						AND
							(PossiblePosition.Y < AnAreaSize.Y) AND
							(PossiblePosition.Y >= 0)						then
					begin
						//make sure we can move to the new point.
						if NOT MapInfo.IsBlocked(PossiblePosition, AnArea) then
						begin
							//Create and add our new flood item
							NewFloodItem := TFloodItem.Create;

							NewFloodItem.Path.Assign(AFloodItem.Path);

							NewFloodItem.Position		:= PossiblePosition;
							//calculate the cost of this new flood item.
							if not (abs(Directions[DirectionIndex].X) = abs(Directions[DirectionIndex].Y)) then
							begin
								NewFloodItem.Cost	:= AFloodItem.Cost + 5;
							end else begin
								NewFloodItem.Cost	:= AFloodItem.Cost + 7;
							end;
							//add the item to the flood list.
							AFloodList.Add(NewFloodItem);

							AnArea[NewFloodItem.Position.X][NewFloodItem.Position.Y].Attribute := 1;
							//check to see if we've found the end point.
							if PointsEqual(NewFloodItem.Position, EndPointMod) then
							begin
								APath.Clear;

								//if the destination point has beings in it, remove it from the list
								//this is for attacking and other functions who move to the mob's
								//position, it's our responsibility to prevent us from standing on
								//them =P
								for BeingIndex := 0 to MapInfo.Cell[NewFloodItem.Path[0].X][NewFloodItem.Path[0].Y].Beings.Count - 1 do
								begin
									if MapInfo.Cell[NewFloodItem.Path[0].X][NewFloodItem.Path[0].Y].Beings.Objects[BeingIndex] is TBeing then
									begin
										NewFloodItem.Path.Delete(0);
										break;
									end;
								end;

								{if Cell[NewFloodItem.Path[0].X][NewFloodItem.Path[0].Y].Beings.Count > 0 then
								begin
									NewFloodItem.Path.Delete(0);
								end;}

								if NewFloodItem.Path.Count > 0 then
								begin
									//We've found it!
									Result	:= TRUE;
									for WriteIndex := NewFloodItem.Path.Count -1 downto 0 do
									begin
										APath.Add(NewFloodItem.Path[WriteIndex]);
									end;
								end;

								(*Tsusai Mar 16 2007: The Assign does copy..but the problem is
								that the NewFloodItem.Path starts from the destination and goes
								to the source.  So the server never updates the character position
								because we finish walking where we start.
								{//APath.Assign(NewFloodItem.Path);
								for WriteIndex := 0 to APath.Count -1 do
								begin
									//Output path that is made.
									writeln(format('Path index %d - Pt (%d,%d)',[WriteIndex,APath[WriteIndex].X,APath[WriteIndex].y]));
								end;}*)

							end else
							begin
								//If we've not found it, add the new point to the list(we're searching backwards!)
								NewFloodItem.Path.Add(AnArea[PossiblePosition.X][PossiblePosition.Y].Position);
							end;
						end;
					end;
				end;
				//free the flood item.
				TFloodItem(AFloodList[Index]).Free;
				//remove it from the list.
				AFloodList.Delete(Index);
			end;
		end;
		//if we've run out of cells to check, die.
		if (AFloodList.Count = 0) then
		begin
			Done := TRUE;
		end;
		//increment our cost tick
		Inc(CostTick);
	end;

	//Free our lists + items
	for Index := 0 to AFloodList.Count - 1 do
	begin
		TFloodItem(AFloodList[Index]).Free;
	end;
	AFloodList.Free;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//InPointRange                                                          FUNCTION
//------------------------------------------------------------------------------
//  What it does -
//		Compare TargetPoint with Tbeing's position, see if it's in viewable range
//
//  Changes -
//		[2008/03/08] Aeomin - Created.
//
//------------------------------------------------------------------------------
function TBeing.InPointRange(const TargetPoint:TPoint):Boolean;
var
	Radius : Word;
begin
	Radius := MainProc.ZoneServer.Options.CharShowArea;
	Result := (Abs(TargetPoint.X - Position.X) <= Radius) AND
		(Abs(TargetPoint.Y - Position.Y) <= Radius);

end;{InPointRange}
//------------------------------------------------------------------------------
end.
