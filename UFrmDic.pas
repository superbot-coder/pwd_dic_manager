unit UFrmDic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, Vcl.ComCtrls, sListView,
  Vcl.StdCtrls, sButton, sDialogs, System.ImageList, Vcl.ImgList, Files, System.IniFiles,
  acProgressBar, Vcl.Menus, sStatusBar, System.StrUtils, sLabel;

type TDicStats = (dsExistes, dsNoFind);

var strArrDicStats: array[TDicStats] of string = ('Есть', 'Отсутствует');

type
  TFrmDic = class(TForm)
    LVDic: TsListView;
    sSkinProvider: TsSkinProvider;
    ImageList: TImageList;
    OpenDialog: TsOpenDialog;
    BtnAdd: TsButton;
    BtnAllDelete: TsButton;
    ProgressBar: TsProgressBar;
    PopMenu: TPopupMenu;
    BtnUpdate: TsButton;
    PM_CheckedSelected: TMenuItem;
    PM_UnCheckedSelected: TMenuItem;
    StatusBar: TsStatusBar;
    PM_Delete: TMenuItem;
    PM_Spliter: TMenuItem;
    procedure BtnAddClick(Sender: TObject);
    procedure SaveDicList;
    procedure LoadDicList;
    function AddItems: Integer;
    procedure GetCoutDic(X: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BtnAllDeleteClick(Sender: TObject);
    procedure PM_CheckedSelectedClick(Sender: TObject);
    procedure PM_UnCheckedSelectedClick(Sender: TObject);
    procedure UpDateStatus;
    procedure BtnUpdateClick(Sender: TObject);
    procedure BlockControls;
    procedure UnblockControls;
    procedure UpdateStusBar;
    function DigitalDesing(strDigitalValue: string): string;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PM_DeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDic: TFrmDic;
  i, x: integer;
  INI: TIniFile;

const
  //dlv_num  =
  dlv_file = 0;
  dlv_sz   = 1;
  dlv_cnt  = 2;
  dlv_stat = 3;

  FileDicLis = 'DicList.ini';
  SECTION    = 'DICTIONARY';

implementation

{$R *.dfm}

USES UFrmMain;

function TFrmDic.AddItems: Integer;
begin
  with LVDic.Items.Add do
  begin
    Caption    := '';
    Checked    := true;
    ImageIndex := -1;
    Caption := IntToStr(Index + 1);
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItems.Add('');
    SubItemImages[0] := 0;
    Result  := Index;
  end;
end;

procedure TFrmDic.BlockControls;
begin
  BtnAdd.Enabled               := false;
  BtnUpdate.Enabled            := false;
  BtnAllDelete.Enabled         := false;
  PM_CheckedSelected.Enabled   := false;
  PM_UnCheckedSelected.Enabled := false;
end;

procedure TFrmDic.BtnAddClick(Sender: TObject);
var
  x, i: integer;
  duple: Boolean;
begin
  if Not OpenDialog.Execute then Exit;

  BlockControls;
  for i := 0 to OpenDialog.Files.Count -1 do
  begin

    duple := false;
    for x := 0 to LVDic.Items.Count -1 do
    begin
      if OpenDialog.Files[i] = LVDic.Items[x].SubItems[dlv_file] then
      begin
        duple := true;
        Break;
      end;
    end;
    if duple then Continue;

    ProgressBar.Position := (i*100) div OpenDialog.Files.Count;
    x := AddItems;
    LVDic.Items[x].SubItems[dlv_file] := OpenDialog.Files[i];
    LVDic.Items[x].SubItems[dlv_sz]   := GetFileSizeFormat(OpenDialog.Files[i]);
    // ileIndict.Caption             := ''
    GetCoutDic(X);
    //LVDic.Items[x].SubItems[dlv_cnt]  := DigitalDesing(IntToStr(GetCoutDic(OpenDialog.Files[i])));

    LVDic.Items[x].SubItems[dlv_stat] := strArrDicStats[dsExistes];
    Application.ProcessMessages;

  end;

  ProgressBar.Position := 100;
  UpdateStusBar;
  SaveDicList;
  UnblockControls;

end;

procedure TFrmDic.BtnAllDeleteClick(Sender: TObject);
begin
  if MessageBox(Handle,
                PChar('Сейчас будет очищен весь список словарей, '+ #13#10
                +'продолжать это действие?' + #13#1
                +'Нажмите "ДА" или "Нет"'),
     PChar(MB_CAPTION), MB_ICONWARNING or MB_YESNO) = ID_NO then Exit;
  LVDic.Clear;
  ProgressBar.Position := 0;
  DeleteFile(CurPath + FileDicLis);
  UpdateStusBar;
end;

procedure TFrmDic.BtnUpdateClick(Sender: TObject);
begin
  UpDateStatus;
end;

function TFrmDic.DigitalDesing(strDigitalValue: string): string;
var i: SmallInt;
    s: string;
begin
  Result := '';
  s := AnsiReverseString(strDigitalValue);
  for i:=1 to length(s) do
  begin
    result := result + s[i];
    if (i mod 3) = 0 then result := result + ' ';
  end;
  Result := AnsiReverseString(Result);
  Result := Trim(Result);
end;

procedure TFrmDic.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ProgressBar.Position := 0;
end;

procedure TFrmDic.FormCreate(Sender: TObject);
begin
  LoadDicList;
  UpdateStusBar;
end;

procedure TFrmDic.GetCoutDic(X: Integer);
var
  fi : TextFile;
  BgnTime: Cardinal;
  CountWords: Integer;
begin

  try
    AssignFile(fi, LVDic.Items[X].SubItems[dlv_file]);
   {R-}
   reset(fi);
   {R+}

   if IOResult <> 0 then
   begin
     LVDic.Items[x].SubItems[dlv_cnt] := '0';
     exit;
   end;

   CountWords  := 0;
   BgnTime := GetTickCount;
   while not Eof(fi) do
   begin
     Readln(fi);
     Inc(CountWords);
     if (GetTickCount - BgnTime) > 500 then
     begin
       BgnTime := GetTickCount;
       LVDic.Items[X].SubItems[dlv_cnt] := DigitalDesing(IntToStr(CountWords));
       Application.ProcessMessages;
     end;
   end;

   LVDic.Items[X].SubItems[dlv_cnt] := DigitalDesing(IntToStr(CountWords));

  finally
    CloseFile(fi)
  end;

end;

procedure TFrmDic.LoadDicList;
var ST: TStrings;
begin
  INI := TIniFile.Create(CurPath + FileDicLis);
  ST  := TStringList.Create;
  try
    INI.ReadSubSections(SECTION, ST);
    if ST.Count = 0 then Exit;
    for I := 0 to ST.Count -1 do
    begin
      x := AddItems;
      LVDic.Items[x].SubItems[dlv_file] := INI.ReadString(SECTION + '\' + ST.Strings[I], 'File','');
      LVDic.Items[x].SubItems[dlv_sz]   := INI.ReadString(SECTION + '\' + ST.Strings[I], 'Size','');
      LVDic.Items[x].SubItems[dlv_cnt]  := INI.ReadString(SECTION + '\' + ST.Strings[I], 'Count','');
      LVDic.Items[x].Checked            := INI.ReadBool(SECTION + '\' + ST.Strings[I], 'Checked', true);

      if FileExists(LVDic.Items[i].SubItems[dlv_file]) then
        LVDic.Items[x].SubItems[dlv_stat] := strArrDicStats[dsExistes]
      else
       LVDic.Items[x].SubItems[dlv_stat] := strArrDicStats[dsNoFind];

    end;
  finally
    INI.Free;
    ST.Free;
  end;

end;

procedure TFrmDic.PM_CheckedSelectedClick(Sender: TObject);
var i: integer;
begin
  if LVDic.Items.Count = 0 then Exit;
  for i:=0 to LVDic.Items.Count -1 do
  begin
    if LVDic.Items[i].Selected then
      LVDic.Items[i].Checked := true
  end;
  SaveDicList;
end;

procedure TFrmDic.PM_DeleteClick(Sender: TObject);
var i: integer;
begin
  if LVDic.Items.Count = 0 then Exit;
  while LVDic.SelCount <> 0 do LVDic.Selected.Delete;
  // перенумерация
  LVDic.Items.BeginUpdate;
  for i:=0 to LVDic.Items.Count -1 do LVDic.Items[i].Caption := IntToStr(i+1);
  LVDic.Items.EndUpdate;
  // Обовление статус бара
  UpdateStusBar;
end;

procedure TFrmDic.PM_UnCheckedSelectedClick(Sender: TObject);
begin
  if LVDic.Items.Count = 0 then Exit;
  for i:=0 to LVDic.Items.Count -1 do
  begin
    if LVDic.Items[i].Selected then
      LVDic.Items[i].Checked := false
  end;
  SaveDicList;
end;

procedure TFrmDic.SaveDicList;
begin
  INI := TIniFile.Create(CurPath + FileDicLis);
  try
    INI.EraseSection(SECTION);
    for i:=0 to LVDic.Items.Count -1 do
    begin
      INI.WriteString(SECTION + '\' + LVDic.Items[i].Caption, 'File', LVDic.Items[i].SubItems[dlv_file]);
      INI.WriteString(SECTION + '\' + LVDic.Items[i].Caption, 'Size', LVDic.Items[i].SubItems[dlv_sz]);
      INI.WriteString(SECTION + '\' + LVDic.Items[i].Caption, 'Count', LVDic.Items[i].SubItems[dlv_cnt]);
      INI.WriteBool(SECTION + '\' + LVDic.Items[i].Caption, 'Checked', LVDic.Items[i].Checked);
    end;
  finally
    INI.Free;
  end;
end;

procedure TFrmDic.UnblockControls;
begin
  BtnAdd.Enabled               := true;
  BtnUpdate.Enabled            := true;
  BtnAllDelete.Enabled         := true;
  PM_CheckedSelected.Enabled   := true;
  PM_UnCheckedSelected.Enabled := true;
end;

procedure TFrmDic.UpDateStatus;
var i: SmallInt;
begin
  if LVDic.Items.Count = 0 then Exit;
  for i:=0 to LVDic.Items.Count -1 do
  begin
    if FileExists(LVDic.Items[i].SubItems[dlv_file]) then
    begin
      if GetFileSizeFormat(LVDic.Items[i].SubItems[dlv_file]) <> LVDic.Items[i].SubItems[dlv_sz] then
      begin
        LVDic.Items[i].SubItems[dlv_sz]  := GetFileSizeFormat(LVDic.Items[i].SubItems[dlv_file]);
        GetCoutDic(i)
        //LVDic.Items[i].SubItems[dlv_cnt] := IntToStr(GetCoutDic(LVDic.Items[i].SubItems[dlv_file]));
      end;
    end
    else
    begin
      LVDic.Items[i].SubItems[dlv_stat] := strArrDicStats[dsNoFind];
    end;
  end;

end;

procedure TFrmDic.UpdateStusBar;
var
  wd_count: integer;
  sz_count: integer;
  fale_count: integer;
begin
  if LVDic.Items.Count = 0 then
  begin
    StatusBar.Panels[0].Text := 'Количество словарей: 0';
    StatusBar.Panels[1].Text := 'Количество слов: 0';
    Exit;
  end;

  StatusBar.Panels[0].Text := 'Количество словарей: ' + IntToStr(LVDic.Items.Count);
  for i:=0 to LVDic.Items.Count-1 do
  begin
    if LVDic.Items[i].SubItems[dlv_cnt] <> '' then
      wd_count := wd_count + StrToInt(StringReplace(LVDic.Items[i].SubItems[dlv_cnt],' ', '', [rfReplaceAll]));
  end;

  StatusBar.Panels[1].Text := 'Количество слов: ' + DigitalDesing(IntToStr(wd_count));

end;

end.
