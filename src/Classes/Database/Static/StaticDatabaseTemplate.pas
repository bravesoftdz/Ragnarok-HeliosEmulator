//------------------------------------------------------------------------------
//Database			                                                           UNIT
//------------------------------------------------------------------------------
//	What it does-
//			This is the parent class of our other database objects, it also includes
//    a function for choosing which database we're using based on a
//    configuration variable. It contains all database interface routines.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
unit StaticDatabaseTemplate;

interface
uses
	Character;
type
//------------------------------------------------------------------------------
//TStaticDatabaseTemplate			                                                           CLASS
//------------------------------------------------------------------------------
//	What it does-
//			This is our parent class for database interfacing. Contains all database
//    routines.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//		January 20th, 2007 - Tsusai - Connect is now a bool function
//			Create holds connection result
//
//------------------------------------------------------------------------------
	TStaticDatabaseTemplate = class(TObject)
	public
		Constructor Create(EnableStaticDatabase : Boolean); virtual;
		Destructor Destroy();override;

		Function GetBaseHP(ACharacter : TCharacter) : Word;virtual;
		Function GetBaseSP(ACharacter : TCharacter) : Word;virtual;

		Function GetMapCannotSave(MapName : String) : Boolean;virtual;
		Function GetMapZoneID(MapName : String) : Integer;virtual;
	protected
		function Connect() : boolean; virtual;
		procedure Disconnect();virtual;
	end;
//------------------------------------------------------------------------------


implementation

//------------------------------------------------------------------------------
//TDatabase	routines                                             Routine stubs
//------------------------------------------------------------------------------
//	What it does-
//			These are simple placeholders for routines which will override these.
//
//	Changes -
//		September 29th, 2006 - RaX - Created.
//
//------------------------------------------------------------------------------
Constructor TStaticDatabaseTemplate.Create(EnableStaticDatabase : Boolean);
begin
	inherited Create;
end;

Destructor TStaticDatabaseTemplate.Destroy();
begin
	inherited;
end;

function TStaticDatabaseTemplate.Connect() : boolean;
begin
	Result := false;
end;

procedure TStaticDatabaseTemplate.Disconnect();
begin
end;

Function TStaticDatabaseTemplate.GetBaseHP(ACharacter : TCharacter) : Word;
begin
	Result := 0;
end;

Function TStaticDatabaseTemplate.GetBaseSP(ACharacter : TCharacter) : Word;
begin
	Result := 0;
end;

Function TStaticDatabaseTemplate.GetMapCannotSave(MapName : String) : Boolean;
begin
	Result := FALSE;
end;

Function TStaticDatabaseTemplate.GetMapZoneID(MapName : String) : Integer;
begin
	Result := 0;
end;
//------------------------------------------------------------------------------
{END TStaticDatabaseTemplate}
end.
