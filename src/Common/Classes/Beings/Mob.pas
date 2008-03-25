unit Mob;

{$IFDEF FPC}
	{$MODE Delphi}
{$ENDIF}

interface
uses
	Being;

type
	TMob = class(TBeing)
	protected

	public
		SpriteName : String;

		Defence    : Word;
		MDEF       : Word;
		
		Race  : Byte;
		Scale : Byte;
		TamingItem : Word;
		FoodItem  : Word;
	end;

implementation

end.