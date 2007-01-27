program Helios;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  Socket in 'Common\Socket.pas',
  PacketTypes in 'Common\PacketTypes.pas',
  AccountTypes in 'Common\AccountTypes.pas',
  Globals in 'Common\Globals.pas',
  List32 in 'Common\3rdParty\List32.pas',
  Database in 'Database\Database.pas',
  CharaServerTypes in 'Character\CharaServerTypes.pas',
  Commands in 'Commands.pas',
  CharaServerPacket in 'Character\CharaServerPacket.pas',
  LoginProcesses in 'Login\LoginProcesses.pas';

{$R *.res}

begin
	Application.Initialize;
	Application.Title := 'Helios - Login Server';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
