unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, System.Actions,
  Vcl.ActnList, Vcl.Menus, Vcl.StdCtrls, sButton, Vcl.ComCtrls, sStatusBar,
  sMemo, Vcl.ExtCtrls, sPanel, sGauge, sComboBoxes, Vcl.Mask, sMaskEdit,
  sCustomComboEdit, sToolEdit, sComboBox, sLabel, sEdit, sGroupBox, TimeFormat,
  sSpinEdit, System.RegularExpressions, sCheckBox, sRadioButton,
  sListView, System.ImageList, Vcl.ImgList, acImage, System.Win.Registry, Files, GetVer,
  sSplitter, System.StrUtils, System.Math, sSkinProvider;

type TLockCtrls = (LockCtrls, UnLockCtrls);
type TProcessingStatus = (tpsLoadFile, tpsProcess, tpsError, tpsComplete, tpsStoped, tpsWaiting);
var strTPSArray: array[TProcessingStatus] of string =
                ('Чтение файла', 'Обработка', 'Ошибка', 'Выполнено', 'Остановленo', 'Очередь');
var strExtArray: array[0..3] of string = ('.txt', '.dic', '.lst', '');

type
  TFrmMain = class(TForm)
    SkinMan: TsSkinManager;
    MainMenu: TMainMenu;
    ActionList: TActionList;
    sButton1: TsButton;
    StatusBar: TsStatusBar;
    MM_Files: TMenuItem;
    MM_Exit: TMenuItem;
    MM_Dictionary: TMenuItem;
    sGauge: TsGauge;
    DirEditExport: TsDirectoryEdit;
    EdExportFileDic: TsEdit;
    LblExportFileDic: TsLabel;
    CmBoxFileExt: TsComboBox;
    CmBoxSuffix: TsComboBox;
    CmBoxMaxCount: TsComboBox;
    LblMaxCount: TsLabel;
    BtnStop: TsButton;
    Act_Stop: TAction;
    LblProcess: TsLabel;
    GrBoxProcStatus: TsGroupBox;
    LbLProcessCount: TsLabel;
    LblAdded: TsLabel;
    LblAddedCount: TsLabel;
    LblCurrProсDicStatic: TsLabel;
    LblDirExport: TsLabel;
    Act_Start: TAction;
    LblProcessTime: TsLabel;
    LblProcessTimeCount: TsLabel;
    LblProcDicStat: TsLabel;
    sLabel2: TsLabel;
    lblRestProcDicStat: TsLabel;
    LblCurrProcDic: TsLabel;
    LblProcessor: TsLabel;
    GrBoxSaveFile: TsGroupBox;
    lblProcDicCount: TsLabel;
    LblRestProcDicCount: TsLabel;
    MM_FiltersShow: TMenuItem;
    LVInp: TsListView;
    ImageList: TImageList;
    TmrGetStatus: TTimer;
    LblDupStat: TsLabel;
    LblDubCount: TsLabel;
    ChBoxOneInOne: TsCheckBox;
    LVout: TsListView;
    ImgCPU: TsImage;
    PanelBoard: TsPanel;
    Splitter: TsSplitter;
    GrBoxSearch: TsGroupBox;
    edSearch: TsEdit;
    LblSearch: TsLabel;
    RdBttnSelectedDic: TsRadioButton;
    RdBtnAllDic: TsRadioButton;
    BtnStartSearch: TsButton;
    BtnStopSearch: TsButton;
    Act_Search: TAction;
    mm: TsMemo;
    sSkinProvider: TsSkinProvider;
    sSkinSelector1: TsSkinSelector;
    Act_StartDuple: TAction;
    Test: TsButton;
    procedure FormCreate(Sender: TObject);
    procedure Act_StopExecute(Sender: TObject);
    procedure Act_StartExecute(Sender: TObject);
    procedure MM_FiltersShowClick(Sender: TObject);
    procedure LockControls(LockStatus: TLockCtrls; Sender: TObject);
    procedure MM_DictionaryClick(Sender: TObject);
    function AddLVitem: integer;
    procedure TmrGetStatusTimer(Sender: TObject);
    function AddLVout: integer;
    function GetExportFileName(MaskLen, x: integer): String;
    function CreateNameFileOverSize(FileName: String; x: SmallInt): String;
    procedure ChBoxOneInOneClick(Sender: TObject);
    function GetProcessorName: string;
    procedure Act_SearchExecute(Sender: TObject);
    procedure MM_ExitClick(Sender: TObject);
    function DigitalDesing(strDigitalValue: string): string;
    function GetMaskLength: integer;
    procedure Act_StartDupleExecute(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure TestClick(Sender: TObject);
    function PassViaFilters(StrValue: AnsiString): AnsiString;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  CurPath: String;
  //10 тыс. 50 тыс. 100 тыс. 250 тыс. 500 тыс. 1мл. 2.5мл. 5мл. 10мл. 25мл. 50мл. 100мл.
  MaxCount: Array[0..8] of integer =
            (10000, 50000, 100000, 300000, 500000, 1000000, 3000000 , 5000000, 10000000);

  //PoolProc: array of TProcessingDic;
  GSTinp: TStringList;
  GSTout: TStringList;
  MaxCore: Cardinal;
  GTimeStart  : Cardinal;
  LTimeStart  : Cardinal;
  GProcCount  : Integer;
  GAddedCount : Integer;
  GDupCount   : integer;
  LProcCount  : integer;
  LAddedCount : integer;
  LDupCount   : integer;
  GXlvi       : integer;
  GXlvo       : integer;
  ExpCount    : integer;


  START: Boolean;
  //FilterConfig: TFilterConfig;

Const
  MB_CAPTION   = 'Dictionary Suite';
  lv_file       = 0;
  lv_wd_count   = 1;
  lv_proc_count = 2;
  lv_added      = 3;
  lv_dup_count  = 4;
  lv_proc_time  = 5;
  lv_status     = 6;

  lvo_file      = 0;
  lvo_wd_count  = 1;
  lvo_size      = 2;
  c_megabyte    = 1048576;    //   1 Mb
  c_file_over_sz = 157286400; // 150 Mb

implementation

{$R *.dfm}

USES UFrmDic, UFrmFilters;

// UThrProcDic;

{--------------------------------- }
procedure TFrmMain.Act_StartDupleExecute(Sender: TObject);
var
  lev1, lev2 : SmallInt;
  i, j, x   : integer;
  MaskLen   : integer;
  STinp     : TStringList;
  STout     : TStringList;
  STFiles   : TStrings;
  FI        : TextFile;
  TimeCount : Cardinal;
  //DicSelCount: integer;
  s_word    : AnsiString;
  symbols   : AnsiString;
  res       : Boolean;
  FileNameExport : String;
  FileNameSave   : string;
  CountWords     : Int64;
  FileOverSize   : Boolean;
  counter1, counter2: Int64;
  // SaveCountOverSize: SmallInt;

  ArrFilesTemp : Array of Array of string;
begin

  START       := true;
  GTimeStart  := GetTickCount;
  GProcCount  := 0;
  GAddedCount := 0;
  GDupCount   := 0;
  //DicSelCount := 0;
  LProcCount  := 0;
  LAddedCount := 0;
  LDupCount   := 0;

  LockControls(LockCtrls, Sender);

  LVInp.Clear;
  LVout.Clear;

  // Проверка словарей
  for i:=0 to FrmDic.LVDic.Items.Count -1 do
  begin
    if FrmDic.LVDic.Items[i].Checked then
    begin
      //inc(DicSelCount);
      x := AddLVitem;
      LVInp.Items[x].SubItems[lv_file]      := FrmDic.LVDic.Items[i].SubItems[dlv_file];
      LVInp.Items[x].SubItems[lv_status]    := strTPSArray[tpsWaiting];
      LVInp.Items[x].SubItems[lv_proc_time] := GetMilisecondsFormat(0, TS_HOUR, TS_Colon)
    end;
  end;

  if LVInp.Items.Count = 0 then
  begin
    MessageBox(Handle,PChar('Не выбран ни один словарь'),
               PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;


  STinp := TStringList.Create;
  STinp.Sorted        := True;
  STinp.CaseSensitive := true;
  STout.Duplicates    := dupIgnore;

  STout := TStringList.Create;
  STout.Sorted        := true;
  STout.CaseSensitive := true;
  STout.Duplicates    := dupIgnore;

  STFiles             := TStringList.Create;

  TmrGetStatus.Enabled := true;
  LblRestProcDicCount.Caption := IntToStr(LVInp.Items.Count);
  GXlvi := -1;
  GXlvo := -1;

  MaskLen := GetMaskLength;

  try

    //********************** Цикл открытия словарей ****************************
    for i:=0 to LVInp.Items.Count -1 do
    begin
      Application.ProcessMessages;
      if not START then Break;

      GXlvi := i;
      LblCurrProcDic.Caption             := LVInp.Items[i].SubItems[lv_file];
      LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsLoadFile];

      // Open file
      AssignFile(FI, LVInp.Items[i].SubItems[lv_file]);
      {R-}
      Reset(FI);
      {R+}
      if IOResult <> 0 then
      begin
        LVInp.Items[i].SubItems[lv_wd_count] := '0';
        LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsError];
        Continue;
      end;

      // Создание массива имен для времменых файлов
      SetLength(ArrFilesTemp, Length(ArrFilesTemp) + 1);
      lev1 := Length(ArrFilesTemp);
      
      // Check the file of OverSize 
      if GetSearchFileSize(LVInp.Items[i].SubItems[lv_file]) > c_file_over_sz then FileOverSize := True
      else FileOverSize := false;

      // Перепроверим количество паролей в словаре
      While Not Eof(FI) do
      begin
        Readln(FI);
        Inc(CountWords);
      end;

      CloseFile(FI);
      Reset(FI);

      //LVInp.Items[i].SubItems[lv_wd_count] := DigitalDesing(IntToStr(STinp.Count));
      LVInp.Items[i].SubItems[lv_wd_count] := DigitalDesing(IntToStr(CountWords));
      LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsProcess];
      LVInp.SetFocus;
      LVInp.SelectItem(GXlvi);

      sGauge.Progress := 0;

      LTimeStart  := GetTickCount;
      LProcCount  := 0;
      LAddedCount := 0;
      LDupCount   := 0;

      // Чтение очередного словаря
      While (Not Eof(FI)) and START do
      begin
        Application.ProcessMessages;
        //if Not START Then Break;

        Readln(FI, s_word);

        inc(GProcCount);
        inc(LProcCount);
        mm.Lines.Add(IntToStr(LProcCount) + ' ' + s_word);

        // Processing Filters
        // Добавляем в список в памяти
        s_word := PassViaFilters(s_word);
        if s_word <> '' then
        begin
          STout.AddObject(s_word, nil);
          inc(GAddedCount);
          inc(LAddedCount);
        end;

         {
          // Добавляем в список в памяти
          x := STout.Count;
          STout.AddObject(s_word, nil);
          if x < STout.Count then
          begin
            inc(GAddedCount);
            inc(LAddedCount);
          end
          else
          begin
            inc(LDupCount);
            inc(GDupCount);
          end;
          }

        // Сохраняю часть огромного файла во временный файл
        if FileOverSize then
          if STout.Count >= 5000000 then
          begin
            // Увеличиваю массив временных файлов
            Lev2 := Length(ArrFilesTemp[Lev1 - 1]);
            SetLength(ArrFilesTemp[lev1 - 1], Lev2 + 1);
            // Генерирую новое имя для временного файла
            FileNameSave := ExtractFileName(LVInp.Items[i].SubItems[lv_file]);
            FileNameSave := CreateNameFileOverSize(FileNameSave, Lev2) + '.tmp';
            FileNameSave := IncludeTrailingBackslash(DirEditExport.Text) + FileNameSave;
            STout.SaveToFile(FileNameSave);
            STout.Clear;
            // Добавляю в масив имен временных вайлов имя файла
            ArrFilesTemp[Lev1 - 1][Lev2] := FileNameSave;
          end;

          {
          if (STout.Count = MaxCount[CmBoxMaxCount.ItemIndex])
          and (Not ChBoxOneInOne.Checked)
          //and (Not FrmFilters.ChBoxNoDuplicat.Checked)
          then
          begin
            x := AddLVout;
            FileNameExport := GetExportFileName(MaskLen, x + 1);
            LVout.Items[x].SubItems[lvo_file]     := FileNameExport;
            LVout.Items[x].SubItems[lvo_wd_count] := DigitalDesing(IntToStr(STout.Count));
            STout.SaveToFile(FileNameExport);
            LVout.Items[x].SubItems[lvo_size]     := GetFileSizeFormat(FileNameExport);
            STout.Clear;
          end;
          }

        //end; {with}

        //if Not START then Break;

      end;{******************** end while Not Eof(FI) *************************}

      CloseFile(FI);

      // Схраняю файл 
      if Not FileOverSize then 
      begin
        lev2 := Length(ArrFilesTemp[Lev1-1]); 
        FileNameSave := IncludeTrailingBackslash(DirEditExport.Text) + ExtractFileName(LVInp.Items[i].SubItems[lv_file]) + '.tmp';
        SetLength(ArrFilesTemp[Lev1 - 1], Lev2 + 1);
        ArrFilesTemp[Lev1 - 1][Length(ArrFilesTemp[Length(ArrFilesTemp) - 1])] := FileNameSave;
        STout.SaveToFile(FileNameSave);
        STout.Clear; 
      end;

      // Обновим таймер
      TmrGetStatusTimer(Nil);

      // Обновление статуса
      if START then
      begin
        LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsComplete];
        lblProcDicCount.Caption := IntToStr(i+1);
      end
      else LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsStoped];

    end;{************ end for i:=0 to LVInp.Items.Count -1 ********************}

    //**************************************************************************
    //         Этап 2. Удаление дубликатов из временных файлов
    //**************************************************************************

    // Переношу из 2х-мерного массива все имена в список,
    // что бы упростить алгоритм и код был более линейным
    for i := 0 to Lev2-1 do
      for j := 0 to Length(ArrFilesTemp[i]) -1 do
        STFiles.Add(ArrFilestemp[i][j]);

    // Основной цикл для открытия временных файлов для поиска дубликатов
    for i := 0 to STFiles.Count - 1 do
    begin
      // Open one file
      AssignFile(FI, STFiles.Strings[i]);

      // Open two file
      STout.Sorted     := false;
      STout.Duplicates := dupAccept;

      // Сверяю на дубликаты старший файл со следующим по списку файлом
      // Если файл последний в списке, то пропускаю
      if STFiles.Count <> (i + 1) then
      begin

        for j := (i + 1) to STFiles.Count - 1 do
        begin

          {R-}
          Reset(FI);
          {R+}
          if IOResult <> 0 then
          begin
            // send msg;
            Continue;
          end;

          // Загружаю последующий список
          STout.LoadFromFile(STFiles.Strings[j]);

          while (Not Eof(FI)) and START do
          begin
            Readln(FI, s_word);

            While true and START do
            begin
              x := STOut.IndexOf(s_word);
              if x <> -1 then
              begin
                STout.Delete(x);
                inc(LDupCount);
                inc(GDupCount);
              end
              else
                Break;
              Application.ProcessMessages;
            end;

            Application.ProcessMessages;
          end;

          STout.SaveToFile(STFiles.Strings[j]);

        end;
      end;

      CloseFile(FI);

    end; {for i := 0 to STFiles.Count -1 do}

    // *************************************************************************
    //     Этап - III, перенос из временных файлав в результирующие
    // *************************************************************************
    for i := 0 to lev1 - 1 do
    begin
      lev2 := Length(ArrFilesTemp[Lev1 - 1]) - 1;
      for j := 0 to lev2 do
      begin

        AssignFile(FI, ArrFilesTemp[i][lev2]);
        {R-}
        Reset(FI);
        {R+}
        if IOResult <> 0 then
        begin
          // send msg;
          Continue;
        end;

      end;
    end;

    // Сохранить ресультаты, которые не были сохраненны в основных циклах
    // и не прошли по размеру
    if START and (STout.Count <> 0) then
    begin
      x := AddLVout;
      FileNameExport := GetExportFileName(MaskLen, x + 1);
      LVout.Items[x].SubItems[lvo_file]     := FileNameExport;
      LVout.Items[x].SubItems[lvo_wd_count] := DigitalDesing(IntToStr(STout.Count));
      STout.SaveToFile(FileNameExport);
      LVout.Items[x].SubItems[lvo_size]     := GetFileSizeFormat(FileNameExport);
      STout.Clear;      //
    end;

    START := false;
    LockControls(UnLockCtrls, Sender);

  finally
    STinp.Free;
    STout.free;
    STFiles.Free;
  end;

end;

{------------------------------- Act_SearchExecute ----------------------------}
procedure TFrmMain.Act_SearchExecute(Sender: TObject);
var
  i,x: integer;
  STinp: TStringList;
begin

  if edSearch.Text  = '' then
  begin
    MessageBox(Handle,PChar('Нужно указать слово для поиска'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if FrmDic.LVDic.Items.Count = 0 then
  begin
    MessageBox(Handle,PChar('Не найден ни один словарь'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  LockControls(LockCtrls, Sender);
  TmrGetStatus.Enabled := true;

  START       := true;
  GTimeStart  := GetTickCount;
  GProcCount  := 0;
  GAddedCount := 0;
  GDupCount   := 0;
  sGauge.Progress := 0;
  LVInp.Clear;

  // Проверка слловарей
  for i:=0 to FrmDic.LVDic.Items.Count -1 do
  begin
    if RdBttnSelectedDic.Checked then
    begin
      if FrmDic.LVDic.Items[i].Checked then
      begin
        x := AddLVitem;
        LVInp.Items[x].SubItems[lv_file]      := FrmDic.LVDic.Items[i].SubItems[dlv_file];
        LVInp.Items[x].SubItems[lv_wd_count]  := FrmDic.LVDic.Items[i].SubItems[dlv_cnt];
        LVInp.Items[x].SubItems[lv_status]    := strTPSArray[tpsWaiting];
        LVInp.Items[x].SubItems[lv_proc_time] := GetMilisecondsFormat(0, TS_HOUR, TS_Colon)
      end;
    end
    else
    begin
      x := AddLVitem;
      LVInp.Items[x].SubItems[lv_file]      := FrmDic.LVDic.Items[i].SubItems[dlv_file];
      LVInp.Items[x].SubItems[lv_wd_count]  := FrmDic.LVDic.Items[i].SubItems[dlv_cnt];
      LVInp.Items[x].SubItems[lv_status]    := strTPSArray[tpsWaiting];
      LVInp.Items[x].SubItems[lv_proc_time] := GetMilisecondsFormat(0, TS_HOUR, TS_Colon)
    end;
  end;

  if (LVInp.Items.Count = 0) then
  begin
    MessageBox(Handle,PChar('Не выбран ни один словарь'),
               PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  STinp := TStringList.Create;
  STinp.CaseSensitive := true;

  LblRestProcDicCount.Caption := IntToStr(LVInp.Items.Count);

  try

    // Цикл открытия словарей
    for i:=0 to LVInp.Items.Count -1 do
    begin
      Application.ProcessMessages;
      if not START then Break;
      LTimeStart := GetTickCount;

      LblCurrProcDic.Caption             := LVInp.Items[i].SubItems[lv_file];
      LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsLoadFile];

      STinp.LoadFromFile(LVInp.Items[i].SubItems[lv_file]);

      LVInp.Items[i].SubItems[lv_wd_count] := DigitalDesing(IntToStr(STinp.Count));
      LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsProcess];
      LVInp.SetFocus;
      LVInp.SelectItem(i);

      x := STinp.IndexOf(edSearch.Text);

      if x <> -1 then
      begin
        MessageBox(Handle, PChar('Слово найдено' + #13#10
                    + 'Cловарь: ' + FrmDic.LVDic.Items[i].SubItems[dlv_file] + #13#10
                    + 'Позиция: ' + IntToStr(x)),
                    PChar(MB_CAPTION), MB_ICONINFORMATION);
        Break;
      end;

      sGauge.Progress             := Trunc((Succ(i) * 100) / LVInp.Items.Count);
      LblProcessTimeCount.Caption := GetMilisecondsFormat(GetTickCount - GTimeStart, TS_HOUR, TS_Colon);

      // Обновление статуса
      if START then
      begin
        LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsComplete];
        lblProcDicCount.Caption := IntToStr(i+1);
      end
      else LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsStoped];
    end;{************************ end for i *******************************}


    START := false;
    LockControls(UnLockCtrls, Sender);

  finally
    STinp.Free;
  end;
end;

{--------------------------- Act_StartExecute ---------------------------------}
procedure TFrmMain.Act_StartExecute(Sender: TObject);
var
  i,j,x: integer;
  MaskLen: integer;
  STout: TStringList;
  TimeCount: Cardinal;
  //DicSelCount: integer;
  s_word: AnsiString;
  symbols: AnsiString;
  res: Boolean;
  FileNameExport: String;
  FI: TextFile;
  CountWords: Integer;
begin

  {
  if (DirEditExport.Text = '') then
  begin
    MessageBox(Handle,PChar('Нужно указать директорию для выходных данных'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if (EdExportFileDic.Text = '') then
  begin
    MessageBox(Handle,PChar('Нужно указать имя (маску) файла для выходных данных'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if FrmDic.LVDic.Items.Count = 0 then
  begin
    MessageBox(Handle,PChar('Не найден ни один словарь'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;
  }

  START       := true;
  GTimeStart  := GetTickCount;
  GProcCount  := 0;
  GAddedCount := 0;
  GDupCount   := 0;
  //DicSelCount := 0;
  LProcCount  := 0;
  LAddedCount := 0;
  LDupCount   := 0;

  LockControls(LockCtrls, Sender);

  LVInp.Clear;
  LVout.Clear;

  // Проверка словарей
  for i:=0 to FrmDic.LVDic.Items.Count -1 do
  begin
    if FrmDic.LVDic.Items[i].Checked then
    begin
      //inc(DicSelCount);
      x := AddLVitem;
      LVInp.Items[x].SubItems[lv_file]      := FrmDic.LVDic.Items[i].SubItems[dlv_file];
      LVInp.Items[x].SubItems[lv_status]    := strTPSArray[tpsWaiting];
      LVInp.Items[x].SubItems[lv_proc_time] := GetMilisecondsFormat(0, TS_HOUR, TS_Colon)
    end;
  end;

  if LVInp.Items.Count = 0 then
  begin
    MessageBox(Handle,PChar('Не выбран ни один словарь'),
               PChar(MB_CAPTION), MB_ICONWARNING);
    Exit;
  end;

  STout := TStringList.Create;
  STout.Sorted        := true;
  STout.CaseSensitive := true;

  case FrmFilters.ChBoxNoDuplicat.Checked of
    true:  STout.Duplicates := dupIgnore;
    false: STout.Duplicates := dupAccept;
  end;

  TmrGetStatus.Enabled := true;
  LblRestProcDicCount.Caption := IntToStr(LVInp.Items.Count);
  GXlvi := -1;
  GXlvo := -1;

  MaskLen := GetMaskLength;

  try

    //********************** Цикл открытия словарей ****************************
    for i:=0 to LVInp.Items.Count -1 do
    begin
      Application.ProcessMessages;
      if not START then Break;

      GXlvi := i;
      LblCurrProcDic.Caption             := LVInp.Items[i].SubItems[lv_file];
      LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsLoadFile];

      {
      STinp.Clear;
      try
        STinp.LoadFromFile(LVInp.Items[i].SubItems[lv_file]);
      except
        LVInp.Items[i].SubItems[lv_wd_count] := '0';
        LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsError];
        Continue;
      end;
      }

      AssignFile(FI, LVInp.Items[i].SubItems[lv_file]);
      {R-}
      Reset(FI);
      {R+}
      if IOResult <> 0 then
      begin
        LVInp.Items[i].SubItems[lv_wd_count] := '0';
        LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsError];
        Continue;
      end;

      // Перепроверим количество паролей в словаре
      While Not Eof(FI) do
      begin
        Readln(FI);
        Inc(CountWords);
      end;

      CloseFile(FI);
      Reset(FI);

      //LVInp.Items[i].SubItems[lv_wd_count] := DigitalDesing(IntToStr(STinp.Count));
      LVInp.Items[i].SubItems[lv_wd_count] := DigitalDesing(IntToStr(CountWords));
      LVInp.Items[i].SubItems[lv_status]   := strTPSArray[tpsProcess];
      LVInp.SetFocus;
      LVInp.SelectItem(GXlvi);

      sGauge.Progress := 0;

      LTimeStart  := GetTickCount;
      LProcCount  := 0;
      LAddedCount := 0;
      LDupCount   := 0;

      // Чтение очередного словаря
      While (Not Eof(FI)) and START do
      begin
        Application.ProcessMessages;
        //if Not START Then Break;

        Readln(FI, s_word);

        inc(GProcCount);
        inc(LProcCount);
        mm.Lines.Add(IntToStr(LProcCount) + ' ' + s_word);

        // Processing Filters
        With FrmFilters do
        begin

          // [1] фильтрация по длине
          if ChBoxRestricLength.Checked then
          begin
            if (length(s_word) < SpEdMinLength.Value)
            or (length(s_word) > SpEdMaxLength.Value) then Continue;
          end;

          // [2] Конввертировать по регистру
          if ChBoxConvertCase.Checked then
          begin
            case RdGrpConvertCase.ItemIndex of
              0: s_word := AnsiLowerCase(s_word);
              1: s_word := AnsiLowerCase(s_word);
            end;
          end;

          // [3] фильтрация по содержанию определенных символов
          if ChBoxExcludeSymbolsEnabled.Checked then
          begin

            // Поиск слов которые не содержат символы
            if RdBtnExcludeSymbolsOf.Checked then
            begin
              if EdExcludeSymbolsOf.Text <> '' then
              begin
                symbols := EdExcludeSymbolsOf.Text;
                res := false;
                for x := 1 to Length(symbols) do
                begin
                  if Assigned(StrScan(PAnsiChar(s_word), symbols[x])) then
                  begin
                    res := true;
                    Break;
                  end;
                end;
                if Not res then Continue;
              end;
            end;

            // Поиск слов которые содержат символы
            if RdBtnExcludeSymbolsIn.Checked then
            begin
              if EdExcludeSymbolsIn.Text <> '' then
              begin
                symbols := EdExcludeSymbolsIn.Text;
                res := false;
                for x:=1 to Length(s_word) do
                begin
                  if Assigned(StrScan(PAnsiChar(s_word), symbols[x])) then
                  begin
                    res := true;
                    Break;
                  end;
                end;
               if res then Continue;
              end;
            end;

          end;

           // [4] фильтрация по содержанию определенных слогов или слов
          if ChBoxExcludeWords.Checked then
          begin
            for x := 0 to mmExcludeWords.Lines.Count -1 do
            begin
              res := false;
              if AnsiPos(mmExcludeWords.Lines[x], s_word) <> 0 then
              begin
                res := true;
                break;
              end;
            end;
            if res then continue;
          end;

          x := STout.Count;
          STout.AddObject(s_word, nil);
          if x < STout.Count then
          begin
            inc(GAddedCount);
            inc(LAddedCount);
          end
          else
          begin
            inc(LDupCount);
            inc(GDupCount);
          end;


          if (STout.Count = MaxCount[CmBoxMaxCount.ItemIndex])
          and (Not ChBoxOneInOne.Checked)
          //and (Not FrmFilters.ChBoxNoDuplicat.Checked)
          then
          begin
            x := AddLVout;
            FileNameExport := GetExportFileName(MaskLen, x + 1);
            LVout.Items[x].SubItems[lvo_file]     := FileNameExport;
            LVout.Items[x].SubItems[lvo_wd_count] := DigitalDesing(IntToStr(STout.Count));
            STout.SaveToFile(FileNameExport);
            LVout.Items[x].SubItems[lvo_size]     := GetFileSizeFormat(FileNameExport);
            STout.Clear;
          end;

        end; {with}

        //if Not START then Break;

      end;{******************** end while Not Eof(FI) *************************}

      CloseFile(FI);

      // Обновим таймер
      TmrGetStatusTimer(Nil);

      // Обновление статуса
      if START then
      begin
        LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsComplete];
        lblProcDicCount.Caption := IntToStr(i+1);
      end
      else LVInp.Items[i].SubItems[lv_status] := strTPSArray[tpsStoped];


      // сохранить результат при услловии "Один в один"
      // if ChBoxOneInOne.Checked and (Not FrmFilters.ChBoxNoDuplicat.Checked) then
      if ChBoxOneInOne.Checked and (STout.Count <> 0) then
      begin
        FileNameExport := ExtractFileName(LVInp.Items[i].SubItems[lv_file]);
        FileNameExport := IncludeTrailingPathDelimiter(DirEditExport.Text) + FileNameExport;
        if Not FileExists(FileNameExport) then
          STout.SaveToFile(FileNameExport)
          else
        begin
          FileNameExport := '~' + ExtractFileName(LVInp.Items[i].SubItems[lv_file]);
          FileNameExport := IncludeTrailingPathDelimiter(DirEditExport.Text) + FileNameExport;
          STout.SaveToFile(FileNameExport);
        end;
        x := AddLVout;
        LVout.Items[x].SubItems[lvo_file]     := FileNameExport;
        LVout.Items[x].SubItems[lvo_wd_count] := DigitalDesing(IntToStr(STout.Count));
        STout.SaveToFile(FileNameExport);
        LVout.Items[x].SubItems[lvo_size]     := GetFileSizeFormat(FileNameExport);
        STout.Clear;
      end;

    end;{************************ end for i *******************************}

    // Сохранить ресультаты, которые не были сохраненны в основных циклах
    // и не прошли по размеру
    if START and (STout.Count <> 0) then
    begin
      x := AddLVout;
      FileNameExport := GetExportFileName(MaskLen, x+1);
      LVout.Items[x].SubItems[lvo_file]     := FileNameExport;
      LVout.Items[x].SubItems[lvo_wd_count] := DigitalDesing(IntToStr(STout.Count));
      STout.SaveToFile(FileNameExport);
      LVout.Items[x].SubItems[lvo_size]     := GetFileSizeFormat(FileNameExport);
      STout.Clear;      //
    end;

    START := false;
    LockControls(UnLockCtrls, Sender);

  finally
    //STinp.Free;
    STout.free;
  end;

end;

{-------------------------------- Act_StopExecute -----------------------------}
procedure TFrmMain.Act_StopExecute(Sender: TObject);
begin
  START := False;
end;
{--------------------------------- AddLVitem ----------------------------------}
function TFrmMain.AddLVitem: integer;
begin
  With LVInp.Items.Add do
  begin
    Caption    := IntToStr(Index + 1);
    SubItems.Add('0');
    SubItems.Add('0');
    SubItems.Add('0');
    SubItems.Add('0');
    SubItems.Add('0');
    SubItems.Add('');
    SubItems.Add('');
    ImageIndex       := -1;
    SubItemImages[0] := 1;
    Result := Index;
  end;
end;
{-------------------------------- AddLVout ------------------------------------}
function TFrmMain.AddLVout: integer;
begin
  With LVout.Items.Add do
  begin
    Caption    := IntToStr(Index + 1);
    SubItems.Add('0');
    SubItems.Add('0');
    SubItems.Add('0');
    ImageIndex       := -1;
    SubItemImages[0] := 0;
    Result := Index;
  end;
end;
{---------------------------- ChBoxOneInOneClick ------------------------------}
procedure TFrmMain.ChBoxOneInOneClick(Sender: TObject);
begin
  if ChBoxOneInOne.Checked then
  begin
    EdExportFileDic.Enabled  := false;
    LblExportFileDic.Enabled := false;
    CmBoxSuffix.Enabled      := false;
    CmBoxFileExt.Enabled     := false;
    CmBoxMaxCount.Enabled    := false;
    LblMaxCount.Enabled      := false;
  end
  else
  begin
    EdExportFileDic.Enabled  := true;
    LblExportFileDic.Enabled := true;
    CmBoxSuffix.Enabled      := true;
    CmBoxFileExt.Enabled     := true;
    CmBoxMaxCount.Enabled    := true;
    LblMaxCount.Enabled      := true;
  end;

end;
{----------------------------- CreateNameFileOverSize -------------------------}
function TFrmMain.CreateNameFileOverSize(FileName: String; x: SmallInt): String;
Var 
  Ext: String;
  Name: String;
begin
  Ext  := ExtractFileExt(FileName);
  Result := copy(FileName, 1, Length(FileName) - Length(Ext)) + '_' + IntToStr(x) + Ext;
end;

{------------------------------ DigitalDesing ---------------------------------}
function TFrmMain.DigitalDesing(strDigitalValue: string): string;
var i: SmallInt;
    s: AnsiString;
begin
  Result := '';
  if Length(strDigitalValue) <=3 then
  begin
    Result := strDigitalValue;
    Exit;
  end;

  s := AnsiReverseString(strDigitalValue);
  for i :=1 to Length(s) do
  begin
    Result := Result + s[i];
    if i <> Length(s) then
      if (i mod 3) = 0 then result := Result + ' ';
  end;
  Result := AnsiReverseString(Result);
  Result := Trim(Result);
end;
{-------------------------- FiltersCheckerExecute -----------------------------}
function TFrmMain.PassViaFilters(StrValue: AnsiString): AnsiString;
var
  symbols: AnsiString;
  rslt   : Boolean;
  x: integer;
begin
  Result := '';

  // Processing Filters
  With FrmFilters do
  begin

    {1} // фильтрация по длине
    if ChBoxRestricLength.Checked then
    begin
      if (length(StrValue) < SpEdMinLength.Value)
      or (length(StrValue) > SpEdMaxLength.Value) then Exit;
    end;

    {2} // Конввертировать по регистру
    if ChBoxConvertCase.Checked then
    begin
      case RdGrpConvertCase.ItemIndex of
        0: StrValue := AnsiLowerCase(StrValue);
        1: StrValue := AnsiLowerCase(StrValue);
      end;
    end;

    {3} // фильтрация по содержанию определенных символов
    if ChBoxExcludeSymbolsEnabled.Checked then
    begin

      // Поиск слов которые не содержат символы
      if RdBtnExcludeSymbolsOf.Checked then
      begin
        if EdExcludeSymbolsOf.Text <> '' then
        begin
          symbols := EdExcludeSymbolsOf.Text;
          rslt := false;
          for x := 1 to Length(symbols) do
          begin
            if Assigned(StrScan(PAnsiChar(StrValue), symbols[x])) then
            begin
              rslt := true;
              Break;
            end;
          end;
          if Not rslt then Exit;
        end;
      end;

      // Поиск слов которые содержат символы
      if RdBtnExcludeSymbolsIn.Checked then
      begin
        if EdExcludeSymbolsIn.Text <> '' then
        begin
          symbols := EdExcludeSymbolsIn.Text;
          rslt := false;
          for x:=1 to Length(StrValue) do
          begin
            if Assigned(StrScan(PAnsiChar(StrValue), symbols[x])) then
            begin
              rslt := true;
              Break;
            end;
          end;
          if rslt then Exit;
        end;
      end;

    end;

    {4} // фильтрация по содержанию определенных слогов или слов
    if ChBoxExcludeWords.Checked then
    begin
      for x := 0 to mmExcludeWords.Lines.Count -1 do
      begin
        rslt := false;
        if AnsiPos(mmExcludeWords.Lines[x], StrValue) <> 0 then
        begin
          rslt := true;
          break;
        end;
      end;
      if rslt then Exit;
    end;

  end;

  Result := StrValue;

end;
{-------------------------------- FormCreate ----------------------------------}
procedure TFrmMain.FormCreate(Sender: TObject);
var SysInfo: TSystemInfo;
begin
  CurPath := ExtractFilePath(Application.ExeName);
  //SkinMan.SkinDirectory := CurPath + 'Skins';

  GetSystemInfo(SysInfo);
  MaxCore := SysInfo.dwNumberOfProcessors;
  LblProcessor.caption := 'Процессор: '
                          + TregEx.Replace(GetProcessorName, '\s{3,}', '  ', [roIgnoreCase])
                          + ' [Cores ' + IntToStr(MaxCore) + ']';

  GSTinp := TStringList.Create;
  GSTout := TStringList.Create;

  caption := caption + ' by SUPERBOT ver. ' + GetVertionInfo(Application.ExeName, true);
  DirEditExport.Text := 'C:\WORDS';

  //GSTinp.CaseSensitive := true;
  //GSTinp.Sorted        := true;
  //GSTinp.Duplicates    := dupError;

end;
{--------------------------- GetExportFileName --------------------------------}
function TFrmMain.GetExportFileName(MaskLen, x: integer): String;
var
  msk: string;
  i: SmallInt;
begin

  // создаем маску
  msk := StringOfChar('0', MaskLen - Length(IntToStr(x)));
  msk := msk + IntToStr(x);

  Result := IncludeTrailingPathDelimiter(DirEditExport.Text)
            + EdExportFileDic.Text + CmBoxSuffix.Text + msk
            + strExtArray[CmBoxFileExt.ItemIndex];
end;
{----------------------------- GetMaskLength ----------------------------------}
function TFrmMain.GetMaskLength: integer;
var
  i: SmallInt;
  wd_sum: Integer;
begin

  for i:=0 to FrmDic.LVDic.Items.Count -1 do
  begin
    if FrmDic.LVDic.Items[i].Checked then
      if FrmDic.LVDic.Items[i].SubItems[dlv_cnt] <> '' then
        wd_sum := wd_sum + StrToInt(StringReplace(FrmDic.LVDic.Items[i].SubItems[dlv_cnt], ' ', '', [rfReplaceAll]));
  end;

  // получаем длину предполагаемых разрядов
  ///i := wd_sum div MaxCount[CmBoxMaxCount.ItemIndex];
  Result := length(IntToStr(wd_sum div MaxCount[CmBoxMaxCount.ItemIndex])) + 1;

end;
{------------------------------ GetProcessorName ------------------------------}
function TFrmMain.GetProcessorName: string;
var reg: TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('\HARDWARE\DESCRIPTION\System\CentralProcessor\0') then
    begin
      Result := reg.ReadString('ProcessorNameString');
      reg.CloseKey;
    end;
  finally
    reg.Free;
  end;
end;
{------------------------------- LockControls ---------------------------------}
procedure TFrmMain.LockControls(LockStatus: TLockCtrls; Sender: TObject);
var
  status: boolean;
  i: SmallInt;
begin

  case LockStatus of
    LockCtrls  : status := false;
    UnLockCtrls: status := true;
  end;

  MM_Dictionary.Enabled   := status;
  MM_FiltersShow.Enabled  := status;
  Act_Start.Enabled       := status;

  for i:=0 to GrBoxSaveFile.ControlCount -1 do
    GrBoxSaveFile.Controls[i].Enabled := status;

  for i:=0 to GrBoxSearch.ControlCount -1 do
    GrBoxSearch.Controls[i].Enabled := status;

  if Sender is TAction then
  begin
    if (Sender as TAction) = Act_Search then
    begin
      BtnStop.Enabled       := status;
      BtnStopSearch.Enabled := true;
    end;
  end;

  if status then ChBoxOneInOneClick(Nil);

end;

{----------------------------- MM_DictionaryClick -----------------------------}
procedure TFrmMain.MM_DictionaryClick(Sender: TObject);
begin
  FrmDic.ShowModal;
end;
{--------------------------------- MM_ExitClick -------------------------------}
procedure TFrmMain.MM_ExitClick(Sender: TObject);
begin
  Close;
end;
{-------------------------------- MM_FiltersShowClick -------------------------}
procedure TFrmMain.MM_FiltersShowClick(Sender: TObject);
begin
  FrmFilters.ShowModal;
end;

{-------------------------------- BtnStartClick -------------------------------}
procedure TFrmMain.BtnStartClick(Sender: TObject);
begin

  if (DirEditExport.Text = '') then
  begin
    MessageBox(Handle,PChar('Нужно указать директорию для выходных данных'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if (EdExportFileDic.Text = '') then
  begin
    MessageBox(Handle,PChar('Нужно указать имя (маску) файла для выходных данных'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if FrmDic.LVDic.Items.Count = 0 then
  begin
    MessageBox(Handle,PChar('Не найден ни один словарь'),
      PChar(MB_CAPTION), MB_ICONWARNING);
    exit;
  end;

  if FrmFilters.ChBoxNoDuplicat.Checked then
    Act_StartExecute(Sender)
  else
    Act_StartDupleExecute(Sender);

end;

{------------------------------ TestClick -------------------------------------}
procedure TFrmMain.TestClick(Sender: TObject);
var sz: Int64;
  STOut: TStringList;
  FArr: Array of Array of string;
  a, b, L1, L2: integer;
  x: integer;
begin

  STOut := TStringList.Create;
  STout.Sorted        := true;
  STout.CaseSensitive := true;
  STout.Duplicates    := dupIgnore;

  STOut.LoadFromFile('C:\PROJECT+\stout.txt');
 {
  STOut.Add('SetLength_0');
  STOut.Add('SetLength_1');
  STOut.Add('SetLength_2');
  STOut.Add('SetLength3');
  STOut.Add('SetLength');
  STOut.Add('setLength');
  STOut.Add('setLength');
  STOut.Add('SetLength5');
  }
  for x := 0 to STOut.Count -1 do mm.Lines.Add(IntToStr(x) +' '+ STOut.Strings[x]);

  x := STOut.IndexOf('setLength');
  mm.Lines.Add('x = ' + IntToStr(x));

  {
  mm.Lines.Add(IntToStr(High(FArr)));
  SetLength(Farr, succ(Length(Farr)));
  SetLength(farr[length(Farr)-1], length(Farr[Length(Farr)-1])+1);
  SetLength(farr[length(Farr)-1], Length(Farr[Length(Farr)-1])+1);
  Farr[0][0] := 'text 1';
  Farr[0][1] := 'InsidePro(Full)-01.txt';
  mm.Lines.Add('farr[0][0] = '+ Farr[0][0]);
  mm.Lines.Add('Farr[0][1] = '+ Farr[0][1]);
   }


  mm.Lines.Add(CreateNameFileOverSize('d:\words\InsidePro(Full)-01.txt',0));
  //mm.Lines.Add(GetFileSizeFormat('d:\words\InsidePro(Full)-01.txt'));
  //sz := GetSearchFileSize('d:\words\InsidePro(Full)-01.txt');
  //mm.Lines.Add(IntToStr(sz));
  //mm.Lines.Add(FormatFileSize(sz));
  
end;

{-------------------------------- TmrGetStatusTimer ---------------------------}
procedure TFrmMain.TmrGetStatusTimer(Sender: TObject);
var s_temp: string;
begin
  if START then LblProcessTimeCount.Caption  := GetMilisecondsFormat(GetTickCount - GTimeStart, TS_HOUR, TS_Colon);
  LbLProcessCount.Caption := DigitalDesing(IntToStr(GProcCount));
  LblAddedCount.Caption   := DigitalDesing(IntToStr(GAddedCount));
  LblDubCount.Caption     := DigitalDesing(IntToStr(GDupCount));

  if (LVInp.items.Count = 0) then exit;
  LVInp.Items[GXlvi].SubItems[lv_proc_count] := DigitalDesing(IntToStr(LProcCount));
  LVInp.Items[GXlvi].SubItems[lv_added]      := DigitalDesing(IntToStr(LAddedCount));
  LVInp.Items[GXlvi].SubItems[lv_dup_count]  := DigitalDesing(IntToStr(LDupCount));
  if START then LVInp.Items[GXlvi].SubItems[lv_proc_time] := GetMilisecondsFormat(GetTickCount - LTimeStart, TS_HOUR, TS_Colon);

  if (LProcCount <> 0) and (LVInp.Items[GXlvi].SubItems[lv_wd_count] <> '0') then
  begin
    s_temp := StringReplace(LVInp.Items[GXlvi].SubItems[lv_wd_count],' ','', [rfReplaceAll]);
    sGauge.Progress := Trunc((LProcCount * 100) / (StrToInt(s_temp)));
  end;

end;

end.
