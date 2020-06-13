program PwdDicManager;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UFrmDic in 'UFrmDic.pas' {FrmDic},
  UFrmFilters in 'UFrmFilters.pas' {FrmFilters};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmDic, FrmDic);
  Application.CreateForm(TFrmFilters, FrmFilters);
  Application.Run;
end.
