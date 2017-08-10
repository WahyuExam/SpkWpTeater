unit u_trans_wp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_trans_perangkiganwp = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp11: TGroupBox;
    Label2: TLabel;
    btnkeluar: TBitBtn;
    edttahun: TEdit;
    btnbersih: TBitBtn;
    btnproses: TBitBtn;
    grp2: TGroupBox;
    dbgrd2: TDBGrid;
    img1: TImage;
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnprosesClick(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure edttahunChange(Sender: TObject);
    procedure btnbersihClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_trans_perangkiganwp: Tf_trans_perangkiganwp;
  ada : Boolean;
  a : Integer;

implementation

uses
  u_dm, ADODB, DB, u_report_rangking, u_menuutama;

{$R *.dfm}

procedure Tf_trans_perangkiganwp.edttahunKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
end;

procedure Tf_trans_perangkiganwp.FormShow(Sender: TObject);
begin
 edttahun.Enabled:=True;
 edttahun.Text:=FormatDateTime('yyyy',Now);
 edttahun.SetFocus;

 with dm.qryrangking do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='update tbl_rangking set juara='+QuotedStr('')+'';
    ExecSQL;
  end;

 with dm.qrytampil_rangking do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, a.hasil_wp from tbl_rangking a,');
    sql.Add('tbl_peserta b where a.kd_teater=b.kd_teater and a.tahun='+QuotedStr('kosong')+'');
    Open;
  end;
 btnproses.Enabled:=True;
 btnbersih.Enabled:=false;
 btnkeluar.Enabled:=True; 
end;

procedure Tf_trans_perangkiganwp.btnprosesClick(Sender: TObject);
begin
 if Trim(edttahun.Text)='' then
  begin
    MessageDlg('Tahun Belum Diisi',mtWarning,[mbok],0);
    edttahun.SetFocus;
    Exit;
  end;

 with dm.qryrangking do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+'';
    Open;
    if IsEmpty then
     begin
       MessageDlg('Data Penilaian Pada Tahun Ini Belum ada',mtInformation,[mbok],0);
       edttahun.SetFocus;
       Exit;
     end
     else
     begin
      ada:=false;
      for a:=1 to RecordCount do
       begin
         RecNo:=a;

         if FieldByName('hasil_wp').AsString='' then ada:=True;
       end;
       a:=a+1;

       if ada=True then
        begin
          MessageDlg('Lakukan Proses Hasil S dan V Terlebih Dahulu',mtInformation,[mbOK],0);
          edttahun.SetFocus;
          Exit;
        end
        else
        begin
          with dm.qryrangking do
           begin
             close;
             SQL.Clear;
             SQL.Text:='select * from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+' order by hasil_wp desc';
             Open;
             for a:=1 to 3 do
              begin
                RecNo:=a;

                if FieldByName('juara').AsString = '' then
                 begin
                  Edit;
                  FieldByName('juara').AsString := 'Juara '+IntToStr(a);
                  Post;
                 end;
              end;

             for a:=1 to 3 do
              begin
                RecNo := 3+a;

                if FieldByName('juara').AsString = '' then
                 begin
                  Edit;
                  FieldByName('juara').AsString := 'Harapan '+IntToStr(a);
                  Post;
                 end;
              end;
           end;

          with dm.qrytampil_rangking do
           begin
             DisableControls;
             Close;
             SQL.Clear;
             SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, a.nil_s,');
             SQL.Add('a.hasil_wp, a.juara from tbl_rangking a, tbl_peserta b where a.kd_teater=b.kd_teater');
             SQL.Add('and a.tahun='+QuotedStr(edttahun.Text)+' order by a.hasil_wp desc');
             Open;
             EnableControls;
           end;
           MessageDlg('Proses Perangkingan Selesai',mtInformation,[mbok],0);
           edttahun.Enabled:=True;
           btnproses.Enabled:=false;
           btnbersih.Enabled:=True;
           btnkeluar.Enabled:=True;
        end;
     end;
  end
end;

procedure Tf_trans_perangkiganwp.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_trans_perangkiganwp.edttahunChange(Sender: TObject);
begin
 with dm.qrytampil_rangking do
  begin
   DisableControls;
   Close;
   SQL.Clear;
   SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, a.nil_s,');
   SQL.Add('a.hasil_wp, a.juara from tbl_rangking a, tbl_peserta b where a.kd_teater=b.kd_teater');
   SQL.Add('and a.tahun='+QuotedStr('kosong')+' order by a.hasil_wp desc');
   Open;
   EnableControls;
  end;
  btnproses.Enabled:=True;
  btnbersih.Enabled:=false;
end;

procedure Tf_trans_perangkiganwp.btnbersihClick(Sender: TObject);
begin
 with dm.qrytampil_rangking do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, a.nil_s, a.hasil_wp, a.juara from tbl_rangking a,');
    sql.Add('tbl_peserta b where a.kd_teater=b.kd_teater and a.tahun='+QuotedStr(edttahun.Text)+' order by a.hasil_wp desc');
    Open;

    report_rangking.qrlblbulan.Caption:=f_menuutama.bulan(Now);
    report_rangking.qrlbl2.Caption := 'Laporan Hasil Juara Lomba Tearer Tahun '+edttahun.Text;
    report_rangking.Preview;
  end;
end;

end.
