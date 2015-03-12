unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.MPlayer, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    edPomodoroTime: TEdit;
    edShortBreakTime: TEdit;
    edLongBreakTime: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    btnStart: TButton;
    btnReset: TButton;
    btnStop: TButton;
    Timer1: TTimer;
    MediaPlayer1: TMediaPlayer;
    Memo1: TMemo;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Label2: TLabel;
    edTimeLeft: TEdit;
    btnAbout: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure DoMessage(Sender : TObject);
    procedure btnAboutClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

  SecondsCount : integer;
  MinutesCount : integer;

  CurrentTimer : integer;
  TimerActive : boolean;

  AboutShowing: Boolean;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TimerActive:=false;
  RadioButton1.Checked:=true;
  CurrentTimer:=25;
  //MediaPlayer1.FileName:= ExtractFileDir(Application.ExeName)+'\sound.wav';
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
  if RadioButton1.Checked then
    CurrentTimer:=StrToInt(edPomodoroTime.Text)
  else if RadioButton2.Checked then
    CurrentTimer:=StrToInt(edShortBreakTime.Text)
  else if RadioButton3.Checked then
    CurrentTimer:=StrToInt(edLongBreakTime.Text);

  MinutesCount:=CurrentTimer;
  SecondsCount:=0;
  TimerActive:=true;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  if AboutShowing then
   frmMain.Width:=298
  else
   frmMain.Width:=514;
   AboutShowing:= not AboutShowing;
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  MinutesCount:=CurrentTimer;
  SecondsCount:=0;
  TimerActive:=true;
end;

procedure TfrmMain.btnStopClick(Sender: TObject);
begin
  TimerActive:=false;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
var
  secondsPresentation : string;
  minutesPresentation : string;
begin
if TimerActive then
begin
  Inc(SecondsCount,-1);
  if SecondsCount=-1 then
    begin
     Inc(MinutesCount,-1);
     SecondsCount:=59;
    end;

  if MinutesCount<0 then
  begin
    TimerActive:=false;
    MinutesCount:=0;
    SecondsCount:=0;
      DoMessage(Self);
  end;

  if SecondsCount<=9 then
    secondsPresentation:='0'+ IntToStr(SecondsCount)
  else
    secondsPresentation:= IntToStr(SecondsCount);

  if MinutesCount<=9 then
    MinutesPresentation:='0'+ IntToStr(MinutesCount)
  else
    MinutesPresentation:= IntToStr(MinutesCount);

  edTimeLeft.Text:=MinutesPresentation + ':' + secondsPresentation;
  frmMain.Caption:= 'Pomodoro ' + MinutesPresentation + ':' + secondsPresentation;
end;
end;

procedure TfrmMain.DoMessage (Sender : TObject);
begin
  MediaPlayer1.FileName:=ExtractFileDir(Application.ExeName)+'\sound.wav';
  MediaPlayer1.Wait:=true;
  MediaPlayer1.Open;

 MediaPlayer1.Play;
end;

end.
