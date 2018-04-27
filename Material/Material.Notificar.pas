unit Material.Notificar;

interface

uses
  System.SysUtils, FMX.Types, System.Threading, System.Types, FMX.Controls,
  System.UITypes, FMX.Forms, System.Classes, FMX.Ani, System.Variants,
  FMX.Objects, FMX.Effects;

type
  INotificar = interface
    ['{5391DF06-E884-4166-A821-E6C437D4023B}']
    procedure Push(AMensagem: string; ATempo: Single);
  end;

  TNotificar = class(TInterfacedObject, INotificar)
  private
    FSubir: TFloatAnimation;
    FDescer: TFloatAnimation;
    FShadow: TShadowEffect;
    FContents: TRectangle;
    FMensagem: TText;
  public
    procedure Push(AMensagem: string; ATempo: Single);
  end;

var
  Notificar: TNotificar;

implementation

{ TNotificar }

procedure TNotificar.Push(AMensagem: string; ATempo: Single);
var
  Task: ITask;
begin
  if Assigned(FContents) then
    FContents.DisposeOf;

  Task := TTask.Create(
    procedure
    begin
      FContents := TRectangle.Create(Application);
      FContents.Stroke.Thickness := 0;
      FContents.Parent := Screen.ActiveForm;
      FContents.Align := TAlignLayout.Bottom;
      FContents.Fill.Color := $FF323232;

      FShadow := TShadowEffect.Create(FContents);
      FShadow.Parent := FContents;
      FShadow.Direction := -90;
      FShadow.Distance := 5;
      FShadow.Opacity := 0.1;
      FShadow.Softness := 0.3;

      FMensagem := TText.Create(FContents);
      FMensagem.Parent := FContents;
      FMensagem.Align := TAlignLayout.Client;
      FMensagem.TextSettings.FontColor := TAlphaColorRec.White;
      FMensagem.TextSettings.Font.Size := 14;
      FMensagem.TextSettings.Font.Family := 'Roboto';
      FMensagem.Text := AMensagem;

      FSubir := TFloatAnimation.Create(FContents);
      FSubir.Parent := FContents;
      FSubir.Duration := 0.2;
      FSubir.PropertyName := 'Height';
      FSubir.StartValue := 0;
      FSubir.StopValue := 50;

      FDescer := TFloatAnimation.Create(FContents);
      FDescer.Parent := FContents;
      FDescer.Delay := ATempo;
      FDescer.Duration := 0.2;
      FDescer.PropertyName := 'Height';
      FDescer.StartValue := 50;
      FDescer.StopValue := 0;

      TThread.Queue(nil,
        procedure
        begin
          FSubir.Start;
          FDescer.Start;
        end);
    end);
  Task.Start;
end;

Initialization

Notificar := TNotificar.Create;

end.
