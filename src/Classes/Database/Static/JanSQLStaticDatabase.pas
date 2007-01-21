//------------------------------------------------------------------------------
//JanSQLStaticDatabase		                                                        UNIT
//------------------------------------------------------------------------------
//	What it does-
//			This is one of our database objects which enabled Helios to use a TEXT
//    Database.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
unit JanSQLStaticDatabase;

interface
uses
	StaticDatabaseTemplate,
	Character,
	CharaList,
	Account,
	janSQL,
  Database;

//------------------------------------------------------------------------------
//TJanSQLStaticDatabase			                                                           CLASS
//------------------------------------------------------------------------------
//	What it does-
//			This is a child class for our database object system. It allows Helios
//    to communicate with a TEXT database and houses all routines for doing so.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		January 20th, 2007 - Tsusai - Connect is now a bool function
//			Create holds connection result
//
//------------------------------------------------------------------------------
type
	TJanSQLStaticDatabase = class(TStaticDatabaseTemplate)
	private
		Database : TjanSQL;
    Parent  : TDatabase;
	public

		Constructor Create(
			EnableStaticDatabase : boolean;
			var LoadedOK : boolean;
			AParent : TDatabase
		); reintroduce; overload;
		Destructor Destroy();override;

		Function GetBaseHP(ACharacter : TCharacter) : Word;override;
		Function GetBaseSP(ACharacter : TCharacter) : Word;override;

		Function GetMapCannotSave(MapName : String) : Boolean;override;
		Function GetMapZoneID(MapName : String): Integer; override;

	protected
		function Connect() : boolean; override;
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
		Classes,
    Math;


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.Create()                                          CONSTRUCTOR
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
Constructor TJanSQLStaticDatabase.Create(
	EnableStaticDatabase : boolean;
	var LoadedOK : boolean;
	AParent : TDatabase
);
begin
	inherited Create(EnableStaticDatabase);
	Parent := AParent;
	Database := TJanSQL.Create;
	if EnableStaticDatabase then
	begin
		LoadedOK := Connect();
	end;

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.Destroy()                                          DESTRUCTOR
//------------------------------------------------------------------------------
//	What it does-
//			Destroys our connection object.
//
//	Changes -
//		October 5th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
Destructor TJanSQLStaticDatabase.Destroy();
begin
	Disconnect;
  Database.Free;
	inherited;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.Disconnect()                                        Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Destroys the TEXT Connection.
//
//	Changes -
//		December 21st, 2006 - RaX - Created
//
//------------------------------------------------------------------------------
procedure TJanSQLStaticDatabase.Disconnect;
begin

end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.Connect()                                            Procedure
//------------------------------------------------------------------------------
//	What it does-
//			Initializes the TEXT Connection.
//
//	Changes -
//		October 5th, 2006 - RaX - Moved here from globals.
//		December 18th, 2006 - Tsusai - Modified the connect to actually...connect
//			Also FileExists doesn't work for directories, its DirectoryExists
//		January 20th, 2007 - Tsusai - Connect is now a bool function
//
//------------------------------------------------------------------------------
function TJanSQLStaticDatabase.Connect() : boolean;
var
	ResultIdentifier : Integer;
const ConnectQuery = 'Connect to ''%s''';
begin
	Result := true;
	ResultIdentifier := 0;

	if DirectoryExists(Parent.Options.StaticHost) then
	begin
		ResultIdentifier := Database.SQLDirect(Format(ConnectQuery,[Parent.Options.StaticHost]));
	end else
	begin
		MainProc.Console('');
		MainProc.Console('The database at '+Parent.Options.StaticHost+' does not exist!');
		MainProc.Console('Please ensure that you have correctly configured your ini file');
		Result := false;
	end;

	if ResultIdentifier = 0 then
	begin
		MainProc.Console('*****Could not open text database. Error : ' + Database.Error);
		MainProc.Console(Parent.Options.StaticHost);
		Result := false;
	end else
	begin
		Database.ReleaseRecordset(ResultIdentifier);
	end;
end;
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.SendQuery()                                          Function
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
function TJanSQLStaticDatabase.SendQuery(
	const QString : string
) : Integer;
begin
	Result := Database.SQLDirect(QString);
	if (Result = 0) AND (Database.Error <> 'SELECT FROM: no records') then
	begin
		MainProc.Console('Text Query error: ' + QString);
    MainProc.Console(Database.Error);
	end;
end;//SendQuery
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.GetBaseHP()                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Gets a characters basehp.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLStaticDatabase.GetBaseHP(ACharacter : TCharacter) : Word;
var
	QueryResult : TJanRecordSet;
  ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
		Format('SELECT %s FROM hp WHERE level = %d',
			[ACharacter.JobName, ACharacter.BaseLV]));
	QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) then
	begin
			Result              := StrToInt(QueryResult.Records[0].Fields[0].value);
	end else Result := 0;
	SendQuery('RELEASE TABLE hp');
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//GetBaseHP
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//TJanSQLStaticDatabase.GetBaseSP()                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Gets a characters basesp.
//
//	Changes -
//		December 17th, 2006 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLStaticDatabase.GetBaseSP(ACharacter : TCharacter) : Word;
var
	QueryResult : TJanRecordSet;
	ResultIdentifier : Integer;
begin
	ResultIdentifier :=
		SendQuery(
		Format('SELECT %s FROM sp WHERE level = %d',
			[ACharacter.JobName, ACharacter.BaseLV]));
	QueryResult := Database.RecordSets[ResultIdentifier];
	if (QueryResult.RecordCount = 1) then
	begin
			Result  := StrToInt(QueryResult.Records[0].Fields[0].Value);
	end else Result := 0;
	SendQuery('RELEASE TABLE sp');
	if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
end;//GetBaseSP
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetMapCannotSave					                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Checks to see if a map can save or not.
//
//	Changes -
//		January 10th, 2007 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLStaticDatabase.GetMapCannotSave(MapName : String) : Boolean;
var
	QueryResult : TJanRecordSet;
	ResultIdentifier : Integer;
begin
	Result := false;
	ResultIdentifier :=
		SendQuery(
		Format('SELECT noreturnondc FROM maps WHERE mapname = ''%s.gat''',
			[MapName]));

	if ResultIdentifier > 0 then
	begin
		QueryResult := Database.RecordSets[ResultIdentifier];
		if (QueryResult.RecordCount = 1) then
		begin
				Result := StrToBool(QueryResult.Records[0].Fields[0].Value);
		end;
		SendQuery('RELEASE TABLE maps');
		Database.ReleaseRecordset(ResultIdentifier);
	end;
end;//GetMapCanSave
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//GetMapZoneID							                                          FUNCTION
//------------------------------------------------------------------------------
//	What it does-
//			Checks to see if a map can save or not.
//
//	Changes -
//		January 10th, 2007 - RaX - Created Header.
//
//------------------------------------------------------------------------------
Function TJanSQLStaticDatabase.GetMapZoneID(MapName : String) : Integer;
var
	QueryResult : TJanRecordSet;
	ResultIdentifier : Integer;
begin
	Result := 1; //Assume 1
	ResultIdentifier :=
		SendQuery(
		Format('SELECT zoneid FROM maps WHERE mapname = ''%s.gat''',
			[MapName]));
	if ResultIdentifier > 0 then
	begin
		QueryResult := Database.RecordSets[ResultIdentifier];
		if (QueryResult.RecordCount = 1) then
		begin
			Result := StrToIntDef(QueryResult.Records[0].Fields[0].Value,1);
		end;
		SendQuery('RELEASE TABLE maps');
		if ResultIdentifier > 0 then Database.ReleaseRecordset(ResultIdentifier);
	end;
end;//GetMapZoneID
//------------------------------------------------------------------------------
{END JanSQLStaticDatabase}
end.