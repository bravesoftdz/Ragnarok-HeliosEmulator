//------------------------------------------------------------------------------
//MySQLCommonDatabase		                                                        UNIT
//------------------------------------------------------------------------------
//	What it does-
//			This is one of our database objects which enabled Helios to use a MySQL
//    Database.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
unit MySQLCommonDatabase;

interface
uses
	CommonDatabaseTemplate,
	Character,
	CharaList,
	Account,
	uMysqlClient,
	Database;
type
//------------------------------------------------------------------------------
//TMySQLCommonDatabase			                                                           CLASS
//------------------------------------------------------------------------------
//	What it does-
//			This is a child class for our database object system. It allows Helios
//    to communicate with a MySQL database and houses all routines for doing so.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		January 20th, 2007 - Tsusai - Connect is now a bool function
//			Create holds connection result
//
//------------------------------------------------------------------------------
	TMySQLCommonDatabase = class(TCommonDatabaseTemplate)
	private
		Connection   : TMySQLClient;
    Parent : TDatabase;
	public


		Constructor Create(
			EnableCommonDatabase : boolean;
			var LoadedOK : Boolean;
			AParent : TDatabase
		); reintroduce; overload;
		Destructor Destroy();override;

		function GetAccount(ID    : Cardinal) : TAccount;overload;override;
		function GetAccount(Name  : string) : TAccount;overload;override;

		procedure RefreshAccountData(var AnAccount : TAccount); override;

		procedure CreateAccount(
			const Username : string;
			const Password : string;
			const GenderChar : char
		); override;

		function AccountExists(UserName : String) : Boolean;override;

		procedure SaveAccount(AnAccount : TAccount);override;

	protected
		function Connect(): boolean; override;
		function SendQuery(
			const QString : string;
			StoreResult : boolean;
			var ExecutedOK : boolean
		) : TMySQLResult;
		procedure Disconnect();override;
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
//Create()								                                          CONSTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Initializes our connection object.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//		November 13th, 2006 - Tsusai - create inherit comes first.
//		January 20th, 2007 - Tsusai - Create holds connection result
//
//------------------------------------------------------------------------------
Constructor TMySQLCommonDatabase.Create(
	EnableCommonDatabase : boolean;
	var LoadedOK : Boolean;
	AParent : TDatabase
);
begin
	inherited Create(EnableCommonDatabase);
	Parent := AParent;
	Connection := TMySQLClient.Create;
	if EnableCommonDatabase then
	begin
		LoadedOK := Connect();
	end;
end;//Create
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//Destroy()								                                          DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Destroys our connection object.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
Destructor TMySQLCommonDatabase.Destroy();
begin

	Disconnect;
	Connection.Free;
	inherited;
end;//Destroy
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//Connect()								                                            Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Initializes the MySQL Connection.
//
//	Changes -
//		October 5th, 2006 - RaX - Moved here from globals.
//		January 20th, 2007 - Tsusai - Connect is now a bool function
//
//------------------------------------------------------------------------------
function TMySQLCommonDatabase.Connect() : Boolean;
begin
	Result := false;
	if NOT Connection.Connected then
	begin
			Connection.Host            := Parent.Options.CommonHost;
			Connection.Port            := Parent.Options.CommonPort;
			Connection.Db              := Parent.Options.CommonDB;
			Connection.User            := Parent.Options.CommonUser;
			Connection.Password        := Parent.Options.CommonPass;
	end;

	Connection.ConnectTimeout  := 10;

	if NOT Connection.Connect then
	begin
		MainProc.Console('*****Could not connect to mySQL database server.');
	end else
	begin
		Result := true;
	end;
	
end;//Connect
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SendQuery()								                                           Function
//------------------------------------------------------------------------------
//	What it does-
//			Sends a query.
//
//	Changes -
//		January 11th, 2007 - RaX - Created Header.
//
//------------------------------------------------------------------------------
function TMySQLCommonDatabase.SendQuery(
	const QString : string;
	StoreResult : boolean;
	var ExecutedOK : boolean
) : TMySQLResult;
begin
	Result := Connection.query(QString,StoreResult,ExecutedOK);
	if not ExecutedOK then
	begin
		MainProc.Console('MySQL Query error: ' + QString);
	end;
end;//SendQuery
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//Disconnect()							                                         Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Destroys the MySQL Connection.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
Procedure TMySQLCommonDatabase.Disconnect();
begin
	if Connection.Connected then
	begin
		Connection.close;
	end;
end;//Disconnect
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SetAccount()							                                          PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//			Builds a taccount object from a query result.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//		December 27th, 2006 - Tsusai - Fixed login key and gender char reading
//
//------------------------------------------------------------------------------
procedure SetAccount(
	var AnAccount : TAccount;
	var QueryResult : TMySQLResult
);
begin
	AnAccount := TAccount.Create;
	AnAccount.ID          := StrToInt(QueryResult.FieldValue(0));
	AnAccount.Username    := QueryResult.FieldValue(1);
	AnAccount.Password    := QueryResult.FieldValue(2);
	//Tsusai - For Gender, we need to return the first char, thats
	//why there is a [1]
	AnAccount.Gender       := QueryResult.FieldValue(4)[1];
	AnAccount.LoginCount   := StrToIntDef(QueryResult.FieldValue(5),0);
	AnAccount.EMail        := QueryResult.FieldValue(6);
	AnAccount.LoginKey[1]  := StrToIntDef(QueryResult.FieldValue(7),0);
	AnAccount.LoginKey[2]  := StrToIntDef(QueryResult.FieldValue(8),0);
	AnAccount.Level        := StrToIntDef(QueryResult.FieldValue(9),0);
	AnAccount.ConnectUntil := ConvertMySQLTime(QueryResult.FieldValue(11));
	AnAccount.LastIP       := QueryResult.FieldValue(12);
	AnAccount.Bantime      := ConvertMySQLTime(QueryResult.FieldValue(14));
end;//SetAccount
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetAccount()							                                OVERLOADED FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			This function returns a TAccount type and is used for loading up an
//    account by ID.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		November 13th, 2005 - Tsusai - now calls a shared TAccount routine to
//													set the data
//		December 27th, 2006 - Tsusai - Reorganized
//
//------------------------------------------------------------------------------
function TMySQLCommonDatabase.GetAccount(ID: Cardinal) : TAccount;
var
	Success     : Boolean;
	AnAccount   : TAccount;
	Index       : Integer;
	QueryResult : TMySQLResult;
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

	if Assigned(Result) then
	begin
		RefreshAccountData(Result);
	end else
	begin
		QueryResult := SendQuery('SELECT * FROM accounts WHERE account_id = '''+IntToStr(ID)+'''',true,Success);
		if Success and (QueryResult.RowsCount = 1) then begin
			if Not Assigned(Result) then
			begin
				SetAccount(AnAccount,QueryResult);
				AccountList.AddObject(AnAccount.Username, AnAccount);
				Result := AnAccount;
			end;
		end;
		if Assigned(QueryResult) then QueryResult.Free;
	end;

end;//GetAccount
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetAccount()							                                OVERLOADED FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			This function returns a TAccount type and is used for loading up an
//    account by Name.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		November 13th, 2005 - Tsusai - now calls a shared TAccount routine to
//													set the data
//		December 27th, 2006 - Tsusai - Reorganized
//
//------------------------------------------------------------------------------
function TMySQLCommonDatabase.GetAccount(Name : string) : TAccount;
var
	Success     : Boolean;
	AnAccount   : TAccount;
	Index       : Integer;
	QueryResult : TMySQLResult;
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

	if Assigned(Result) then
	begin
		RefreshAccountData(Result);
	end else
	begin
		QueryResult := SendQuery('SELECT * FROM accounts WHERE userid = '''+Name+'''',true,Success);
		if Success and (QueryResult.RowsCount = 1) then begin
			if Not Assigned(Result) then
			begin
				SetAccount(AnAccount,QueryResult);
				AccountList.AddObject(AnAccount.Username, AnAccount);
				Result := AnAccount;
			end;
		end;
		if Assigned(QueryResult) then QueryResult.Free;
	end;

end;//GetAccount
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//AccountExists()						                                					 FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Checks to see if an account exists in the database.
//
//	Changes -
//		January 11th, 2007 - RaX - Created header.
//
//------------------------------------------------------------------------------
function TMySQLCommonDatabase.AccountExists(UserName : String) : Boolean;
var
	QueryResult : TMySQLResult;
	Success : boolean;
begin
	Result := false;
	QueryResult :=
		SendQuery(
			Format('SELECT userid FROM accounts WHERE userid = ''%s''',[UserName]),true,Success);
	if Success then
	begin
		Result := (QueryResult.RowsCount > 0);
	end;

	if Assigned(QueryResult) then QueryResult.Free;
end;//AccountExists
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//SaveAccount()									                                     Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Doesn't do anything yet.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
procedure TMySQLCommonDatabase.SaveAccount(AnAccount: TAccount);
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
	Success : boolean;
	QueryString : string;
begin
	QueryString :=
		Format(BaseString,
			[AnAccount.Username,
			 AnAccount.Password,
			 FormatDateTime('yyyymmddhhmmss',AnAccount.LastLoginTime),
			 AnAccount.Gender,
			 AnAccount.LoginCount,
			 AnAccount.EMail,
			 AnAccount.LoginKey[1],
			 AnAccount.LoginKey[2],
			 FormatDateTime('yyyymmddhhmmss',AnAccount.ConnectUntil),
			 FormatDateTime('yyyymmddhhmmss',AnAccount.Bantime),
			 AnAccount.LastIP,
			 AnAccount.ID]
		);
	SendQuery(QueryString, FALSE, Success);
end;//SaveAccount
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//CreateAccount							                               						FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Creates an account.
//
//	Changes -
//		January 11th, 2007 - RaX - Created header.
//
//------------------------------------------------------------------------------
procedure TMySQLCommonDatabase.CreateAccount(
	const Username : string;
	const Password : string;
	const GenderChar : char
);
var
	Success : boolean;
begin
	SendQuery(
		Format('INSERT INTO accounts (userid, user_pass, sex) VALUES(''%s'', ''%s'', ''%s'')',
		[Username,Password,GenderChar])
	,TRUE,Success);

end;//CreateAccount
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//RefreshAccountData()								                                PROCEDURE
//------------------------------------------------------------------------------
//	What it does-
//
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//		December 27th, 2006 - Tsusai - Remade, now gets all needed account data
//			regardless
//
//------------------------------------------------------------------------------
procedure TMySQLCommonDatabase.RefreshAccountData(var AnAccount : TAccount);
var
	Success     : Boolean;
	QueryResult : TMySQLResult;
begin
	QueryResult := SendQuery(
		Format('SELECT loginkey1, loginkey2, connect_until, ban_until FROM accounts WHERE account_id=%d',[AnAccount.ID]),true,Success);
	AnAccount.LoginKey[1]  := StrToIntDef(QueryResult.FieldValue(0),0);
	AnAccount.LoginKey[2]  := StrToIntDef(QueryResult.FieldValue(1),0);
	AnAccount.ConnectUntil := ConvertMySQLTime(QueryResult.FieldValue(2));
	AnAccount.BanTime := ConvertMySQLTime(QueryResult.FieldValue(3));
	if Assigned(QueryResult) then QueryResult.Free;
end;//RefreshAccountData
//------------------------------------------------------------------------------


{END MySQLCommonDatabase}
end.