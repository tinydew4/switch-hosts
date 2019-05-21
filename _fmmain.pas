unit _fmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TfmMain }

  TfmMain = class(TForm)
    LbHosts: TListBox;
    MmHosts: TMemo;
    TmBatch: TTimer;
    procedure LbHostsDblClick(Sender: TObject);
    procedure TmBatchTimer(Sender: TObject);
  private
    FHostsHash: string;
    procedure LoadHostsList;
    procedure SetHosts(FileName: string);
    procedure BackupHosts;
    procedure LoadHosts;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  fmMain: TfmMain;

implementation

uses
  sha1, windows,
  FileUtil, StrUtils;

const
  SFmtHosts = '%s\drivers\etc\hosts';

function GetSystemDir: string;
begin
  SetLength(Result, windows.MAX_PATH);
  SetLength(Result, windows.GetSystemDirectory(LPSTR(Result), windows.MAX_PATH));
end;

function GetHostsName: string;
begin
  Result := Format(SFmtHosts, [GetSystemDir]);
end;

{$R *.frm}

{ TfmMain }

constructor TfmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  LoadHostsList;
end;

procedure TfmMain.LbHostsDblClick(Sender: TObject);
begin
  if LbHosts.ItemIndex in [0..LbHosts.Count] then begin
    SetHosts(ExtractFilePath(ParamStr(0)) + LbHosts.Items.Strings[LbHosts.ItemIndex]);
  end;
end;

procedure TfmMain.TmBatchTimer(Sender: TObject);
var
  HostsHash: string;
begin
  HostsHash := sha1.SHA1Print(sha1.SHA1File(GetHostsName));
  if FHostsHash <> HostsHash then begin
    FHostsHash := HostsHash;
    LoadHosts;
  end;
end;

procedure TfmMain.LoadHostsList;
var
  FileList: TStrings;
  I: Integer;
  PathLen: Integer;
begin
  PathLen := Length(ExtractFilePath(ParamStr(0)));
  FileList := FileUtil.FindAllFiles(ExtractFilePath(ParamStr(0)), '*.hosts');
  try
    for I := 0 to Pred(FileList.Count) do begin
      FileList.Strings[I] := StrUtils.MidStr(FileList.Strings[I], 1 + PathLen, Length(FileList.Strings[I]));
    end;
    LbHosts.Items.Assign(FileList);
  finally
    FileList.Free;
  end;
end;

procedure TfmMain.SetHosts(FileName: string);
begin
  BackupHosts;
  FileUtil.CopyFile(FileName, GetHostsName);
end;

procedure TfmMain.BackupHosts;
const
  SDefaultBackupIndex = '000';
var
  BackupBase: string;
  BackupDateTime: string;
  BackupIndex: Integer;
  NowDateTime: string;

  function GetNowDateTime: string;
  begin
    Result := FormatDateTime('yyyymmdd.hhnnss', Now);
  end;

  function GetBackupName: string;
  begin
    Result := Format('%s.%s.%s.bak', [BackupBase, BackupDateTime, RightStr(SDefaultBackupIndex + IntToStr(BackupIndex), Length(SDefaultBackupIndex))]);
  end;

begin
  BackupBase := GetHostsName;
  BackupDateTime := GetNowDateTime;
  BackupIndex := 0;
  while FileExists(GetBackupName) do begin
    NowDateTime := GetNowDateTime;
    if BackupDateTime = NowDateTime then begin
      Inc(BackupIndex);
    end else begin
      BackupDateTime := NowDateTime;
      BackupIndex := 0;
    end;
  end;
  if FileExists(GetHostsName) then begin
    RenameFile(GetHostsName, GetBackupName);
  end;
end;

procedure TfmMain.LoadHosts;
begin
  MmHosts.Lines.LoadFromFile(GetHostsName, TEncoding.UTF8);
end;

end.

