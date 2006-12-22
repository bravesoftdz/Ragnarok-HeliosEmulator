//------------------------------------------------------------------------------
//Character                                                                UNIT
//------------------------------------------------------------------------------
//	What it does-
//			Holds our TCharacter Class
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
unit Character;

interface
uses
	//IDE
	Types,
	//Helios
	Account,
	GameConstants,
	//Third Party
	IdContext;

//------------------------------------------------------------------------------
//TCharacter                                                          PROCEDURE
//------------------------------------------------------------------------------
	type TCharacter = class
	private
		fCharacterNumber  : Byte;
		fName             : String;
		fJID              : Word;
		fBaseLV           : Byte;
		fJobLV            : Byte;
		fBaseEXP          : Byte;
		fJobEXP           : Byte;
		fZeny             : Cardinal;
		fParamBase        : Array[STR..LUK] of Byte;
		fMaxHP            : Word;
		fHP               : Word;
		fMaxSP            : Word;
		fSP               : Word;
		fStatusPts        : Word;
		fSkillPts         : Word;
		fOption           : Word;
		fKarma            : Word;
		fManner           : Word;
		fPartyID          : Cardinal;
		fGuildID          : Cardinal;
		fPetID            : Cardinal;
		fHair             : Word;
		fHairColor        : Word;
		fClothesColor     : Word;
		fWeapon           : Word;
		fShield           : Word;
		fHeadTop          : Word;
		fHeadMid          : Word;
		fHeadBottom       : Word;
		fMap              : String;
		fMapPt            : TPoint;
		fSaveMap          : String;
		fSaveMapPt        : TPoint;
		fPartnerID        : Cardinal;
		fParentID1        : Cardinal;
		fParentID2        : Cardinal;
		fBabyID           : Cardinal;
		fOnline           : Byte;
		fHomunID          : Cardinal;

		fDataChanged      : Boolean; //For timed save procedure to activate.
		fTimeToSave       : TDateTime;

	protected
		procedure SetSaveTime(Value : boolean);

		procedure SetCharaNum(Value : byte);
		procedure SetName(Value : string);
		procedure SetClass(Value : word);
		procedure SetBaseLV(Value : byte);
		procedure SetJobLV(Value : byte);
		procedure SetBaseEXP(Value : byte);
		procedure SetJobEXP(Value : byte);
		procedure SetZeny(Value : Cardinal);
		function  GetBaseStats(Index : Byte) : byte;
		procedure SetBaseStats(Index: byte; Value: byte);
		procedure SetMaxHP(Value : word);
		procedure SetHP(Value : word);
		procedure SetMaxSP(Value : word);
		procedure SetSP(Value : word);
		Procedure SetOption(Value : word);
		Procedure SetKarma(Value : word);
		Procedure SetManner(Value : word);
		Procedure SetPartyID(Value : cardinal);
		Procedure SetGuildID(Value : cardinal);
		Procedure SetPetID(Value : cardinal);
		Procedure SetHair(Value : word);
		Procedure SetHairColor(Value : word);
		Procedure SetClothesColor(Value : word);
		Procedure SetWeapon(Value : word);
		Procedure SetShield(Value : word);
		Procedure SetHeadTop(Value : word);
		Procedure SetHeadMid(Value : word);
		Procedure SetHeadBottom(Value : word);
		procedure SetStatusPts(Value : word);
		procedure SetSkillPts(Value : word);
		procedure SetMap(Value : string);
		procedure SetMapPt(Value : TPoint);
		procedure SetSMap(Value : string);
		procedure SetSMapPt(Value : TPoint);
		procedure SetPartnerID(Value : Cardinal);
		procedure SetParentID1(Value : Cardinal);
		procedure SetParentID2(Value : Cardinal);
		procedure SetBabyID(Value : Cardinal);
		procedure SetOnline(Value : Byte);
		procedure SetHomunID(Value : Cardinal);

	public

		CID : Cardinal;
		ID  : Cardinal; //Account ID
		Speed : word; //Not in MySQL...odd...
		Account : TAccount;

		ClientVersion : byte;
		ClientInfo : TIdContext;

		property DataChanged : boolean  read fDataChanged write SetSaveTime;
		//For timed save procedure to activate.

		property CharaNum  : Byte       read fCharacterNumber write SetCharaNum;
		property Name      : string     read fName write SetName;
		property JID       : Word       read fJID write SetClass;
		property BaseLV    : Byte       read fBaseLV write SetBaseLV;
		property JobLV     : Byte       read fJobLV write SetJobLV;
		property BaseEXP   : Byte       read fBaseEXP write SetBaseEXP;
		property JobEXP    : Byte       read fJobEXP write SetJobEXP;
		property Zeny      : Cardinal   read fZeny write SetZeny;
		property ParamBase[Index : byte] : byte read GetBaseStats write SetBaseStats;
		property MaxHP     : Word       read fMaxHP write SetMaxHP;
		property HP        : Word       read fHP write SetHP;
		property MaxSP     : Word       read fMaxSP write SetMaxSP;
		property SP        : Word       read fSP write SetSP;
		property StatusPts : Word       read fStatusPts write SetStatusPts;
		property SkillPts  : Word       read fSkillPts write SetSkillPts;
		property Option    : Word       read fOption write SetOption;
		property Karma     : Word       read fKarma write SetKarma;
		property Manner    : Word       read fManner write SetManner;
		property PartyID   : Cardinal   read fPartyID write SetPartyID;
		property GuildID   : Cardinal   read fGuildID write SetGuildID;
		property PetID     : Cardinal   read fPetID write SetPetID;
		property Hair      : Word       read fHair write SetHair;
		property HairColor : Word       read fHairColor write SetHairColor;
		property ClothesColor: Word     read fClothesColor write SetClothesColor;
		property Weapon    : Word       read fWeapon write SetWeapon;
		property Shield    : Word       read fShield write SetShield;
		property HeadTop   : Word       read fHeadTop write SetHeadTop;
		property HeadMid   : Word       read fHeadMid write SetHeadMid;
		property HeadBottom: Word       read fHeadBottom write SetHeadBottom;
		property Map       : string     read fMap write SetMap;
		property Point     : TPoint     read fMapPt write SetMapPt;
		property SaveMap   : string     read fSaveMap write SetSMap;
		property SavePoint : TPoint     read fSaveMapPt write SetSMapPt;
		property PartnerID : Cardinal   read fPartnerID write SetPartnerID;
		property ParentID1 : Cardinal   read fParentID1 write SetParentID1;
		property ParentID2 : Cardinal   read fParentID2 write SetParentID2;
		property BabyID    : Cardinal   read fBabyID write SetBabyID;
		property Online    : Byte       read fOnline write SetOnline;
		property HomunID   : Cardinal   read fHomunID write SetHomunID;

		procedure CalcMaxHP;

	end;{TCharacter}
//------------------------------------------------------------------------------

implementation
uses
	//IDE
	SysUtils
	//Helios
	;

//------------------------------------------------------------------------------
//SetSaveTime                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the last time the character was saved to the database.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetSaveTime(Value : boolean);
Const
	HoursPerDay   = 24;
	MinsPerHour   = 60;
	MinsPerDay    = HoursPerDay * MinsPerHour;
	MinInterval   = 5; //Time set at 5 min
begin
	if Value and not fDataChanged then begin
		fDataChanged  := TRUE;
		fTimeToSave   := ((Now * MinsPerDay) + MinInterval) / MinsPerDay;
	end;
end;{SetSaveTime}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetCharaNum                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the CharaNum to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetCharaNum(Value : byte);
begin
	DataChanged       := TRUE;
	fCharacterNumber  := Value;
end;{SetCharaNum}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetName                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Name to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetName(Value : string);
begin
	DataChanged := TRUE;
	fName       := Value;
end;{SetName}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetClass                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Class to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetClass(Value : Word);
begin
	DataChanged := TRUE;
	fJID        := Value;
end;{SetClass}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetBaseLV                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the BaseLV  to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetBaseLV(Value : byte);
begin
	DataChanged := TRUE;
	fBaseLV     := Value;
end;{SetBaseLV}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetJobLV                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Name to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetJobLV(Value : byte);
begin
	DataChanged := TRUE;
	fJobLV      := Value;
end;{SetJobLV}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetBaseEXP                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the BaseEXP to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetBaseEXP(Value : byte);
begin
	DataChanged := TRUE;
	fBaseEXP    := Value;
end;{SetBaseEXP}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetJobEXP                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets JobEXP to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetJobEXP(Value : byte);
begin
	DataChanged := TRUE;
	fJobEXP     := Value;
end;{SetJobEXP}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetZeny                                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Zeny to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetZeny(Value : Cardinal);
begin
	DataChanged := TRUE;
	fZeny       := Value;
end;{SetZeny}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetBaseStats                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Gets the base stat at Index.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
function TCharacter.GetBaseStats(Index : Byte) : Byte;
begin
	Result := fParamBase[Index];
end;{GetBaseStats}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetBaseStats                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets Base Stat at Index to Value.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetBaseStats(Index, Value: Byte);
begin
	DataChanged       := TRUE;
	fParamBase[Index] := Value;
end;{SetBaseStats}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetMaxHP                                                            PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the MaxHP to Value.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetMaxHP(Value : word);
begin
	DataChanged := TRUE;
	fMaxHP      := Value;
end;{SetMaxHP}
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//SetHP                                                               PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HP to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHP(Value : word);
begin
	DataChanged := TRUE;
	fHP         := Value;
end;{SetHP}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetMaxSP                                                            PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the MaxSP to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetMaxSP(Value : word);
begin
	DataChanged := TRUE;
	fMaxSP      := Value;
end;{SetMaxSP}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetName                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the SP to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetSP(Value : word);
begin
	DataChanged := TRUE;
	fSP         := Value;
end;{SetSP}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetStatusPts                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the StatusPoints to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetStatusPts(Value : Word);
begin
	DataChanged := TRUE;
	fStatusPts  := Value;
end;{SetStatusPts}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetSkillPts                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the SkillPoints to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetSkillPts(Value : Word);
begin
	DataChanged := TRUE;
	fSkillPts   := Value;
end;{SetSkillPts}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetOption                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Option to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetOption(Value : word);
begin
	DataChanged := TRUE;
	fOption     := Value;
end;{SetOption}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetKarma                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Karma to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetKarma(Value : word);
begin
	DataChanged := TRUE;
	fKarma      := Value;
end;{SetName}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetManner                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Manner to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetManner(Value : word);
begin
	DataChanged := TRUE;
	fManner     := Value;
end;{SetManner}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetPartyID                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the PartyID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetPartyID(Value : cardinal);
begin
	DataChanged := TRUE;
	fPartyID    := Value;
end;{SetPartyID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetGuildID                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the GuildID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetGuildID(Value : cardinal);
begin
	DataChanged := TRUE;
	fGuildID    := Value;
end;{SetGuildID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetPetID                                                            PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the PetID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetPetID(Value : cardinal);
begin
	DataChanged := TRUE;
	fPetID      := Value;
end;{SetPetID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHair                                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Hair to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHair(Value : word);
begin
	DataChanged := TRUE;
	fHair       := Value;
end;{SetHair}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHairColor                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HairColor to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHairColor(Value : word);
begin
	DataChanged := TRUE;
	fHairColor  := Value;
end;{SetHairColor}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetClothesColor                                                     PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the ClothesColor to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetClothesColor(Value : word);
begin
	DataChanged   := TRUE;
	fClothesColor := Value;
end;{SetClothesColor}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetWeapon                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Weapon to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetWeapon(Value : word);
begin
	DataChanged := TRUE;
	fWeapon     := Value;
end;{SetWeapon}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetShield                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Shield to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetShield(Value : word);
begin
	DataChanged := TRUE;
	fShield     := Value;
end;{SetShield}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHeadTop                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HeadTop to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHeadTop(Value : word);
begin
	DataChanged := TRUE;
	fHeadTop    := Value;
end;{SetHeadTop}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHeadMid                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HeadMid to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHeadMid(Value : word);
begin
	DataChanged := TRUE;
	fHeadMid    := Value;
end;{SetHeadMid}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHeadBottom                                                       PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HeadBottom to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHeadBottom(Value : word);
begin
	DataChanged := TRUE;
	fHeadBottom := Value;
end;{SetHeadBottom}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetMap                                                              PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Map to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetMap(Value : string);
begin
	DataChanged := TRUE;
	fMap        := Value;
end;{SetMap}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetMapPt                                                            PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the MapPt to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetMapPt(Value : TPoint);
begin
	DataChanged := TRUE;
	fMapPt      := Value;
end;{SetMapPt}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetSMap                                                             PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the SMap(SaveMap) to Value. Also, lets our object know that data
//    has changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetSMap(Value : string);
begin
	DataChanged := TRUE;
	fSaveMap    := Value;
end;{SetSMap}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetSMapPt                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the SMapPt to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetSMapPt(Value : TPoint);
begin
	DataChanged := TRUE;
	fSaveMapPt  := Value;
end;{SetSMapPt}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetPartnerID                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the PartnerID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetPartnerID(Value : Cardinal);
begin
	DataChanged := TRUE;
	fPartnerID  := Value;
end;{SetPartnerID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetParentID                                                         PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the ParentID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetParentID1(Value : Cardinal);
begin
	DataChanged := TRUE;
	fParentID1  := Value;
end;{SetParentID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetParentID2                                                        PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the ParentID2 to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetParentID2(Value : Cardinal);
begin
	DataChanged := TRUE;
	fParentID2  := Value;
end;{SetParentID2}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetBabyID                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the BabyID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetBabyID(Value : Cardinal);
begin
	DataChanged := TRUE;
	fBabyID     := Value;
end;{SetBabyID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetOnline                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the Online to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetOnline(Value : Byte);
begin
	DataChanged := TRUE;
	fOnline     := Value;
end;{SetOnline}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetHomunID                                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Sets the HomunID to Value. Also, lets our object know that data has
//    changed.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.SetHomunID(Value : Cardinal);
begin
	DataChanged := TRUE;
	fHomunID    := Value;
end;{SetHomunID}
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//CalcMaxHP                                                           PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Calculates teh character's Maximum HP.
//
//	Changes -
//		December 22nd, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TCharacter.CalcMaxHP;
begin
end;{CalcMaxHP}
//------------------------------------------------------------------------------

end.
