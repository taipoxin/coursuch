unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button3: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  // массив случайных простых чисел дл€ p и q
  B: array [1..50] of integer;
  // хеш строки
  hashCode : Int64;
  messager: String;
  // открыта€ экспонента
  eexp: integer;
  // секретна€ экспонента
  dexp: integer;
  // Ёлектронна€ подпись (Digital signature)
  s: int64;
  p, q : integer;
  n, eiler : Int64;
  flag: boolean;
  res: integer;


  //testers:
  tried: cardinal;
  trigger: boolean;

implementation

uses Math;

{$R *.dfm}

// решето Ёратосфена как процедура поиска больших простых чисел
procedure reshetoErat();
var  A: array [1..232] of boolean;
      n, x, y: integer;
begin
  A[1]:=false;
  n:= 232;
  Form1.Label2.Caption:= ' ';
  for x:=2 to n do
    a[x]:=true;
  for x:=2 to n div 2 do
    for y:= 2 to n div x do
      a[x*y] := false;
  y:=1;
  for x:= n downto n - 200 do
    if a[x] then
      begin
        B[y]:= x;
        inc(y);
      end;
end;


// наш 16 битный хеш
function hashH37(s: string):integer;
var hash: integer;
    i: cardinal;
begin
  hash:= 139062143;
  for i:= 1 to length(s) do
    begin
      hash:= 37 * hash + ord(s[i]);
    end;
  hash:= hash shr 16;
  hashH37:= hash;

end;

function crc16(s:string):integer;
var i, crc: integer;
begin
  crc:= 0;
  for i:= 1 to length(s) do
  begin
    crc:= crc + ord(s[i])*44111;
    //crc:= crc xor (crc shr 8);

  end;


  Result:= crc;
end;




function eightbitxorsum(mess:string):integer;
var i, sum, scode: integer;
begin
  sum:= ord(mess[1]);
  for i:= 2 to length(mess) do
    sum:= sum xor ord(mess[i]);

  Result:= sum;
end;

function ToBin(x: integer): string;
const t:array[0..1] of char = ('0','1');
var res:string;
    d:0..1;
begin
  res:='';
  while (x<>0) do
    begin
      d:=x mod 2 ;
      res:=t[d]+res;
      x:=x div 2 ;
    end;
  Result:=res;
end;

// хеширование строки методом SDBM (х32) с хорошим распределением по всем битам (мало коллизий)
function SDBM(mess:String):int64;
var i:cardinal;
    hash:int64;
begin
  hash:=0;
  for i:=1 to Length(mess) do
      hash:= ord(mess[i]) + (hash shl 6) + (hash shl 16) - hash;
  Result:=hash;
end;


Procedure gcd_ext(a, b : integer; var x, y, gcd : integer);
var x1,y1 : integer;
Begin
  If b=0 Then
    Begin
      gcd:=a;
      x:=1;
      y:=0;
      Exit
    End;
  gcd_ext(b, a mod b, x1, y1, gcd);
  x := y1;
  y := x1 - (a div b) * y1
End;

function Znak(Val: Integer): Char;
begin
  if Val >= 0 then
    Result := '+'
  else
    Result := '-';
end;


// функци€ возведени€ в степень (дл€ положительных чисел и степеней.
function pow(base, up:int64): int64;
var i: cardinal;
begin
  if (base = 1) or (up = 0) then
    Result:= 1
  else
    begin
      Result:= base;
      for i:= 2 to up do
        begin
          Result:= base * Result;
          if (result < 0) then
            begin
              flag:= true;
              break;
            end;
        end;
    end;
end;



function toInt(ch: char):integer;
begin
if ch = '0' then
  Result:= 0
else if ch = '1' then
  Result:= 1
else
  Result:= 9999;
end;


procedure generateRsaSignature();
begin
  s := pow(hashCode, dexp) mod n;
end;

// uses Pow()
procedure genDigitalSignature();
var strdexp: string;
    i, k: integer;
    m: int64;
begin
//949666443
  strdexp:= ToBin(dexp);
  m:= hashCode;
  k:= length(strdexp);
  for i:= 2 to k do
    begin
      m:= (m*m * pow(hashCode, toInt(strdexp[k-i+1]))) mod n;
    end;
  s:= m;



  //s := Pow(hashCode, dexp) mod n;

end;

function mode(a,b : Real) : Real;
begin
  if (a < b) then
    Result:=a
  else
  begin
    Result:= Round(a) mod Round(b);
  end;
end;

function NOD(a,b : Real) : Real;
var t : Real;
begin
  while(b > 0) do
  begin
    t := mode(a,b);
    a := b;
    b := t;
  end;
  Result:=a;
end;


procedure generateKeys();
var aa, bb, nod : integer;
begin
  Randomize();


  p := 0;
  q := 0;
  while ((p = q) or (p = 0) or (q = 0)) do
  begin
    p := RandomFrom(B);
    q := RandomFrom(B);
  end;
  n := p*q;
  eiler := (p-1)*(q-1);

  eexp := 1;
  nod := 0;
  {}
  while (nod <> 1) do
  begin
    Inc(eexp);
    gcd_ext(eexp, eiler, aa, bb, nod);
  end;
  //eexp := 11;
  {}

{
  eiler := 11;
  eexp:= 4;
 }

  dexp := (aa mod eiler + eiler) mod eiler;
  
  Form1.Label6.Caption := '  before first ' +  IntToStr(aa) + '  before second   ' + IntToStr(bb);
  Form1.Label6.Visible:= True;


end;

function getProizvCheck(one, two : integer) : int64;
begin
  Result:= pow(one, two);
  if (Result < 0) then
    Result:= -1;
  Result:= Result mod n;
end;


procedure createSign(mesage:string);
var
  start, endd, full : integer;
  hsh: int64;

begin
  full:= 0;
  start:= GetTickCount();

  {

  hashCode:= hashH37(mesage);
  reshetoErat();

  generateKeys();
  s := getProizvCheck(hashCode, dexp);
  //generateRsaSignature();

  }
  if not(Form1.Edit3.Text = '') then
    hashCode := StrToInt(Form1.Edit3.Text)
  else
    hashCode := hashH37(mesage);
  reshetoErat();
  generateKeys();
  {}
  n := 33;
  eexp := 3;
  dexp := 7;

  {}
  //s := getProizvCheck(hashCode, dexp);
  genDigitalSignature();

  endd := GetTickCount();
  full:= full + (endd - start);
  //Form1.Label3.Caption:= Form1.Label3.Caption +   '  public and private keys: ' + IntToStr(endd - start);
  Form1.Label3.Caption:= Form1.Label3.Caption + '; time: ' + IntToStr(full);
end;

procedure TForm1.Button1Click(Sender: TObject);
var b,c,d,z, llength:integer;
    a : Int64;
begin
messager:= 'абвгдежзклмнопрстуфх';

messager:= messager + messager;
messager:= messager + messager;
{}
messager:= messager + messager;
{
messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;
{}{
messager:= messager + messager;

messager:= messager + messager;
messager:= messager + messager;

messager:= messager + messager;
messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;

messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
messager:= messager + messager;
}

llength:= Length(messager);
Form1.Label3.Caption:= '';


//NOD(20, (1/7));


createSign(messager);


// результаты вычислений не согласуютс€, подпись = 25, производна€ - 16
// p, q = 3, 11
// n = 33
// ei = 20
// e = 3 d = 7
//a := pow(25, 3) mod 33;

//Form1.Label3.Caption:= IntToStr(a);




Label1.Caption:= '   hash = ' + IntToStr(hashCode) + ' при размере ' + IntTOStr(llength);
Label2.Caption:= 's  = ' + IntTOStr(s);
{}
Label4.Caption:= 'triesToNotSimple + not zeros  = ' + IntToStr(tried)
+ '  dexp = ' + IntToStr(dexp) + '  eexp = ' + IntToStr(eexp) + '  n = ' + IntToStr(n);
end;

// http://www.cyberforum.ru/delphi-beginners/thread1116790.html

// ¬ажно:
// http://sumk.ulstu.ru/docs/mszki/Zavgorodnii/9.4.html

// калькули:
// http://teh-box.ru/informationsecurity/algoritm-shifrovaniya-rsa-na-palcax.html
// https://planetcalc.ru/3311/

procedure TForm1.Button2Click(Sender: TObject);
Var m,n,x,y,g, dex : integer;
begin
  m := StrToInt(Edit1.Text);
  n := StrToInt(Edit2.Text);
  if (m < 0) or (n < 0) then
    begin
      ShowMessage('„исла должны быть натуральными');
      Exit;
    end;

  gcd_ext(m, n, x, y, g);

  dex := (x mod n + n) mod n;
  Form1.Label6.Caption := '  before first ' +  IntToStr(x) + '  before second   ' + IntToStr(y) + ' dex = ' + IntToStr(dex);
  Form1.Label6.Visible:= True;
  ShowMessage(Format('gcd(%d, %d) = %d', [m, n, g]) + #13#10 + Format('%d * %d %s %d * %d = %d', [x, m, Znak(y), Abs(y), n, g]));
end;

procedure TForm1.Button3Click(Sender: TObject);
var proizv : integer;
begin
proizv := getProizvCheck(s, eexp);
Label6.Caption:= IntToStr(proizv);
Label6.Visible:= True;
end;

end.
