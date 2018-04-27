unit Material.CEP;

interface

uses
  System.SysUtils, System.Classes, System.JSON, IdHTTP, IdSSLOpenSSL,
  IPPeerClient, REST.Client, FMX.Dialogs, FMX.Forms;

const
  BASE_URL = 'https://viacep.com.br/ws/';

type
  TRetornoCEP = class
  private
    FrUF: string;
    FrComplemento: string;
    FrCidade: string;
    FrLogradouro: string;
    FrIGBE: string;
    FrBairro: string;
    procedure SetrBairro(const Value: string);
    procedure SetrCidade(const Value: string);
    procedure SetrComplemento(const Value: string);
    procedure SetrIGBE(const Value: string);
    procedure SetrLogradouro(const Value: string);
    procedure SetrUF(const Value: string);
  public
    property rLogradouro: string read FrLogradouro write SetrLogradouro;
    property rComplemento: string read FrComplemento write SetrComplemento;
    property rCidade: string read FrCidade write SetrCidade;
    property rBairro: string read FrBairro write SetrBairro;
    property rUF: string read FrUF write SetrUF;
    property rIGBE: string read FrIGBE write SetrIGBE;
  end;

type
  TCEP = class
  private
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    FRetorno: TRetornoCEP;
    procedure SetRetorno(const Value: TRetornoCEP);
  public
    constructor Create;
    destructor  Destroy; override;
    property Retorno: TRetornoCEP read FRetorno write SetRetorno;
    function Buscar(ACEP: string): Boolean;
  end;

var
  CEP: TCEP;

implementation

{ TRetornoCEP }

procedure TRetornoCEP.SetrBairro(const Value: string);
begin
  FrBairro := Value;
end;

procedure TRetornoCEP.SetrCidade(const Value: string);
begin
  FrCidade := Value;
end;

procedure TRetornoCEP.SetrComplemento(const Value: string);
begin
  FrComplemento := Value;
end;

procedure TRetornoCEP.SetrIGBE(const Value: string);
begin
  FrIGBE := Value;
end;

procedure TRetornoCEP.SetrLogradouro(const Value: string);
begin
  FrLogradouro := Value;
end;

procedure TRetornoCEP.SetrUF(const Value: string);
begin
  FrUF := Value;
end;

{ TCEP }

function TCEP.Buscar(ACEP: string): Boolean;
var
  rCEP: TJSONObject;
  vCEP, ErroCEP: string;
begin
  Result  := False;
  vCEP    := StringReplace(ACEP, '-', '', [rfReplaceAll]);

  if (Length(vCEP) = 8) then
   begin
    RESTRequest.Params.AddUrlSegment('CEP', ACEP);
    RESTRequest.Execute;

    rCEP := RESTResponse.JSONValue as TJSONObject;
    rCEP.TryGetValue('erro', ErroCEP);
    if ErroCEP = 'true' then
     Exit;

    FRetorno              := TRetornoCEP.Create;
    Retorno.rLogradouro   := rCEP.GetValue('logradouro').Value;
    Retorno.rComplemento  := rCEP.GetValue('complemento').Value;
    Retorno.rBairro       := rCEP.GetValue('bairro').Value;
    Retorno.rCidade       := rCEP.GetValue('localidade').Value;
    Retorno.rUF           := rCEP.GetValue('uf').Value;
    Retorno.rIGBE         := rCEP.GetValue('ibge').Value;
    Result                := True;
  end;
end;

constructor TCEP.Create;
begin
  RESTClient                := TRESTClient.Create(BASE_URL);
  RESTRequest               := TRESTRequest.Create(RESTClient);
  RESTResponse              := TRESTResponse.Create(RESTClient);

  RESTRequest.Client        := RESTClient;
  RESTRequest.Response      := RESTResponse;
  RESTResponse.ContentType  := 'application/json';
  RESTRequest.Resource      := '{CEP}/json';
end;

destructor TCEP.Destroy;
begin
  RESTClient.DisposeOf;
  FRetorno.DisposeOf;
  inherited;
end;

procedure TCEP.SetRetorno(const Value: TRetornoCEP);
begin
  FRetorno := Value;
end;

Initialization

CEP := TCEP.Create;

end.
