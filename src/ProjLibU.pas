unit ProjLibU;

interface

function SplitLen(const AValue : string; const APartLen : Integer; const ASeperator : Char = ' ') : string;
function HexDataToByteList(const AValue : string) : TArray<Byte>;
function ByteArrayToString(const AValue : TArray<Byte>) : string;
function UnHexLify(const AValue : string) : string;


implementation

uses System.SysUtils;

function SplitLen(const AValue : string; const APartLen : Integer; const ASeperator : Char = ' ') : string;
var
  i : integer;
begin
  Result := '';
  i := 0;
  while ((i+APartLen)<AValue.Length) do
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
  while (i<AValue.Length-2) do
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
  while (i<AValue.Length-2) do
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


end.
