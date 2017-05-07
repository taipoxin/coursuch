unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  // массив случайных простых чисел для p и q
  B: array[1..50] of integer;
  // хеш строки
  hashCode: Int64;
  messager: string;
  // открытая экспонента
  //eexp: integer;
  // секретная экспонента
  //dexp: integer;
  // Электронная подпись (Digital signature)
  //s: int64;
  p, q: integer;
  eiler: Int64;
  flag: boolean;
  res: integer;
  MArray: array of integer;
  SignArray: array of int64;
  maxInt64: Int64;
  maxM: integer;   // 2^21 -1

  isHashNegative : boolean;

  //testers:
  tried: cardinal;
  trigger: boolean;

implementation

uses
  Math;

{$R *.dfm}

procedure reshErat(maxEl : integer);
var
  BB: array[1..50] of Integer;
  A: array of boolean;
  n, x, y: integer;
begin
  SetLength(A, maxEl);
  A[1] := false;
  n := maxEl;
  for x := 2 to n do
    A[x] := true;
  for x := 2 to n div 2 do
    for y := 2 to n div x do
      A[x * y] := false;
  y := 1;
  x:= n;
  while (y < Length(B)) and (x > 0) do
  begin
    if A[x] then
    begin
      B[y] := x;
      inc(y);
    end;
    x := x-1;
  end;

end;


// решето Эратосфена как процедура поиска больших простых чисел
procedure reshetoErat();
var
  A: array[1..232] of boolean;
  n, x, y: integer;
begin
  A[1] := false;
  n := 232;
  for x := 2 to n do
    A[x] := true;
  for x := 2 to n div 2 do
    for y := 2 to n div x do
      A[x * y] := false;
  y := 1;
  for x := n downto n - 200 do
    if A[x] then
    begin
      B[y] := x;
      inc(y);
    end;
end;


// наш 16 битный хеш
function hashH37(s: string): integer;
var
  hash: integer;
  i: cardinal;
begin
  hash := 139062143;
  for i := 1 to length(s) do
  begin
    hash := 37 * hash + ord(s[i]);
  end;
  hash := hash shr 16;
  hashH37 := hash;

end;

function crc16(s: string): integer;
var
  i, crc: integer;
begin
  crc := 0;
  for i := 1 to length(s) do
  begin
    crc := crc + ord(s[i]) * 44111;
    //crc:= crc xor (crc shr 8);

  end;

  Result := crc;
end;

function eightbitxorsum(mess: string): integer;
var
  i, sum, scode: integer;
begin
  sum := ord(mess[1]);
  for i := 2 to length(mess) do
    sum := sum xor ord(mess[i]);

  Result := sum;
end;

function ToBin(x: integer): string;
const
  t: array[0..1] of char = ('0', '1');
var
  res: string;
  d: 0..1;
begin
  res := '';
  while (x <> 0) do
  begin
    d := x mod 2;
    res := t[d] + res;
    x := x div 2;
  end;
  Result := res;
end;


function modexp(x,y,n:int64; var z3 : int64):Int64;
var z, k : int64;
begin
  if (y = 0) then
    Result:= 1
  else
  begin
    k:= y;
    z := modexp(x, k div 2, n, z3);
    if ((y mod 2) = 0) then
      Result:= (z*z) mod n
    else
      Result:= (x*z*z) mod n;
  end;
  z3:= Result;
end;

//   http://granitnayki.com/?p=212
// ЭТА ХЕРНЯ ИЗОБРЕТЕНА УКРОПАМИ
function niceLongPow(a : int64; n : Int64; m: int64):int64;
var c, S, y : Int64;
    i, k : integer;
    strUp : string;
begin
  if (n = 1) then
    Result:= a mod m
  else
  begin
    strUp := ToBin(n);
    k := length(strUp);
    y:= a mod m;
    for i:=k downto 2 do
    begin
      y:= (y*y) mod m;
      if (strUp[i] = '1') then
      begin
        y:= y*a mod m;
      end;
    end;
    Result:= y;
  end;
end;

function substring(from : string; start, endd : Cardinal):string;
var i : Cardinal;
begin
  Result:= '';
  if  not ((endd < start) or (start < 1) or (endd > Length(from))) then
  begin
    for i:=start to endd do
    begin
      Result:= Result + from[i];
    end;
  end;
end;

// хеширование строки методом SDBM (х32) с хорошим распределением по всем битам (мало коллизий)
function SDBM(mess: string): int64;
var
  i: cardinal;
  hash: int64;
begin
  hash := 0;
  for i := 1 to Length(mess) do
    hash := ord(mess[i]) + (hash shl 6) + (hash shl 16) - hash;
  Result := hash;
end;

// нод чисел алгоритмом 
procedure gcd_ext(a, b: integer; var x, y, gcd: integer);
var
  x1, y1: integer;
begin
  if b = 0 then
  begin
    gcd := a;
    x := 1;
    y := 0;
    Exit
  end;
  gcd_ext(b, a mod b, x1, y1, gcd);
  x := y1;
  y := x1 - (a div b) * y1
end;

// херня без задач
function Znak(Val: Integer): Char;
begin
  if Val >= 0 then
    Result := '+'
  else
    Result := '-';
end;


// функция возведения в степень (для положительных чисел и степеней.
// обычное возведение
function pow(base, up: int64): int64;
var
  i: cardinal;
begin
  if (base = 1) or (up = 0) then
    Result := 1
  else
  begin
    Result := base;
    for i := 2 to up do
    begin
      Result := base * Result;
      if (result < 0) then
      begin
        flag := true;
        break;
      end;
    end;
  end;
end;

// возврат в число
function toInt(ch: char): integer;
begin
  if ch = '0' then
    Result := 0
  else if ch = '1' then
    Result := 1
  else
    Result := 9999;
end;



function genDigitalSignature(part : integer; dexp : integer; n : int64):Int64;
var s : int64;
begin
  //s := niceLongPow(hashCode, dexp, n);
  modexp(part, dexp, n, s);
  Result:= s;
end;



procedure generateKeys(minimalN: integer; var n : Int64; var eexp : integer; var dexp : integer);
var
  aa, bb, nod: integer;
  k1, k2 : Cardinal;
begin
  Randomize();
  p := 0;
  q := 0;
  k1 := 0;
  k2 := 1;

  while ((p = q) or (p = 0) or (q = 0) or (n < minimalN) or (n > minimalN * 50) or (k1 <> k2)) do
  begin
    p := RandomFrom(b);
    q := RandomFrom(b);
    k1 := Length(toBin(p));
    k2 := Length(toBin(q));
    n := p * q;
  end;

  eiler := (p - 1) * (q - 1);
  eexp := 1;
  nod := 0;

  while (nod <> 1) do
  begin
    inc(eexp);
    gcd_ext(eexp, eiler, aa, bb, nod);
  end;
  dexp := (aa mod eiler + eiler) mod eiler;
end;

procedure createSign(minimalN: integer; var n : Int64; var eexp : integer; var dexp : integer);
var
  start, endd, full: integer;
  hsh: int64;
begin
  reshErat(Round(Sqrt(minimalN*10)));
  generateKeys(minimalN, n, eexp, dexp);
end;


function checkIt(part:integer; exp : Integer; targetMod : Int64) : int64;
var
  proizv: int64;
begin
  //proizv := niceLongPow(s, eexp, n);
  modexp(part, exp, targetMod, proizv);
  Result:= proizv;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  b, c, d, z, index, llength: integer;
  a: Int64;
    // для разбиения на много m
  currentM: integer;
    // счетчик для разбиения
  k, i: Cardinal;
  el, elements: integer;
  mesage: string;
  proizv : int64;
  f, f1 : TextFile;
  str : string;
  partOneStr : string;
  partTwoStr : string;
  strHashCode : string;
  proizvStr : string;
  sStr : string;
  s1, s2 : integer;
  nextIndex : Cardinal;
  partOne, partTwo : Integer;
  maxInt32 : integer;
  // модуль хешкода, с ним мы и взаимодействуем
  HashNumber : Int64;


  n : Int64;
  dexp, eexp : Integer;
begin
  partOne:= 0;
  partTwo:= 0;
  if not (Form1.Edit3.Text = '') then
  begin
    Val(Form1.Edit3.Text, hashCode, index);
    if (index <> 0) then
    begin
      hashCode := SDBM(Form1.Edit3.Text);
    end;
  end;


  if (hashCode < 0) then
  begin
    isHashNegative:= True;
  end;
  HashNumber:= Abs(hashCode);
  partOne:= HashNumber;
  partOneStr := IntToStr(HashNumber);

  if (HashNumber > 200000) then
  begin
    // разбить на 2 части пополам
    strHashCode:= IntToStr(HashNumber);
    nextIndex:= (Length(strHashCode) div 2) + 1;
    partOneStr := substring(strHashCode, 1, nextIndex-1);
    partOne:= StrToInt(partOneStr);
    partTwoStr := substring(strHashCode, nextIndex, Length(strHashCode));
    partTwo:= StrToInt(partTwoStr);
  end;


  // формируем ключи по наибольшему из 2х значений
  createSign(Max(partOne, partTwo), n, eexp, dexp);

  str := '{'+IntToStr(eexp)+';'+IntToStr(n)+'}';
  AssignFile(f, 'openedKey.txt');
  Rewrite(f);
  Append(f);
  Writeln(f, str);
  CloseFile(f);

  str := '{'+IntToStr(dexp)+';'+IntToStr(n)+'}';
  AssignFile(f, 'closedKey.txt');
  Rewrite(f);
  Append(f);
  Writeln(f, str);
  CloseFile(f);


  s1:= genDigitalSignature(partOne, dexp, n);
  s2:= genDigitalSignature(partTwo, dexp, n);
  str := '{'+IntToStr(s1)+';'+IntToStr(s2)+'}';
  AssignFile(f, 'RSA.txt');
  Rewrite(f);
  Append(f);
  Writeln(f, str);
  CloseFile(f);

end;

// http://www.cyberforum.ru/delphi-beginners/thread1116790.html

// Важно:
// http://sumk.ulstu.ru/docs/mszki/Zavgorodnii/9.4.html

// калькули:
// http://teh-box.ru/informationsecurity/algoritm-shifrovaniya-rsa-na-palcax.html
// https://planetcalc.ru/3311/



// !!!! Молдовян Н. А. Теоретический минимум и алгоритмы цифровой подписи


