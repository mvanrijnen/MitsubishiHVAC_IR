unit ProjLibU;

interface

uses  System.UITypes,
      Vcl.Controls;

function SplitLen(const AValue : string; const APartLen : Integer; const ASeperator : Char = ' ') : string;
function HexDataToByteList(const AValue : string) : TArray<Byte>;
function ByteArrayToString(const AValue : TArray<Byte>) : string;
function UnHexLify(const AValue : string) : string;
function Val2BRCode(const AValue: Double; const ANonZero: Boolean=False): string;

procedure PushMouseCursor(const ANewCursor : TCursor = crHourGlass);
procedure PopMouseCursor();

implementation

uses Vcl.Forms,
     System.SysUtils,
     System.Generics.Collections,
     System.Math;

var
  _cursorstack : TStack<TCursor>;

procedure PushMouseCursor(const ANewCursor : TCursor = crHourGlass);
begin
  _cursorstack.Push(Screen.Cursor);
  Screen.Cursor := ANewCursor;
  Application.ProcessMessages;
end;

procedure PopMouseCursor();
begin
  Screen.Cursor := _cursorstack.Pop();
  Application.ProcessMessages;
end;

function Val2BRCode(const AValue: Double; const ANonZero: Boolean=False): string;
var
  tmp : Integer;
  dl : string;
begin
  tmp := Ceil(AValue);
  if tmp<256 then // force int, round up float if needed
     // Working with just a byte
     Result := IntToHex(tmp, 2)
  else begin
     // Working with a Dword
     dl := IntToHex(tmp, 4);
     if ANonZero then
        Result := dl.Substring(2, 2) + dl.Substring(0, 2)
     else
        Result := '00' + dl.Substring(2, 2) + dl.Substring(0, 2);
  end;
end;


function SplitLen(const AValue : string; const APartLen : Integer; const ASeperator : Char = ' ') : string;
var
  i : integer;
begin
  Result := '';
  i := 0;
  while ((i+APartLen)<=AValue.Length) do
  begin
    Result := Result + AValue.Substring(i, APartLen) + ASeperator;
    i := i + APartLen;
  end;
  Result := Result.TrimRight([ASeperator]);
end;

function UnHexLify(const AValue : string) : string;
var
  i : integer;
  tmp : string;
begin
  Result := '';
  if odd(AValue.Length) then raise Exception.Create('[UnHexLify] Need even length datastring.');
  i := 0;
  while (i<=AValue.Length-2) do
  begin
    tmp := '$'+ AValue.Substring(i, 2);
    Result := Result + Chr(StrToInt(tmp));
    i := i + 2;
  end;
end;

function HexDataToByteList(const AValue : string) : TArray<Byte>;
var
  d,j,i : integer;
  tmp : string;
begin
  SetLength(Result, 0);
  if odd(AValue.Length) then raise Exception.Create('[HexDataToByteList] Need even length datastring.');
  SetLength(Result, AValue.Length div 2);
  i := 0;
  j := 0;
  while (i<=AValue.Length-2) do
  begin
    tmp := '$'+ AValue.Substring(i, 2);
    Result[j] := StrToInt(tmp);
    i := i + 2;
    j := j + 1;
  end;
end;

function ByteArrayToString(const AValue : TArray<Byte>) : string;
begin
  for var b : byte in AValue do
     Result := Result + IntToStr(b) + ',';
  Result := Result.TrimRight([' ', ',']);
end;


initialization
  if not Assigned(_cursorstack) then
  begin
    _cursorstack := TStack<TCursor>.Create();
  end;

finalization
  FreeAndNil(_cursorstack);

end.
