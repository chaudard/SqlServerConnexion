unit ApplicationGUI;
{
based on :
https://www.youtube.com/watch?v=XUwTfBD5V1w
https://www.youtube.com/watch?v=0VN9o2s63Fk
http://docwiki.embarcadero.com/RADStudio/Tokyo/fr/Framework_d%27objets_JSON
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DBCtrls, Grids, DBGrids, DB, ADODB
  , Connector
  , DBXJson
  ;

type
  TApplicationGUIForm = class(TForm)
    ADOConnection1: TADOConnection;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    btnConnectAndDisplayTable: TButton;
    lbUseNavigator: TLabel;
    gbDatasConnexion: TGroupBox;
    rgSecurity: TRadioGroup;
    gbUserPassword: TGroupBox;
    lbUser: TLabel;
    lbPassWord: TLabel;
    edUser: TEdit;
    edPassword: TEdit;
    gbTarget: TGroupBox;
    lbDataSource: TLabel;
    edDataSource: TEdit;
    lbCatalog: TLabel;
    edCatalog: TEdit;
    lbTable: TLabel;
    edTable: TEdit;
    procedure btnConnectAndDisplayTableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgSecurityClick(Sender: TObject);
  private
    { Déclarations privées }
    function ObjectToJSON(AData: TObject): TJSONValue;
    function JSONToObject(AJSONValue: TJSONValue): TObject;
    procedure InitConfig;
    function getApplicationDirectory: string;
    function getConfigFileName: string;
    procedure saveDatasConnexion(const aConnector: TConnector);
    procedure saveConnector(const aConnector: TConnector);
    function getConnectorFromFields: TConnector;
    procedure setFieldsWithConnector(const aConnector: TConnector);
    function getLoadedJson: string;
    function chooseUserPassword: boolean;
    function chooseIntegratedSecurityOfWindowsNT: boolean;
    procedure setChooseSecurity(const vbUserPassword: boolean);
    function isValidConnector(const aConnector: TConnector): boolean;
    function getConnexionString(const aConnector: TConnector): string;
    procedure connexionAndDisplay(const aConnexionString: string; const aConnector: TConnector);
  public
    { Déclarations publiques }
  end;

var
  ApplicationGUIForm: TApplicationGUIForm;

implementation

uses
  DBXJSONReflect;

const
  CONFIG_FILENAME = 'SqlServerConnexion.config.json';
  CONNEXION_SUCCESS = 'connexion established. SUCCESS !';
  CONNEXION_FAILED = 'connexion NOT established.';
  UNVALID_CONNECTOR = 'unvalid connector';
  CONNEXION_STRING_USER_PASSWORD = 'User id=%s;Password=%s';
  CONNEXION_STRING_INTEGRATED_SECURITY = 'Integrated Security=SSPI';
  CONNEXION_STRING = 'Provider=SQLOLEDB.1;Persist Security Info=False;%s;Initial Catalog=%s;Data Source=%s';
  CAN_NOT_LOAD_CONFIG = 'can not load the config file.';
  CAN_NOT_SAVE_CONFIG = 'can not save the config file.';

{$R *.dfm}

procedure TApplicationGUIForm.btnConnectAndDisplayTableClick(Sender: TObject);
var
  vConnector: TConnector;
  vConnexionString: string;
begin
  vConnector := getConnectorFromFields;
  try
    if isValidConnector(vConnector) then
    begin
      vConnexionString := getConnexionString(vConnector);
      connexionAndDisplay(vConnexionString, vConnector);
      saveDatasConnexion(vConnector);
    end
    else
      showmessage(UNVALID_CONNECTOR);
  finally
    vConnector.Free;
  end;
end;

function TApplicationGUIForm.chooseIntegratedSecurityOfWindowsNT: boolean;
begin
  result := rgSecurity.ItemIndex = 0;
end;

function TApplicationGUIForm.chooseUserPassword: boolean;
begin
  result := rgSecurity.ItemIndex = 1;
end;

procedure TApplicationGUIForm.connexionAndDisplay(
  const aConnexionString: string;
  const aConnector: TConnector);
begin
  ADOConnection1.Connected := false;
  ADOConnection1.ConnectionString := aConnexionString;
  ADOConnection1.LoginPrompt := false;
  ADOConnection1.Connected := true;
  if ADOConnection1.Connected then
    showmessage(CONNEXION_SUCCESS)
  else
    showmessage(CONNEXION_FAILED);

  ADOTable1.Connection := ADOConnection1;
  if assigned(aConnector) then
    ADOTable1.TableName := aConnector.tableName
  else
    ADOTable1.TableName := '';
  ADOTable1.Active := true;

  DataSource1.DataSet := ADOTable1;

  DBGrid1.DataSource := DataSource1;
  DBNavigator1.DataSource := DataSource1;
end;

procedure TApplicationGUIForm.FormCreate(Sender: TObject);
begin
  initConfig;
end;

function TApplicationGUIForm.getApplicationDirectory: string;
begin
  result := ExtractFileDir(Application.ExeName);
end;

function TApplicationGUIForm.getConfigFileName: string;
begin
  result := IncludeTrailingPathDelimiter(getApplicationDirectory) + CONFIG_FILENAME;
end;

function TApplicationGUIForm.getConnectorFromFields: TConnector;
var
  vDataSource: string;
  vCatalog: string;
  vTableName: string;
  vbUserPassword: boolean;
  vUser: string;
  vPassword: string;
begin
  vDataSource := edDataSource.Text;
  vCatalog := edCatalog.Text;
  vTableName := edTable.Text;
  vbUserPassword := chooseUserPassword;
  vUser := edUser.Text;
  vPassword := edPassword.Text;
  result := TConnector.Create(vDataSource,
                              vCatalog,
                              vTableName,
                              vbUserPassword,
                              vUser,
                              vPassword);
end;

function TApplicationGUIForm.getConnexionString(
  const aConnector: TConnector): string;
var
  vSecurityString: string;
begin
  result := '';
  if assigned(aConnector) then
  begin
    if aConnector.bUserPassword then
      vSecurityString := format(CONNEXION_STRING_USER_PASSWORD,[aConnector.user, aConnector.password])
    else
      vSecurityString := CONNEXION_STRING_INTEGRATED_SECURITY;
    result := format(CONNEXION_STRING,[vSecurityString, aConnector.catalog, aConnector.dataSource]);
  end;
end;

function TApplicationGUIForm.getLoadedJson: string;
var
  vConfigFileName: string;
  vJsonToLoad: TStringList;
begin
  result := '';
  vConfigFileName := getConfigFileName;
  // check if CONFIG_FILENAME exists
  if FileExists(vConfigFileName) then
  begin
    vJsonToLoad := TStringList.Create;
    try
      try
        vJsonToLoad.LoadFromFile(vConfigFileName);
        result := vJsonToLoad[0];
      except on E: exception do
        outputdebugstring(PWideChar(CAN_NOT_LOAD_CONFIG + E.Message));
      end;
    finally
      vJsonToLoad.Free;
    end;
  end;
end;

procedure TApplicationGUIForm.InitConfig;
var
  vLoadedJson: string;
  vJSONValue: TJSONValue;
  vConnector: TConnector;
  vbytes: TBytes;
begin
  // deserialize json
  vLoadedJson := getLoadedJson;
  vbytes:=TEncoding.UTF8.GetBytes(vLoadedJson);
  vJSONValue := TJSONObject.ParseJSONValue(vbytes,0);
  if assigned(vJSONValue) then
  begin
    vConnector := JSONToObject(vJSONValue) as TConnector;
    if assigned(vConnector) then
    begin
      // fill fields
      setFieldsWithConnector(vConnector);
      vConnector.Free;
    end;
    vJSONValue.Free;
  end;
end;

function TApplicationGUIForm.isValidConnector(
  const aConnector: TConnector): boolean;
begin
  result := false;
  if assigned(aConnector) then
  begin
    result :=
          (aConnector.dataSource <> '')
      and (aConnector.catalog <> '')
      and (aConnector.tableName <> '');
    if result then
    begin
      if aConnector.bUserPassword then
      begin
        result :=
              (aConnector.user <> '')
          and (aConnector.password <> '');
      end;
    end;
  end;
end;

function TApplicationGUIForm.JSONToObject(AJSONValue: TJSONValue): TObject;
var
  vUnMarshal: TJSONUnMarshal;
begin
   vUnMarshal := TJSONUnMarshal.Create();
   try
     Result := vUnMarshal.Unmarshal(AJSONValue);
   finally
     FreeAndNil(vUnMarshal);
   end;
end;

function TApplicationGUIForm.ObjectToJSON(AData: TObject): TJSONValue;
var
  vMarshal: TJSONMarshal;
begin
  vMarshal := TJSONMarshal.Create(TJSONConverter.Create);
  try
    Result := vMarshal.Marshal(AData);
  finally
    FreeAndNil(vMarshal);
  end;
end;

procedure TApplicationGUIForm.rgSecurityClick(Sender: TObject);
begin
  gbUserPassword.Enabled := chooseUserPassword;
end;

procedure TApplicationGUIForm.saveConnector(const aConnector: TConnector);
var
  vJSONValue: TJSONValue;
  vJsonToSave: TStringList;
begin
  if assigned(aConnector) then
  begin
    // serialize the connector
    vJSONValue := ObjectToJSON(aConnector);
    vJsonToSave := TStringList.Create;
    try
      vJsonToSave.Add(vJSONValue.ToString);
      try
      vJsonToSave.SaveToFile(getConfigFileName);
      except on E: exception do
        outputdebugstring(PWideChar(CAN_NOT_SAVE_CONFIG + E.Message));
      end;
    finally
      vJsonToSave.Free;
      vJSONValue.Free;
    end;
  end;
end;

procedure TApplicationGUIForm.saveDatasConnexion(const aConnector: TConnector);
begin
  if assigned(aConnector) then
    saveConnector(aConnector);
end;

procedure TApplicationGUIForm.setChooseSecurity(const vbUserPassword: boolean);
begin
  if vbUserPassword then
    rgSecurity.ItemIndex := 1
  else
    rgSecurity.ItemIndex := 0;
end;

procedure TApplicationGUIForm.setFieldsWithConnector(
  const aConnector: TConnector);
begin
  if assigned(aConnector) then
  begin
    edDataSource.Text := aConnector.dataSource;
    edCatalog.Text := aConnector.catalog;
    edTable.Text := aConnector.tableName;

    gbUserPassword.Enabled := true; // activate to fill datas
    edUser.Text := aConnector.user;
    edPassword.Text := aConnector.password;

    setChooseSecurity(aConnector.bUserPassword);
  end;
end;

end.
