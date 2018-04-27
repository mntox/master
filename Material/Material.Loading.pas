unit Material.Loading;

interface

uses
  System.SysUtils, FMX.Types, System.Threading, System.Types, FMX.Controls,
  System.UITypes, FMX.Forms, System.Classes, FMX.Ani, System.Variants,
  FMX.Objects;

const
  SVG = 'M251.339004516602, 93.7679977416992 C250.356994628906, 90.2320022583008 246.705001831055,'
    + '88.1549987792969 243.154006958008, 89.140998840332 C239.617004394531, 90.1230010986328 237.544006347656,'
    + '93.7870025634766 238.526000976563, 97.3239974975586 C241.29899597168, 107.30899810791 242.703994750977,'
    + '117.629997253418 242.703994750977, 128 C242.703994750977, 191.248001098633 191.248001098633,'
    + '242.701995849609 128,242.701995849609 C64.7519989013672, 242.701995849609 13.2969999313354,'
    + '191.248001098633 13.2969999313354, 128 C13.2969999313354, 64.7509994506836 64.7519989013672,'
    + '13.2959995269775 128,13.2959995269775 C154.792999267578, 13.2959995269775 180.718002319336,'
    + '22.8139991760254 201.179000854492, 39.7519989013672 C200.382995605469, 41.6520004272461 199.940994262695,'
    + '43.7369995117188 199.940994262695, 45.9249992370605 C199.940994262695, 54.7599983215332 207.102996826172,'
    + '61.9220008850098 215.938003540039, 61.9220008850098 C224.772994995117, 61.9220008850098 231.934997558594,'
    + '54.7599983215332 231.934997558594,45.9249992370605 C231.934997558594, 37.0900001525879 224.772994995117,'
    + '29.92799949646 215.938003540039,29.92799949646 C214.236999511719, 29.92799949646 212.600006103516,'
    + '30.1989994049072 211.061996459961, 30.6909999847412 C188.022003173828, 11.0559997558594 158.513000488281,'
    + '0 128,0 C57.4210014343262,0 0, 57.4199981689453 0,128 C0,198.578994750977 57.4210014343262,'
    + '255.998992919922 128,255.998992919922 C198.578994750977,255.998992919922 256, 198.578994750977 256,128 C256,'
    + '116.428001403809 254.432998657227, 104.910003662109 251.339004516602, 93.7679977416992 Z';

type
  ILoarding = interface
    ['{F703A37A-239E-4238-9537-BDC3EE6891C7}']
    procedure Mostrar;
    procedure Ocultar;
  end;

  TLoarding = class(TInterfacedObject, ILoarding)
  private
    FAniLoard: TFloatAnimation;
    FContents: TRectangle;
    FIcone: TPath;
  public
    procedure Ocultar;
    procedure Mostrar;
  end;

var
  Load: TLoarding;

implementation

{ TLoarding }

procedure TLoarding.Mostrar;
var
  Task: ITask;
begin
  Task := TTask.Create(
    procedure
    begin
      if not Assigned(FContents) then
      begin
        FContents := TRectangle.Create(Application);
        FContents.Parent := Screen.ActiveForm;
        FContents.Align := TAlignLayout.Contents;
        FContents.Fill.Color := $F00F151D;

        FIcone := TPath.Create(FContents);
        FIcone.Parent := FContents;
        FIcone.Data.Data := SVG;
        FIcone.Height := 64;
        FIcone.Width := 64;
        FIcone.Align := TAlignLayout.Center;
        FIcone.Fill.Color := TAlphaColorRec.White;

        FAniLoard := TFloatAnimation.Create(FContents);
        FAniLoard.Parent := FIcone;
        FAniLoard.Duration := 0.8;
        FAniLoard.Loop := True;
        FAniLoard.PropertyName := 'RotationAngle';
        FAniLoard.StartValue := 0;
        FAniLoard.StopValue := 360;

        TThread.Queue(nil,
          procedure
          begin
            FAniLoard.Start;
          end);
        Exit;
      end;
      TThread.Queue(nil,
        procedure
        begin
          FContents.Visible := True;
          FAniLoard.Start;
        end);
    end);
  Task.Start;
end;

procedure TLoarding.Ocultar;
begin
  FContents.Visible := False;
end;

Initialization

Load := TLoarding.Create;

end.
