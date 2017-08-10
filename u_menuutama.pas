unit u_menuutama;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, jpeg, ExtCtrls;

type
  Tf_menuutama = class(TForm)
    mm1: TMainMenu;
    Master1: TMenuItem;
    ransaksi1: TMenuItem;
    Laporan1: TMenuItem;
    Pengaruran1: TMenuItem;
    Keluar1: TMenuItem;
    PesertaTeater1: TMenuItem;
    BobotKriteria1: TMenuItem;
    Penilaian1: TMenuItem;
    HasilSdanV1: TMenuItem;
    HasilWP1: TMenuItem;
    GantiKataSandi1: TMenuItem;
    SimpandanSalinData1: TMenuItem;
    PenanggungJawab1: TMenuItem;
    GrubTeater1: TMenuItem;
    Penilaian2: TMenuItem;
    HasilSdanV2: TMenuItem;
    PerangkinganMetodeWP1: TMenuItem;
    Juri1: TMenuItem;
    Juri2: TMenuItem;
    img1: TImage;
    procedure Keluar1Click(Sender: TObject);
    procedure BobotKriteria1Click(Sender: TObject);
    procedure PesertaTeater1Click(Sender: TObject);
    procedure Penilaian1Click(Sender: TObject);
    procedure HasilSdanV1Click(Sender: TObject);
    procedure HasilWP1Click(Sender: TObject);
    procedure GantiKataSandi1Click(Sender: TObject);
    procedure PenanggungJawab1Click(Sender: TObject);
    procedure SimpandanSalinData1Click(Sender: TObject);
    procedure GrubTeater1Click(Sender: TObject);
    procedure HasilSdanV2Click(Sender: TObject);
    procedure PerangkinganMetodeWP1Click(Sender: TObject);
    procedure Penilaian2Click(Sender: TObject);
    procedure Juri1Click(Sender: TObject);
    procedure Juri2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function bulan (vtgl : TDate):string;
  end;

var
  f_menuutama: Tf_menuutama;

implementation

uses
  u_bobot, u_teater, u_penilaian, u_dm, u_hasil_sv, u_trans_wp, u_peng_login,
  u_peng_jawab, u_peng_salindata, u_report_peserta, u_lapnilai, u_laprangking,
  u_lappenilaian, u_mast_juri, u_report_juri;

{$R *.dfm}

function Tf_menuutama.bulan(vtgl: TDate): string;
const
  nm_bulan : array[1..12] of string = ('Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember');

var a : Integer;
begin
  for a:=1 to 12 do
   begin
     LongMonthNames[a] := nm_bulan[a]
   end;
   a:=a+1;

  Result:=FormatDateTime('dd mmmm yyyy',vtgl);
end;

procedure Tf_menuutama.Keluar1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure Tf_menuutama.BobotKriteria1Click(Sender: TObject);
begin
 f_mast_bobot.ShowModal;
end;

procedure Tf_menuutama.PesertaTeater1Click(Sender: TObject);
begin
 f_mast_teater.ShowModal;
end;

procedure Tf_menuutama.Penilaian1Click(Sender: TObject);
begin
 f_trans_penilaian.ShowModal;
end;

procedure Tf_menuutama.HasilSdanV1Click(Sender: TObject);
begin
 f_trans_nilasv.ShowModal;
end;

procedure Tf_menuutama.HasilWP1Click(Sender: TObject);
begin
 f_trans_perangkiganwp.Show;
end;

procedure Tf_menuutama.GantiKataSandi1Click(Sender: TObject);
begin
 f_peng_gantisandi.ShowModal;
end;

procedure Tf_menuutama.PenanggungJawab1Click(Sender: TObject);
begin
 f_peng_penanggungjawab.ShowModal;
end;

procedure Tf_menuutama.SimpandanSalinData1Click(Sender: TObject);
begin
 f_peng_salindata.ShowModal;
end;

procedure Tf_menuutama.GrubTeater1Click(Sender: TObject);
begin
 report_peserta.qrlblbulan.Caption:=bulan(Now);
 report_peserta.Preview;
end;

procedure Tf_menuutama.HasilSdanV2Click(Sender: TObject);
begin
 f_lapnilai.ShowModal;
end;

procedure Tf_menuutama.PerangkinganMetodeWP1Click(Sender: TObject);
begin
 f_laprangking.Show;
end;

procedure Tf_menuutama.Penilaian2Click(Sender: TObject);
begin
 f_lap_penilaian.ShowModal;
end;

procedure Tf_menuutama.Juri1Click(Sender: TObject);
begin
 f_maste_juri.ShowModal;
end;

procedure Tf_menuutama.Juri2Click(Sender: TObject);
begin
 report_juri.qrlblbulan.Caption:=bulan(Now);
 report_juri.Preview;
end;

end.
