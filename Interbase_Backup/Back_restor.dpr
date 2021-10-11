program Back_restor;

uses
  Forms,
  main in 'main.pas' {Form_main};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '';
  Application.CreateForm(TForm_main, Form_main);
  Application.Run;
end.
