unit UFrmFilters;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.StdCtrls, sButton,
  sMemo, sGroupBox, sEdit, sSpinEdit, sCheckBox, sLabel, System.IniFiles,
  sDialogs, sRadioButton ;

type
  TFrmFilters = class(TForm)
    sSkinProvider: TsSkinProvider;
    GrBoxRestricLengrh: TsGroupBox;
    lblRestricMinLength: TsLabel;
    lblRestricMaxLength: TsLabel;
    ChBoxRestricLength: TsCheckBox;
    SpEdMinLength: TsSpinEdit;
    SpEdMaxLength: TsSpinEdit;
    GrBoxConvertCase: TsGroupBox;
    ChBoxConvertCase: TsCheckBox;
    RdGrpConvertCase: TsRadioGroup;
    GrBoxExclude: TsGroupBox;
    EdExcludeSymbolsIn: TsEdit;
    ChBoxExcludeSymbolsEnabled: TsCheckBox;
    ChBoxExcludeWords: TsCheckBox;
    mmExcludeWords: TsMemo;
    BtnOpenList: TsButton;
    ChBoxNoDuplicat: TsCheckBox;
    BtnOk: TsButton;
    sOpenDialog: TsOpenDialog;
    EdExcludeSymbolsOf: TsEdit;
    RdBtnExcludeSymbolsIn: TsRadioButton;
    RdBtnExcludeSymbolsOf: TsRadioButton;
    GrBoxExclude2: TsGroupBox;
    procedure BtnOkClick(Sender: TObject);
    Procedure SaveConfig;
    procedure LoadConfig;
    procedure BtnOpenListClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpEdMaxLengthChange(Sender: TObject);
    procedure SpEdMinLengthChange(Sender: TObject);
    function ExtractStrFromBracket(StrVal: String): String;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFilters: TFrmFilters;
  INI: TIniFile;
  FileExcludeWords: String;

const
   FileFilterCfg = 'FilterConfig.ini';
   SECTION = 'FILTERS';

implementation

USES UFrmMain;

{$R *.dfm}

procedure TFrmFilters.BtnOkClick(Sender: TObject);
begin
  SaveConfig;
  Close;
end;

procedure TFrmFilters.BtnOpenListClick(Sender: TObject);
begin
  if Not sOpenDialog.Execute then Exit;
  mmExcludeWords.Lines.LoadFromFile(sOpenDialog.FileName);
  FileExcludeWords := sOpenDialog.FileName;
end;

function TFrmFilters.ExtractStrFromBracket(StrVal: String): String;
begin
  Result := StrVal;
  Delete(Result, 1, 1);
  Delete(Result, Length(Result), 1);
end;

procedure TFrmFilters.FormCreate(Sender: TObject);
begin
  RdBtnExcludeSymbolsOf.Checked := true;
  LoadConfig;
end;

procedure TFrmFilters.LoadConfig;
var s: string;
begin
  INI := TIniFile.Create(CurPath + FileFilterCfg);
  try
    ChBoxRestricLength.Checked := INI.ReadBool(SECTION, 'RestricLength', false);
    SpEdMinLength.Value := INI.ReadInteger(SECTION, 'MinLength', 2);
    SpEdMaxLength.Value := INI.ReadInteger(SECTION, 'MaxLength', 64);
    ChBoxConvertCase.Checked := INI.ReadBool(SECTION, 'ConvertCase', false);
    RdGrpConvertCase.ItemIndex := INI.ReadInteger(SECTION, 'ConvertCaseItemIndex', 0);
    ChBoxNoDuplicat.Checked := INI.ReadBool(SECTION, 'NoDuplicate', false);
    ChBoxExcludeSymbolsEnabled.Checked := INI.ReadBool(SECTION, 'ExcludeSymbolsEnabled', false);
    RdBtnExcludeSymbolsIn.Checked := INI.ReadBool(SECTION, 'ExcludeSymbolsIn', false);
    RdBtnExcludeSymbolsOf.Checked := INI.ReadBool(SECTION, 'ExcludeSymbolsOf', false);
    EdExcludeSymbolsOf.Text := ExtractStrFromBracket(INI.ReadString(SECTION, 'SymbolsOf',''));
    EdExcludeSymbolsIn.Text := ExtractStrFromBracket(INI.ReadString(SECTION, 'SymbolsIn', ''));
    ChBoxExcludeWords.Checked := INI.ReadBool(SECTION, 'ExcludeWords', false);
    FileExcludeWords := INI.ReadString(SECTION, 'ExcludeWordsFile','');
    if FileExists(FileExcludeWords) then mmExcludeWords.Lines.LoadFromFile(FileExcludeWords);
  finally
    INI.Free;
  end;

end;

procedure TFrmFilters.SaveConfig;
begin
  INI := TIniFile.Create(CurPath + FileFilterCfg);
  try
    INI.WriteBool(SECTION, 'RestricLength', ChBoxRestricLength.Checked);
    INI.WriteInteger(SECTION, 'MinLength', SpEdMinLength.Value);
    INI.WriteInteger(SECTION, 'MaxLength', SpEdMaxLength.Value);
    INI.WriteBool(SECTION, 'ConvertCase', ChBoxConvertCase.Checked);
    INI.WriteInteger(SECTION, 'ConvertCaseItemIndex', RdGrpConvertCase.ItemIndex);
    INI.WriteBool(SECTION, 'NoDuplicate', ChBoxNoDuplicat.Checked);
    INI.WriteBool(SECTION, 'ExcludeSymbolsEnabled', ChBoxExcludeSymbolsEnabled.Checked);
    INI.WriteBool(SECTION, 'ExcludeSymbolsIn', RdBtnExcludeSymbolsIn.Checked);
    INI.WriteBool(SECTION, 'ExcludeSymbolsOf', RdBtnExcludeSymbolsOf.Checked);
    INI.WriteString(SECTION, 'SymbolsIn', '['+EdExcludeSymbolsIn.Text+']');
    INI.WriteString(SECTION, 'SymbolsOf', '['+EdExcludeSymbolsOf.Text+']');
    INI.WriteBool(SECTION, 'ExcludeWords', ChBoxExcludeWords.Checked);
    INI.WriteString(SECTION, 'ExcludeWordsFile', FileExcludeWords);
  finally
    INI.Free;
  end;

end;

procedure TFrmFilters.SpEdMaxLengthChange(Sender: TObject);
begin
  if SpEdMaxLength.Value < SpEdMinLength.Value then
    SpEdMinLength.Value := SpEdMaxLength.Value;
end;

procedure TFrmFilters.SpEdMinLengthChange(Sender: TObject);
begin
  if SpEdMinLength.Value > SpEdMaxLength.Value then
    SpEdMaxLength.Value := SpEdMinLength.Value;
end;

end.
