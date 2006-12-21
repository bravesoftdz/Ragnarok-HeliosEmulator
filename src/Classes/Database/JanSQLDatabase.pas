//------------------------------------------------------------------------------
//JanSQLDatabase		                                                        UNIT
//------------------------------------------------------------------------------
//	What it does-
//			This is one of our database objects which enabled Helios to use a TEXT
//    Database.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
unit JanSQLDatabase;

interface
uses
	DatabaseTemplate,
	Character,
	CharaList,
	Account,
	janSQL;

//------------------------------------------------------------------------------
//TJanSQLDatabase			                                                           CLASS
//------------------------------------------------------------------------------
//	What it does-
//			This is a child class for our database object system. It allows Helios
//    to communicate with a TEXT database and houses all routines for doing so.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
type
	TJanSQLDatabase = class(TDatabaseTemplate)
	private
		Database : TjanSQL;
	public

		Constructor Create(UseGameDatabase : boolean); reintroduce; overload;
		Destructor Destroy();override;

		function GetAccount(ID    : Cardinal) : TAccount;overload;override;
		function GetAccount(Name  : string) : TAccount;overload;override;

		procedure GetAccountBanAndConnectTime(var AnAccount : TAccount); override;

		function CreateChara(
			var ACharacter : TCharacter;
			AID : Cardinal;
			NName : string
		) : boolean;override;

		procedure CreateAccount(
			const Username : string;
			const Password : string;
			const GenderChar : char
		); override;

		function GetAccountCharas(AccountID : Cardinal) : TCharacterList;override;
		function LoadChara(CharaID : Cardinal) : TCharacter;override;
		function GetChara(CharaID : Cardinal) : TCharacter;override;
		function DeleteChara(var ACharacter : TCharacter) : boolean;override;
		function CharaExists(AccountID : Cardinal; Slot : Cardinal) : Boolean;overload;override;
		function CharaExists(Name : String) : Boolean;overload;override;
		function AccountExists(UserName : String) : Boolean;override;

		procedure SaveAccount(AnAccount : TAccount);override;
		procedure SaveChara(AChara : TCharacter);override;

		Function GetBaseHP(ACharacter : TCharacter) : Cardinal;override;
		Function GetBaseSP(ACharacter : TCharacter) : Cardinal;override;
	protected
		procedure Connect(UseGameDatabase : Boolean); override;
		procedure Disconnect; override;
		function SendQuery(
			const QString : string
		) : Integer;
	end;
//------------------------------------------------------------------------------

implementation
	uses
		Types,
		GameConstants,
		Globals,
		Console,
		SysUtils,
		Classes;


//------------------------------------------------------------------------------
//TJanSQLDatabase.Create()                                          CONSTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Initializes our connection object.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//		November 13th, 2006 - Tsusai - create inherit comes first.
//
//------------------------------------------------------------------------------
Constructor TJanSQLDatabase.Create(UseGameDatabase : boolean);
begin
	inherited Create;
	Connect(UseGameDatabase);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.Destroy()                                          DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Destroys our connection object.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
Destructor TJanSQLDatabase.Destroy();
begin
	Disconnect;
	inherited;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.Disconnect()                                        Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Destroys the TEXT Connection.
//
//	Changes -
//		December 21st, 2006 - RaX - Created
//
//------------------------------------------------------------------------------
procedure TJanSQLDatabase.Disconnect;
begin
	//This tells it to save all infomation, since everything happens in memory
	SendQuery('COMMIT');
  if Assigned(Database) then Database.Free;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.Connect()                                            Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Initializes the TEXT Connection.
//
//	Changes -
//		October 5th, 2006 - RaX - Moved here from globals.
//		December 18th, 2006 - Tsusai - Modified the connect to actually...connect
//			Also FileExists doesn't work for directories, its DirectoryExists
//
//------------------------------------------------------------------------------
Procedure TJanSQLDatabase.Connect(UseGameDatabase : boolean);
var
	ResultIdentifier : Integer;
const ConnectQuery = 'Connect to ''%s''';
begin

	ResultIdentifier := 0;

	if Not Assigned(Database) then
	begin
		Database := TJanSQL.Create;
	end;

	if Not UseGameDatabase then //Access the Common database
	begin
		if DirectoryExists(ServerConfig.CommonHost) then
		begin
			ResultIdentifier := Database.SQLDirect(Format(ConnectQuery,[ServerConfig.CommonHost]));
		end else
		begin
			MainProc.Console('');
			MainProc.Console('The database at '+ServerConfig.CommonHost+' does not exist!');
			MainProc.Console('Please ensure that you have correctly configured your ini file');
		end;
	end else //Access the Game database
	begin
		if DirectoryExists(ServerConfig.GameHost) then
		begin
			ResultIdentifier := Database.SQLDirect(Format(ConnectQuery,[ServerConfig.GameHost]));
		end else
		begin
			MainProc.Console('');
			MainProc.Console('The database at '+ServerConfig.GameHost+' does not exist!');
			MainProc.Console('Please ensure that you have correctly configured your ini file');
		end;
	end;

	if ResultIdentifier = 0 then
	begin
		MainProc.Console('*****Could not open text database. Error : ' + Database.Error);
		MainProc.Console(ServerConfig.GameHost);
	end else
  begin
    Database.ReleaseRecordset(ResultIdentifier);
  end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.SendQuery()                                          Function
//------------------------------------------------------------------------------
//	What it does-
//			Sends a query to the jansql object.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//		December 18th, 2006 - Tsusai - Would not return a blank set if query failed
//			to return anything, only a nil pointer that would cause issues when read.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.SendQuery(
	const QString : string
) : Integer;
begin
	Result := Database.SQLDirect(QString);
	if Result = 0 then
	begin
		MainProc.Console('Text Query error: ' + QString);
	end;
end;//SendQuery
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.SetAccount()                                        Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Builds a taccount object from a query result.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure SetAccount(
	var AnAccount : TAccount;
	var QueryResult : TJanRecordSet
);
begin
	AnAccount := TAccount.Create;
	AnAccount.ID          := StrToInt(QueryResult.records[0].fields[0].value);
	AnAccount.Username    := QueryResult.records[0].fields[1].value;
	AnAccount.Password    := QueryResult.records[0].fields[2].value;
	//Tsusai - For Gender, we need to return the first char, thats
	//why there is a [0]
	AnAccount.Gender      := String(QueryResult.records[0].fields[4].value)[1];
	AnAccount.LoginCount  := StrToIntDef(QueryResult.records[0].fields[5].value,0);
	AnAccount.EMail       := QueryResult.records[0].fields[6].value;
	AnAccount.LoginKey[1] := StrToIntDef(QueryResult.records[0].fields[7].value,0);
	AnAccount.LoginKey[1] := StrToIntDef(QueryResult.records[0].fields[8].value,0);
	AnAccount.Level       := StrToIntDef(QueryResult.records[0].fields[9].value,0);
	AnAccount.LastIP      := QueryResult.records[0].fields[12].value;
end;//SetAccount
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.GetAccount()                               OVERLOADED FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			This function returns a TAccount type and is used for loading up an
//    account by ID.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		November 13th, 2005 - Tsusai - now calls a shared TAccount routine to
//													set the data
//		December 18th, 2006 - Tsusai - Corrected query string syntax
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.GetAccount(ID: Cardinal) : TAccount;
var
	AnAccount   : TAccount;
	Index       : Integer;
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	Result := NIL;
	//Check Memory
	if not Assigned(AccountList) then Accountlist := TStringlist.Create;
	for Index := 0 to AccountList.Count -1 do begin
		if TAccount(AccountList.Objects[Index]).ID = ID then
		begin
			Result := TAccount(AccountList.Objects[Index]);
			break;
		end;
	end;

	ResultIdentifier := SendQuery(
		Format('SELECT * FROM accounts WHERE account_id = %d',
		[ID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.recordcount = 1) then begin
		if Not Assigned(Result) then
		begin
			SetAccount(AnAccount,QueryResult);
			AccountList.AddObject(AnAccount.Username, AnAccount);
			Result := AnAccount;
		end;
		Result.ConnectUntil := ConvertMySQLTime(QueryResult.records[0].fields[11].value);
		Result.Bantime      := ConvertMySQLTime(QueryResult.records[0].fields[14].value);
	end;

	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.GetAccount()                               OVERLOADED FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			This function returns a TAccount type and is used for loading up an
//    account by Name.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		November 13th, 2005 - Tsusai - now calls a shared TAccount routine to
//													set the data
//		December 18th, 2006 - Tsusai - Corrected query syntax
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.GetAccount(Name : string) : TAccount;
var
	AnAccount   : TAccount;
	Index       : Integer;
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	Result := NIL;
	//Check Memory
	if not Assigned(AccountList) then Accountlist := TStringlist.Create;
	for Index := 0 to AccountList.Count -1 do begin
		if TAccount(AccountList.Objects[Index]).Username = Name then
		begin
			Result := TAccount(AccountList.Objects[Index]);
			break;
		end;
	end;

	ResultIdentifier := SendQuery('SELECT * FROM accounts WHERE userid = '+Name+';');
  QueryResult := Database.RecordSets[ResultIdentifier];

	if(QueryResult.RecordCount = 1) then begin
		if Not Assigned(Result) then
		begin
			SetAccount(AnAccount,QueryResult);
			AccountList.AddObject(AnAccount.Username, AnAccount);
			Result := AnAccount;
		end;
		Result.ConnectUntil := ConvertMySQLTime(QueryResult.records[0].fields[11].value);
		Result.Bantime      := ConvertMySQLTime(QueryResult.records[0].fields[14].value);
	end;

  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.GetChara()                                           FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.GetChara(CharaID : Cardinal) : TCharacter;
begin
	Result := NIL;
	if CharacterList.IndexOf(CharaID) > -1 then
	begin
		if TCharacter(CharacterList.IndexOfObject(CharaID)).CID = CharaID then
		begin
			Result := TCharacter(CharacterList.IndexOfObject(CharaID));
			Exit;
		end;
	end;
	if Result = NIL then
	begin
		Result := LoadChara(CharaID);
		if Assigned(Result) then
		begin
			CharacterList.AddObject(CharaID,Result);
		end;
	end else Result := NIL;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//TJanSQLDatabase.GetAccountCharas()                                   FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//		December 18th, 2006 - Tsusai - QueryResult now freed.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.GetAccountCharas(AccountID : Cardinal) : TCharacterList;
var
	QueryResult     : TJanRecordSet;
	ACharacterList  : TCharacterList;
	Index           : Integer;
  ResultIdentifier : Integer;
begin
	ACharacterList := TCharacterList.Create;
	ResultIdentifier := SendQuery(
		Format('SELECT char_id FROM characters WHERE account_id = %d and char_num < 9;',
		[AccountID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if QueryResult.RecordCount > 0 then
  begin
    for Index := 0 to QueryResult.RecordCount - 1 do
    begin
			ACharacterList.Add(GetChara(StrToInt(QueryResult.Records[Index].Fields[0].value)));
    end;
  end;
	Result := ACharacterList;
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//-----------------------------------------------------------------------------

//------------------------------------------------------------------------------
//TJanSQLDatabase.CharaExists()                                         FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		October 6th, 2006 - RaX - Created.
//		December 18th, 2006 - Tsusai - Result simplified, freed queryresult.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.CharaExists(AccountID : Cardinal; Slot : Cardinal) : Boolean;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
			SendQuery(
			Format('SELECT * FROM characters WHERE char_num = %d and account_id = %d',[Slot, AccountID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	Result := (QueryResult.RecordCount > 0);
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//TJanSQLDatabase.CharaExists()                                         FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		October 6th, 2006 - RaX - Created.
//		December 18th, 2006 - Tsusai - Simplified Result, freed query result
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.CharaExists(Name : String) : Boolean;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
			SendQuery(
			Format('SELECT name FROM characters WHERE name = %s',[Name]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	Result := (QueryResult.RecordCount > 0);
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//------------------------------------------------------------------------------

function TJanSQLDatabase.AccountExists(UserName : String) : Boolean;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
			Format('SELECT userid FROM accounts WHERE userid = ''%s''',[UserName]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	Result := (QueryResult.recordcount > 0);
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;

//------------------------------------------------------------------------------
//TJanSQLDatabase.SaveAccount()                                     Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
procedure TJanSQLDatabase.SaveAccount(AnAccount: TAccount);
const
	BaseString =
		'UPDATE accounts SET '+
		'userid=''%s'', ' +
		'user_pass=''%s'', ' +
		'lastlogin=%s, ' +
		'sex=''%s'', ' +
		'logincount=%d, ' +
		'email=''%s'', ' +
		'loginkey1=%d, ' +
		'loginkey2=%d, ' +
		'connect_until=%s, ' +
		'ban_until=%s, ' +
		'last_ip=''%s'' ' +
		'WHERE account_id=%d;';
var
	QueryString : string;
  ResultIdentifier : Integer;
begin
	QueryString :=
		Format(BaseString,
			[AnAccount.Username,
			 AnAccount.Password,
			 FormatDateTime('yyyy-mm-dd hh:mm:ss',AnAccount.LastLoginTime),
			 AnAccount.Gender,
			 AnAccount.LoginCount,
			 AnAccount.EMail,
			 AnAccount.LoginKey[1],
			 AnAccount.LoginKey[2],
			 FormatDateTime('yyyy-mm-dd hh:mm:ss',AnAccount.ConnectUntil),
			 FormatDateTime('yyyy-mm-dd hh:mm:ss',AnAccount.Bantime),
			 AnAccount.LastIP,
			 AnAccount.ID]
		);
	ResultIdentifier := SendQuery(QueryString);
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.SaveChara()                                        Procedure
//------------------------------------------------------------------------------
//	What it does-
//			saves a TCharacter to the database
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
procedure TJanSQLDatabase.SaveChara(AChara : TCharacter);
var
	QueryString : string;
  ResultIdentifier : Integer;
begin
	with AChara do
	begin
		QueryString := Format('UPDATE characters SET ' +
			'char_num=%d, ' +
			'name=''%s'', ' +
			'class=%d, ' +
			'base_level=%d, ' +
			'job_level=%d, ' +
			'base_exp=%d, ' +
			'job_exp=%d, ' +
			'zeny=%d, ' +
			'p_str=%d, ' +
			'p_agi=%d, ' +
			'p_vit=%d, ' +
			'p_int=%d, ' +  //needs to be in ` ` else TEXT thinks its an Integer type
			'p_dex=%d, ' +
			'p_luk=%d, ' +
			'max_hp=%d, ' +
			'hp=%d, ' +
			'max_sp=%d, ' +
			'sp=%d, ' +
			'status_point=%d, ' +
			'skill_point=%d, ' +
			'options=%d, ' +  // see INT above
			'karma=%d, ' +
			'manner=%d, ' +
			'party_id=%d, ' +
			'guild_id=%d, ' +
			'pet_id=%d, ' +
			'hair=%d, ' +
			'hair_color=%d, ' +
			'clothes_color=%d, ' +
			'weapon=%d, ' +
			'shield=%d, ' +
			'head_top=%d, ' +
			'head_mid=%d, ' +
			'head_bottom=%d, ' +
			'last_map=''%s'', ' +
			'last_x=%d, ' +
			'last_y=%d, ' +
			'save_map=''%s'', ' +
			'save_x=%d, ' +
			'save_y=%d, ' +
			'partner_id=%d, ' +
			'parent_id=%d, ' +
			'parent_id2=%d, ' +
			'baby_id=%d, ' +
			'online=%d, ' +
			'homun_id=%d ' +
			'WHERE char_id=%d;',
			[
			CharaNum,
			Name,
			JID,
			BaseLV,
			JobLV,
			BaseEXP,
			JobEXP,
			Zeny,
			ParamBase[STR],
			ParamBase[AGI],
			ParamBase[VIT],
			ParamBase[INT],
			ParamBase[DEX],
			ParamBase[LUK],
			MaxHP,
			HP,
			MaxSP,
			SP,
			StatusPts,
			SkillPts,
			Option,
			Karma,
			Manner,
			PartyID,
			GuildID,
			PetID,
			Hair,
			HairColor,
			ClothesColor,
			Weapon,
			Shield,
			HeadTop,
			HeadMid,
			HeadBottom,
			Map,
			Point.X,
			Point.Y,
			SaveMap,
			SavePoint.X,
			SavePoint.Y,
			PartnerID,
			ParentID1,
			ParentID2,
			BabyID,
			Online,
			HomunID,
			CID
			]);
	end;
	ResultIdentifier := SendQuery(QueryString);
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//SaveChara
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.CreateChara()                                       Function
//------------------------------------------------------------------------------
//	What it does-
//			Creates a character in the database. Also, adds it to the charalist.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//		December 18th, 2006 - Tsusai - Fixed query syntax
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.CreateChara(
	var ACharacter : TCharacter;
	AID : Cardinal;
	NName : string
) : boolean;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	Result := FALSE;
	ResultIdentifier := SendQuery(
		Format('INSERT INTO characters (account_id, name) VALUES(%d, %s);',
		[AID,NName]));
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
	ResultIdentifier :=
		SendQuery(
		Format('SELECT char_id FROM characters WHERE account_id = %d AND name = %s;',
		[AID,NName]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) then
	begin
		ACharacter := GetChara(StrToInt(QueryResult.Records[0].Fields[0].value));
		Result := Assigned(ACharacter);
	end;
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//CreateChara
//------------------------------------------------------------------------------

procedure TJanSQLDatabase.CreateAccount(
	const Username : string;
	const Password : string;
	const GenderChar : char
);
var
  ResultIdentifier : Integer;
begin

	ResultIdentifier := SendQuery(
		Format('INSERT INTO accounts (userid, user_pass, sex) VALUES(%s, %s, %s);',
		[Username,Password,GenderChar]));
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;

//------------------------------------------------------------------------------
//TJanSQLDatabase.LoadChara()                                        FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Loads a character from the database.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.LoadChara(CharaID : Cardinal) : TCharacter;
var
	APoint      : TPoint;
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
		Format('SELECT * FROM characters WHERE char_id = %d;',
			[CharaID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) and (QueryResult.fieldcount = 48) then
	begin
		with Result do
		begin
			Result           := TCharacter.Create;
			CID              := StrToInt(QueryResult.Records[0].Fields[0].Value);
			ID               := StrToInt(QueryResult.Records[0].Fields[1].Value);
			Account          := MainProc.ACommonDatabase.AnInterface.GetAccount(ID);
			CharaNum         := StrToInt(QueryResult.Records[0].Fields[2].Value);
			if CharaNum < 9 then
			begin
				//If its active, then attach to the player.
				Account.CharaID[CharaNum] := CID;
			end;
			Name            :=          QueryResult.Records[0].Fields[3].Value;
			JID             := StrToInt(QueryResult.Records[0].Fields[4].Value);
			BaseLV          := StrToInt(QueryResult.Records[0].Fields[5].Value);
			JobLV           := StrToInt(QueryResult.Records[0].Fields[6].Value);
			BaseEXP         := StrToInt(QueryResult.Records[0].Fields[7].Value);
			JobEXP          := StrToInt(QueryResult.Records[0].Fields[8].Value);
			Zeny            := StrToInt(QueryResult.Records[0].Fields[9].Value);
			ParamBase[STR]  := StrToInt(QueryResult.Records[0].Fields[10].Value);
			ParamBase[AGI]  := StrToInt(QueryResult.Records[0].Fields[11].Value);
			ParamBase[VIT]  := StrToInt(QueryResult.Records[0].Fields[12].Value);
			ParamBase[INT]  := StrToInt(QueryResult.Records[0].Fields[13].Value);
			ParamBase[DEX]  := StrToInt(QueryResult.Records[0].Fields[14].Value);
			ParamBase[LUK]  := StrToInt(QueryResult.Records[0].Fields[15].Value);
			MaxHP           := StrToInt(QueryResult.Records[0].Fields[16].Value);
			HP              := StrToInt(QueryResult.Records[0].Fields[17].Value);
			MaxSP           := StrToInt(QueryResult.Records[0].Fields[18].Value);
			SP              := StrToInt(QueryResult.Records[0].Fields[19].Value);
			StatusPts       := StrToInt(QueryResult.Records[0].Fields[20].Value);
			SkillPts        := StrToInt(QueryResult.Records[0].Fields[21].Value);
			Option          := StrToInt(QueryResult.Records[0].Fields[22].Value);
			Karma           := StrToInt(QueryResult.Records[0].Fields[23].Value);
			Manner          := StrToInt(QueryResult.Records[0].Fields[24].Value);
			PartyID         := StrToInt(QueryResult.Records[0].Fields[25].Value);
			GuildID         := StrToInt(QueryResult.Records[0].Fields[26].Value);
			PetID           := StrToInt(QueryResult.Records[0].Fields[27].Value);
			Hair            := StrToInt(QueryResult.Records[0].Fields[28].Value);
			HairColor       := StrToInt(QueryResult.Records[0].Fields[29].Value);
			ClothesColor    := StrToInt(QueryResult.Records[0].Fields[30].Value);
			Weapon          := StrToInt(QueryResult.Records[0].Fields[31].Value);
			Shield          := StrToInt(QueryResult.Records[0].Fields[32].Value);
			HeadTop         := StrToInt(QueryResult.Records[0].Fields[33].Value);
			HeadMid         := StrToInt(QueryResult.Records[0].Fields[34].Value);
			HeadBottom      := StrToInt(QueryResult.Records[0].Fields[35].Value);
			Map             :=          QueryResult.Records[0].Fields[36].Value ;
				APoint.X      := StrToInt(QueryResult.Records[0].Fields[37].Value);
				APoint.Y      := StrToInt(QueryResult.Records[0].Fields[38].Value);
			Point           := APoint;
			SaveMap         :=          QueryResult.Records[0].Fields[39].Value ;
				APoint.X      := StrToInt(QueryResult.Records[0].Fields[40].Value);
				APoint.Y      := StrToInt(QueryResult.Records[0].Fields[41].Value);
			SavePoint       := APoint;
			PartnerID       := StrToInt(QueryResult.Records[0].Fields[42].Value);
			ParentID1       := StrToInt(QueryResult.Records[0].Fields[43].Value);
			ParentID2       := StrToInt(QueryResult.Records[0].Fields[44].Value);
			BabyID          := StrToInt(QueryResult.Records[0].Fields[45].Value);
			Online          := StrToInt(QueryResult.Records[0].Fields[46].Value);
			HomunID         := StrToInt(QueryResult.Records[0].Fields[47].Value);
			//Do not start the save timer caused by modifying everything else.
			DataChanged := false;
		end;
	end else Result := nil;
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//LoadChara
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.DeleteChara()                                        FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Deletes a character from the database.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
function TJanSQLDatabase.DeleteChara(var ACharacter : TCharacter) : boolean;
var
  ResultIdentifier : Integer;
begin
	ResultIdentifier := SendQuery(
		Format('DELETE FROM characters WHERE char_id=%d',[ACharacter.CID]));

		CharacterList.Delete(
			CharacterList.IndexOf(ACharacter.CID)
		);
		ACharacter.Account.CharaID[ACharacter.CharaNum] := 0;
		ACharacter.Free;
    Result := TRUE;
  if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//DeleteChara
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.GetAccountBanAndConnectTime()                       Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Builds a taccount object from a query result.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
procedure TJanSQLDatabase.GetAccountBanAndConnectTime(var AnAccount : TAccount);
var
  ResultIdentifier : Integer;
  QueryResult : TJanRecordSet;
begin
  ResultIdentifier := SendQuery(
		Format('SELECT connect_until, ban_until FROM accounts WHERE account_id=%d',[AnAccount.ID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
  AnAccount.ConnectUntil := ConvertMySQLTime(QueryResult.records[0].fields[0].Value);
  AnAccount.Bantime := ConvertMySQLTime(QueryResult.records[0].fields[1].Value);
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//GetAccountBanAndConnectTime
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//TJanSQLDatabase.GetBaseHP()                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Gets a characters basehp.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLDatabase.GetBaseHP(ACharacter : TCharacter) : Cardinal;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
		Format('SELECT * FROM hp WHERE level = %d, job = %s ;',
			[ACharacter.BaseLV,ACharacter.JID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) then
	begin
			Result              := StrToInt(QueryResult.Records[0].Fields[0].value);
	end else Result := 0;
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//GetBaseHP
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLDatabase.GetBaseSP()                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Gets a characters basesp.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLDatabase.GetBaseSP(ACharacter : TCharacter) : Cardinal;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
		Format('SELECT * FROM sp WHERE level = %d, job = %s ;',
			[ACharacter.BaseLV,ACharacter.JID]));
  QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) then
	begin
			Result              := StrToInt(QueryResult.Records[0].Fields[0].Value);
	end else Result := 0;
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//GetBaseSP
//------------------------------------------------------------------------------

{END JanSQLDatabase}
end.
