unit u_lapnilai;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_lapnilai = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    edttahun: TEdit;
    rb1: TRadioButton;
    rb2: TRadioButton;
    Label3: TLabel;
    edtnama: TEdit;
    btnbantu: TBitBtn;
    grp4: TGroupBox;
    btnlihatdata: TBitBtn;
    btnkeluar: TBitBtn;
    edtkode: TEdit;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure btnbantuClick(Sender: TObject);
    procedure btnlihatdataClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_lapnilai: Tf_lapnilai;

implementation

uses
  u_bantu_teater, u_report_hasilsv, u_menuutama;

{$R *.dfm}

procedure Tf_lapnilai.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_lapnilai.edttahunKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then key:=#0;
end;

procedure Tf_lapnilai.FormShow(Sender: TObject);
begin
 edttahun.Enabled:=True; edttahun.Text:=FormatDateTime('yyyy',Now);
 rb1.Checked:=false;
 rb2.Checked:=False;
 edtnama.Enabled:=False; edtnama.Clear;
 btnbantu.Enabled:=false;
end;

procedure Tf_lapnilai.rb1Click(Sender: TObject);
begin
 btnbantu.Enabled:=false;
 edtnama.Clear;
end;

procedure Tf_lapnilai.rb2Click(Sender: TObject);
begin
 btnbantu.Enabled:=True;
 edtnama.Clear;
end;

procedure Tf_lapnilai.btnbantuClick(Sender: TObject);
begin
 f_bantu_teater.edt1.Text:='hasilsv';
 f_bantu_teater.ShowModal;
end;

procedure Tf_lapnilai.btnlihatdataClick(Sender: TObject);
begin
 if Trim(edttahun.Text)='' then
  begin
   MessageDlg('Tahun Belum Diisi',mtWarning,[mbok],0);
   edttahun.SetFocus;
   Exit;
  end;

 if (rb1.Checked=False) and (rb2.Checked=false) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih',mtWarning,[mbok],0);
    Exit;
  end;

 if rb1.Checked=True then
  begin
     with report_hasilsv.qrylaphasilsv do
      begin
        close;
        SQL.Clear;
        SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.kd_kriteria, c.kriteria, d.nilai, e.hasil_s, a.hasil_wp');
        sql.Add('from tbl_rangking a, tbl_peserta b, tbl_kriteria c, tbl_proses d,  tbl_hasil_s e where e.kd_proses=a.kd_proses and');
        sql.Add('a.kd_teater=b.kd_teater and d.kd_proses=a.kd_proses and d.kd_kriteria=c.kd_kriteria');
        sql.Add('and a.tahun='+QuotedStr(edttahun.Text)+'');
        Open;
        if IsEmpty then
          begin
            MessageDlg('Data Kosong',mtInformation,[mbok],0);
            Exit;
          end
         else
        begin
         //report_hasilsv.qrlbltahun.Caption:=edttahun.Text;
         report_hasilsv.qrlbl2.Caption:='Laporan Hasil Penilaian Lomba Tahun '+ edttahun.Text;
         //report_hasilsv.qrlbl1.Caption:='SANGGAR TITIAN BARANTAI TAHUN '+edttahun.Text;
         report_hasilsv.qrlblbulan.Caption:=f_menuutama.bulan(now);
         report_hasilsv.Preview;
        end;
      end;
  end
  else
 if rb2.Checked=True then
  begin
    if edtnama.Text='' then
     begin
       MessageDlg('Grub Teater Belum Dipilih',mtWarning,[mbok],0);
       btnbantu.SetFocus;
       Exit;
     end
     else
     begin
       with report_hasilsv.qrylaphasilsv do
        begin
          close;
          SQL.Clear;
          SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.kd_kriteria, c.kriteria, d.nilai, e.hasil_s, a.hasil_wp');
          sql.Add('from tbl_rangking a, tbl_peserta b, tbl_kriteria c, tbl_proses d,  tbl_hasil_s e where e.kd_proses=a.kd_proses and');
          sql.Add('a.kd_teater=b.kd_teater and d.kd_proses=a.kd_proses and d.kd_kriteria=c.kd_kriteria');
          sql.Add('and a.tahun='+QuotedStr(edttahun.Text)+' and b.kd_teater='+QuotedStr(edtkode.Text)+' ');
          Open;
          if IsEmpty then
            begin
              MessageDlg('Data Kosong',mtInformation,[mbok],0);
             Exit;
            end
          else
          begin
           report_hasilsv.qrlbl2.Caption:='Laporan Hasil Penilaian Lomba Tahun '+ edttahun.Text;
           //report_hasilsv.qrlbl1.Caption:='SANGGAR TITIAN BARANTAI TAHUN '+edttahun.Text;
           report_hasilsv.qrlblbulan.Caption:=f_menuutama.bulan(now);
           report_hasilsv.Preview;
          end;
        end;
     end;
  end;
end;

end.
