//This unit contains "common" routines mainly used in SQL queries.
unit SQLExtendedRoutines;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface
	function SQLEscapeString(const AString	: String): String;

implementation


	//This routine takes a sql string variable and escapes potentially
	//dangerous characters, helping to prevent SQL injections.
	function SQLEscapeString(const AString	: String): String;
	var
		Index : Integer;
	begin
		Result := '';
		for Index := 1 to Length(AString) do
		begin
			if AString[Index] in [ '''', '\', '"', ';'] then
			begin
				Result := Result + '\' + AString[Index];
			end else
			begin
				Result := Result + AString[Index];
			end;
		end;
	end;
end.