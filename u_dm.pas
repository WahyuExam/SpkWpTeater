unit u_dm;

interface

uses
  SysUtils, Classes, DB, ADODB, XPMan;

type
  Tdm = class(TDataModule)
    con1: TADOConnection;
    qrykriteria: TADOQuery;
    qrysubkriteria: TADOQuery;
    qrybobot: TADOQuery;
    qrypeserta: TADOQuery;
    qryjuri: TADOQuery;
    tblpengguna: TADOTable;
    qrytampil_bobot: TADOQuery;
    dstampil_bobot: TDataSource;
    XPManifest1: TXPManifest;
    dspesera: TDataSource;
    qryrangking: TADOQuery;
    qryproses: TADOQuery;
    qrynilai: TADOQuery;
    qrynilai_s: TADOQuery;
    qrynilai_v: TADOQuery;
    qrytampil_nilai: TADOQuery;
    dstampil_nilai: TDataSource;
    qrytampil_nilai_s: TADOQuery;
    dstampil_nilai_s: TDataSource;
    qrytampil_nilai_v: TADOQuery;
    dstampil_nilai_v: TDataSource;
    qrytemp_nilai: TADOQuery;
    qrytampil_rangking: TADOQuery;
    dstampil_rangking: TDataSource;
    tblpenanggungjawab: TADOTable;
    dsjuri: TDataSource;
    qrytmp_rata: TADOQuery;
    qrytampil_tmp_rata: TADOQuery;
    dstampil_tmp_rata: TDataSource;
    qrytmp_nil: TADOQuery;
    dstmp_nil: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{$R *.dfm}

procedure Tdm.DataModuleCreate(Sender: TObject);
var ss : string;
begin
 con1.Connected:=false;
 getdir(0,ss);
 con1.ConnectionString:=
 'Provider=Microsoft.Jet.OLEDB.4.0;'+
 'Data Source='+ ss +'\dbwp.mdb;';
 con1.Connected:=true;

 //aktif semua
 tblpengguna.Active:=True;
 tblpenanggungjawab.Active:=True;

 qrykriteria.Active:=True;
 qrysubkriteria.Active:=True;
 qrybobot.Active:=True;
 qrypeserta.Active:=True;
 qryjuri.Active:=True;
 qrytampil_bobot.Active:=True;

 qryrangking.Active:=True;
 qryproses.Active:=True;
 qrynilai.Active:=True;
 qrynilai_s.Active:=True;
 qrynilai_v.Active:=True;
 qrytemp_nilai.Active:=True;

 qrytampil_rangking.Active:=True;
 qrytampil_nilai.Active:=True;
 qrytampil_nilai_s.Active:=True;
 qrytampil_nilai_v.Active:=True;

 qrytmp_rata.Active:=True;
 qrytampil_tmp_rata.Active:=True;
 qrytmp_nil.Active:=True;
end;
end.
