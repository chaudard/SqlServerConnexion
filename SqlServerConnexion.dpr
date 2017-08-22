program SqlServerConnexion;

uses
  Forms,
  ApplicationGUI in 'ApplicationGUI.pas' {ApplicationGUIForm},
  Connector in 'Connector.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TApplicationGUIForm, ApplicationGUIForm);
  Application.Run;
end.
