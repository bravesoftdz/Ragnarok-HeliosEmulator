unit CRT;

interface

const
	CRTBlack        = 0;
	CRTBlue         = {$IFDEF MSWINDOWS}01{$ENDIF}{$IFDEF LINUX}04{$ENDIF};
	CRTGreen        = {$IFDEF MSWINDOWS}02{$ENDIF}{$IFDEF LINUX}03{$ENDIF};
	CRTCyan         = {$IFDEF MSWINDOWS}03{$ENDIF}{$IFDEF LINUX}06{$ENDIF};
	CRTRed          = {$IFDEF MSWINDOWS}04{$ENDIF}{$IFDEF LINUX}01{$ENDIF};
	CRTMagenta      = 5;
	CRTBrown        = {$IFDEF MSWINDOWS}06{$ENDIF}{$IFDEF LINUX}03{$ENDIF};
	CRTGray         = 7;

	CRTDarkGray     = 8;
	CRTLightBlue    = {$IFDEF MSWINDOWS}09{$ENDIF}{$IFDEF LINUX}12{$ENDIF};
	CRTLightGreen   = 10;
	CRTLightCyan    = {$IFDEF MSWINDOWS}11{$ENDIF}{$IFDEF LINUX}14{$ENDIF};
	CRTLightRed     = {$IFDEF MSWINDOWS}12{$ENDIF}{$IFDEF LINUX}09{$ENDIF};
	CRTLightMagenta = 13;
	CRTYellow       = {$IFDEF MSWINDOWS}14{$ENDIF}{$IFDEF LINUX}11{$ENDIF};
	CRTWhite        = 15;
	CRTBlink        = 128;

	// Sets text foreground color.
	procedure TextColor(Color: Byte); overload;

	// Gets text forground color.
	function TextColor: Byte; overload;

	// Sets text background color.
	procedure TextBackground(Color: Byte); overload;

	// Gets text background color.
	function TextBackground: Byte; overload;

implementation
uses
	{$IFDEF MSWINDOWS}
	WinConsole;
	{$ENDIF}
	{$IFDEF LINUX}
	LinCRT;
	{$ENDIF}

	// Sets text foreground color.
	procedure TextColor(Color: Byte);
	begin
		{$IFDEF MSWINDOWS}
		WinConsole.TextColor(Color);
		{$ENDIF}
		{$IFDEF LINUX}
		LinCRT.TextColor(Color);
		{$ENDIF}
	end;

	// Gets text forground color.
	function TextColor: Byte;
	begin
		{$IFDEF MSWINDOWS}
		Result := WinConsole.TextColor;
		{$ENDIF}
		{$IFDEF LINUX}
		Result := (LinCRT.TextAttr and $F8);
		{$ENDIF}
	end;

	// Sets text background color.
	procedure TextBackground(Color: Byte);
	begin
		{$IFDEF MSWINDOWS}
		WinConsole.TextBackground(Color);
		{$ENDIF}
		{$IFDEF LINUX}
		LinCRT.TextBackground(Color);
		{$ENDIF}
		ClrScr;
	end;

	// Gets text background color.
	function TextBackground: Byte;
	begin
		{$IFDEF MSWINDOWS}
		Result := WinConsole.TextBackground;
		{$ENDIF}
		{$IFDEF LINUX}
		Result := (LinCRT.TextAttr and $F8) shr 4;
		{$ENDIF}
	end;

end.