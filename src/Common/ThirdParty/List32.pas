unit List32;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

{ U_IntList
Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for non-commercial purposes
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ List32
Modified by Cardinal.
TIntList32: based on TIntList. changed int64 to cardinal, added IndexOfObject.
TList32: based on TList. added IndexOfObject.

[2005/12/10] CR - Added compile directives to suppress warnings for some warning
	generating code in this library we use for the Prometheus Project.
[2006/11/27] Tsusai - Cleaned up Uses usage.
[2007/01/14] Tsusai - Made IndexOfObject what it should be.
}

interface

uses
	SyncObjs,
	Classes;

const
	maxlistsize =maxint div 32;
Type
{ TIntList32 class }
 TIntList32 = class;

	PIntItem = ^TIntItem;
  TIntItem = record
    FInt: cardinal;
    FObject: TObject;
  end;

  PIntItemList = ^TIntItemList;
  TIntItemList = array[0..MaxListSize] of TIntItem;
  TIntListSortCompare = function(List: TIntList32; Index1, Index2: Integer): Integer;

  TIntList32 = class(TPersistent)
  private
    FUpDateCount: integer;
    FList: PIntItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    CriticalSection : TCriticalSection;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TIntListSortCompare);
    procedure InsertItem(Index: Integer; const S: cardinal);
    procedure SetSorted(Value: Boolean);
  protected
    procedure Error(const Msg: string; Data: Integer);
    procedure Changed; virtual;
    procedure Changing; virtual;
    function Get(Index: Integer): cardinal;
    function GetCapacity: Integer;
    function GetCount: Integer;
    function GetObject(Index: Integer): TObject;
    procedure Put(Index: Integer; const S: cardinal);
    procedure PutObject(Index: Integer; AObject: TObject);
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetUpdateState(Updating: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(const S: cardinal): Integer;
    function AddObject(const S: cardinal; AObject: TObject): Integer; virtual;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    function Find(const S: cardinal; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: cardinal): Integer;

		function IndexOfObject(AObject: TObject): Integer;
		procedure Insert(Index: Integer; const S: cardinal);
    procedure Sort; virtual;
    procedure CustomSort(Compare: TIntListSortCompare); virtual;

    procedure LoadFromFile(const FileName: string); virtual;
    procedure LoadFromStream(Stream:TStream); virtual;
    procedure SaveToFile(const FileName: string); virtual;
    procedure SaveToStream(Stream: TStream);
    
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property Integers [Index: Integer]: cardinal read Get write Put; default;
    property Count: Integer read GetCount;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
  end;

implementation
uses
	SysUtils;

{ TIntList32 }
constructor TIntList32.Create;
begin
	inherited;
	CriticalSection := TCriticalSection.Create;
	CriticalSection.Enter;
end;


destructor TIntList32.Destroy;
begin
  FOnChange := nil;
  FOnChanging := nil;
	CriticalSection.Leave;
	CriticalSection.Free;
  inherited destroy;
  FCount := 0;
  SetCapacity(0);
end;



procedure TIntList32.Error(const Msg: string; Data: Integer);
{[2005/12/10] CR - Suppressing warning about the Pointer return type, and
ASM directive. }
{$WARNINGS OFF}
  function ReturnAddr: Pointer;
  asm
{$WARNINGS ON}
          MOV     EAX,[EBP+4]
  end;
begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;


const
  sDuplicateInt:string='Cannot add integer because if already exists';
  sListIndexError='List index Error';
  SSortedListError='Cannont insert to sorted list';

function TIntList32.Add(const S: cardinal): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(S, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(SDuplicateInt, 0);
      end;
  InsertItem(Result, S);
end;

function TIntList32.AddObject(const S: cardinal; AObject: TObject): Integer;
begin
  Result := Add(S);
  PutObject(Result, AObject);
end;

procedure TIntList32.Changed;
begin
  if (FUpdateCount = 0) and Assigned(FOnChange) then FOnChange(Self);
end;

procedure TIntList32.Changing;
begin
  if (FUpdateCount = 0) and Assigned(FOnChanging) then FOnChanging(Self);
end;

procedure TIntList32.Clear;
begin
  if FCount <> 0 then
  begin
    Changing;
    FCount := 0;
    SetCapacity(0);
    Changed;
  end;
end;

procedure TIntList32.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TIntItem));
  Changed;
end;

procedure TIntList32.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then Error(SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then Error(SListIndexError, Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TIntList32.ExchangeItems(Index1, Index2: Integer);
var
  Temp: cardinal;
  Item1, Item2: PIntItem;
begin
  {[2005/12/10] CR - Warnings for @ operators here are unnecessary - this is
  proper form -- exactly the same style that Delphi's VCL code for TStrings/
  TStringList does in this routine.}
  {$WARNINGS OFF}
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  {$WARNINGS ON}
  Temp := Integer(Item1^.FInt);
  Item1^.FInt := Item2^.FInt;
  Item2^.FInt := Temp;
  {[2005/12/10] CR - Suppress warning about Integer cast - yes, it WOULD be
  unsafe in most circumstances, but it's controlled within this class' methods
  and is thus SAFE. }
  {$WARNINGS OFF}
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
  {$WARNINGS ON}
end;

function TIntList32.Find(const S: cardinal; var Index: Integer): Boolean;
var
  L, H, I: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    If Flist^[I].FInt < S then L:=L+1 else
    begin
      H := I - 1;
      If FList^[I].FInt = S then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TIntList32.Get(Index: Integer): cardinal;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FInt;
end;

function TIntList32.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TIntList32.GetCount: Integer;
begin
  Result := FCount;
end;

function TIntList32.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

procedure TIntList32.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TIntList32.IndexOf(const S: cardinal): Integer;
begin
	if not Sorted then
	begin
		 for Result := 0 to GetCount - 1 do
		 if Get(Result) = s then Exit;
		 Result := -1;
	end
	else if not Find(S, Result) then Result := -1;
end;

function TIntList32.IndexOfObject(AObject: TObject): Integer;
begin
	for Result := 0 to GetCount - 1 do
		if GetObject(Result) = AObject then Exit;
	Result := -1;
end;

procedure TIntList32.Insert(Index: Integer; const S: cardinal);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then Error(SListIndexError, Index);
  InsertItem(Index, S);
end;

procedure TIntList32.InsertItem(Index: Integer; const S: cardinal);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TIntItem));
  with FList^[Index] do
	begin
    FObject := nil;
    FInt := S;
  end;
  Inc(FCount);
  Changed;
end;

procedure TIntList32.Put(Index: Integer; const S: cardinal);
begin
	if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  FList^[Index].FInt := S;
  Changed;
end;

procedure TIntList32.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Changing;
  FList^[Index].FObject := AObject;
  Changed;
end;

procedure TIntList32.QuickSort(L, R: Integer; SCompare: TIntListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TIntList32.SetCapacity(NewCapacity: Integer);
begin
  {[2005/12/10] CR - ReAllocMem is how Borland does it in TStringList, so...
  this is fine and Safe here. }
  {$WARNINGS OFF}
  ReallocMem(FList, NewCapacity * SizeOf(TIntItem));
  {$WARNINGS ON}
  FCapacity := NewCapacity;
end;

procedure TIntList32.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TIntList32.SetUpdateState(Updating: Boolean);
begin
  if Updating then Changing else Changed;
end;


function IntListCompare(List: TIntList32; Index1, Index2: Integer): Integer;
begin
  IF List.FList^[Index1].FInt>List.FList^[Index2].FInt then result:=+1
  else if List.FList^[Index1].FInt<List.FList^[Index2].FInt then result:=-1
  else result:=0;
end;


procedure TIntList32.Sort;
begin
  CustomSort(IntListCompare);
end;


procedure TIntList32.SaveToFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TIntList32.SaveToStream(Stream: TStream);
var
  i: integer;
  N:integer;
  Val:cardinal;
begin
  N:=count;
  Stream.WriteBuffer(N, sizeof(N));
  for i:= 0 to count-1 do
  begin
    val:=integers[i];
    stream.writebuffer(val,sizeof(val));
  end;  
end;


procedure TIntList32.LoadFromFile(const FileName: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

 procedure TIntList32.LoadFromStream(Stream: TStream);
var
  Size: Integer;
  i:integer;
	N:cardinal;
begin
  {BeginUpdate;  }
  try
    clear;
    Stream.readbuffer(size,sizeof(size));
    for i:= 0 to size-1 do
    begin
      Stream.Read(N, sizeof(N));
      add(N);
    end;
  finally
    {EndUpdate;}
  end;
end;



procedure TIntList32.CustomSort(Compare: TIntListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

end.





















