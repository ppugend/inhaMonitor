unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs
  ,windows
  ;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;


const
  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;
  LWA_BOTH = 3;
  WS_EX_LAYERED = $80000;
  GWL_EXSTYLE = -20;


 {Function SetLayeredWindowAttributes Lib "user32" (ByVal hWnd As Long, ByVal Color As Long, ByVal X As Byte, ByVal alpha As Long) As Boolean }
 function SetLayeredWindowAttributes (hWnd:Longint; Color:Longint; X:Byte; alpha:Longint):bool stdcall; external 'USER32';

 {not sure how to alias these functions here ????   alias setwindowlonga!!}
 {Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long }
 Function SetWindowLongA (hWnd:Longint; nIndex:longint; dwNewLong:longint):longint stdcall; external 'USER32';


 {Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hWnd As Long, ByVal nIndex As Long) As Long }
 Function GetWindowLongA ( hWnd:Longint; nIndex:longint):longint stdcall; external 'user32';


implementation

{$R *.lfm}
var
   colors:array[0..6] of TColor;

procedure SetTranslucent(ThehWnd: Longint; Color: Longint; nTrans: Integer);
var
attrib:longint;


begin

    {SetWindowLong and SetLayeredWindowAttributes are API functions, see MSDN for details }

    attrib := GetWindowLongA(ThehWnd, GWL_EXSTYLE);

    SetWindowLongA (ThehWnd, GWL_EXSTYLE, attrib Or WS_EX_LAYERED);

    {anything with color value color will completely disappear if flag = 1 or flag = 3  }

    SetLayeredWindowAttributes (ThehWnd, Color, nTrans,1);

end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var

   transparency:longint;

begin



     {the color were going to make transparent the red that the form backgroud is set to}
     transparency:=  $00090909;

     {call the function to do it}
     SetTranslucent (form1.Handle, transparency, 0);



    colors[0]:=TColor($000000FF);
    colors[1]:=TColor($0000FF00);
    colors[2]:=TColor($00FF0000);
    colors[3]:=TColor($00FFFF00);
    colors[4]:=TColor($00FF00FF);
    colors[5]:=TColor($0000FFFF);
    colors[6]:=TColor($00000000);


end;

procedure TForm1.FormPaint(Sender: TObject);
var
   i:integer;
   target : integer;
   x:integer;
begin

     Randomize;
     target:=Random(30)+10;
     for i:=0 to target do
     begin
       Canvas.Pen.Color:=colors[Random(6+1)];
       x:=Random(Screen.Width);
       Canvas.Line(x,0,x,Screen.Height);
     end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Top:=0;
  Left:=0;
  Width:= Screen.Width;
  Height:=Screen.Height;
  WindowState := wsFullScreen;
end;

end.

