unit u_lappenilaian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DBCtrls, jpeg, ExtCtrls;

type
  Tf_lap_penilaian = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    edttahun: TEdit;
    grp4: TGroupBox;
    btnlihatdata: TBitBtn;
    btnkeluar: TBitBtn;
    grp3: TGroupBox;
    rb_jenis_pergrub: TRadioButton;
    rb_jenis_semua: TRadioButton;
    Label3: TLabel;
    edtnama: TEdit;
    edtkode: TEdit;
    btnbantu: TBitBtn;
    grp5: TGroupBox;
    rb_semua_juri: TRadioButton;
    rb_perjuri: TRadioButton;
    cbbjuri: TComboBox;
    dblkcbbjuri: TDBLookupComboBox;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnlihatdataClick(Sender: TObject);
    procedure rb_jenis_semuaClick(Sender: TObject);
    procedure rb_jenis_pergrubClick(Sender: TObject);
    procedure rb_semua_juriClick(Sender: TObject);
    procedure rb_perjuriClick(Sender: TObject);
    procedure btnbantuClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_lap_penilaian: Tf_lap_penilaian;

implementation

uses
  u_report_penilaian, ADODB, u_menuutama, DB, u_bantu_teater, u_dm;

{$R *.dfm}

procedure Tf_lap_penilaian.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_lap_penilaian.FormShow(Sender: TObject);
begin
 edttahun.Text:=FormatDateTime('yyyy',Now);

 rb_jenis_semua.Checked:=false;
 rb_jenis_pergrub.Checked:=false;
 edtnama.Clear; edtnama.Enabled:=false;
 btnbantu.Enabled:=false;

 rb_semua_juri.Checked:=false;
 rb_perjuri.Checked:=false;
 dblkcbbjuri.Enabled:=false;
 dblkcbbjuri.KeyValue:=null;
 {cbbjuri.Enabled:=false;
 cbbjuri.Text:=''; }
end;

procedure Tf_lap_penilaian.btnlihatdataClick(Sender: TObject);
begin
 if Trim(edttahun.Text)='' then
  begin
    MessageDlg('Tahun Belum Diisi',mtWarning,[mbOK],0);
    edttahun.SetFocus;
    Exit;
  end;

 if (rb_jenis_semua.Checked=false) and (rb_jenis_pergrub.Checked=false) then
  begin
    MessageDlg('Jenis Laporan Belum Dipilih',mtWarning,[mbok],0);
    Exit;
  end;

 if (rb_semua_juri.Checked=false) and (rb_perjuri.Checked=false) then
  begin
    MessageDlg('Penilaian Juri Belum Dipilih',mtWarning,[mbok],0);
    Exit;
  end;

 if rb_jenis_semua.Checked=True then
  begin
    if rb_semua_juri.Checked=True then
     begin
       with report_penilaian.qrylaporan_penilaian do
        begin
          close;
          SQL.Clear;
          SQL.Text:='select * from qrylaporan_penilaian where tahun='+QuotedStr(edttahun.Text)+' order by kd_proses asc, kd_juri asc, kd_sub_kriteria asc';
          Open;
          if IsEmpty then
           begin
             MessageDlg('Penilaian Pada Tahun ini Tidak ada',mtInformation,[mbOK],0);
             Exit;
           end
        end;
     end
     else
    if rb_perjuri.Checked=True then
     begin
       if dblkcbbjuri.KeyValue=null then
        begin
          MessageDlg('Juri Belum Dipilih',mtWarning,[mbOK],0);
          dblkcbbjuri.SetFocus;
          Exit;
        end
        else
        begin
          with report_penilaian.qrylaporan_penilaian do
           begin
            close;
            SQL.Clear;
            SQL.Text:='select * from qrylaporan_penilaian where tahun='+QuotedStr(edttahun.Text)+' and kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+' order by kd_juri asc, kd_sub_kriteria asc';
            Open;
            if IsEmpty then
             begin
              MessageDlg('Penilaian Pada Tahun ini Tidak ada',mtInformation,[mbOK],0);
              Exit;
             end
           end;
        end;
     end;
  end
  else
 if rb_jenis_pergrub.Checked=True then
  begin
    if edtnama.Text='' then
     begin
       MessageDlg('Grub Teater Belum Dpilih',mtWarning,[mbok],0);
       btnbantu.SetFocus;
       Exit;
     end;

     if rb_semua_juri.Checked=True then
       begin
        with report_penilaian.qrylaporan_penilaian do
          begin
            close;
            SQL.Clear;
            SQL.Text:='select * from qrylaporan_penilaian where tahun='+QuotedStr(edttahun.Text)+' and kd_teater='+QuotedStr(edtkode.Text)+' order by kd_juri asc, kd_sub_kriteria asc';
            Open;
            if IsEmpty then
             begin
              MessageDlg('Penilaian Pada Tahun ini Tidak ada',mtInformation,[mbOK],0);
              Exit;
             end
          end;
       end
     else
     if rb_perjuri.Checked=True then
      begin
        if dblkcbbjuri.KeyValue=null then
          begin
            MessageDlg('Juri Belum Dipilih',mtWarning,[mbOK],0);
            dblkcbbjuri.SetFocus;
            Exit;
          end
         else
         begin
           with report_penilaian.qrylaporan_penilaian do
            begin
             close;
             SQL.Clear;
             SQL.Text:='select * from qrylaporan_penilaian where tahun='+QuotedStr(edttahun.Text)+' and kd_teater='+QuotedStr(edtkode.Text)+' and kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+'order by kd_juri asc, kd_sub_kriteria asc';
             Open;
             if IsEmpty then
              begin
               MessageDlg('Penilaian Pada Tahun ini Tidak ada',mtInformation,[mbOK],0);
               Exit;
              end
            end;
         end;
      end;
  end;

  report_penilaian.qrlbl2.Caption:='Laporan Penilaian Tahun '+edttahun.Text;
  //report_penilaian.qrlbl1.Caption:='SANGGAR TITIAN BARANTAI TAHUN '+edttahun.Text;
  report_penilaian.qrlblbulan.Caption:=f_menuutama.bulan(Now);
  report_penilaian.Preview;

end;

procedure Tf_lap_penilaian.rb_jenis_semuaClick(Sender: TObject);
begin
 edtnama.Clear;
 btnbantu.Enabled:=false;
end;

procedure Tf_lap_penilaian.rb_jenis_pergrubClick(Sender: TObject);
begin
 edtnama.Clear;
 btnbantu.Enabled:=True;
end;

procedure Tf_lap_penilaian.rb_semua_juriClick(Sender: TObject);
begin
 dblkcbbjuri.Enabled:=false;
 dblkcbbjuri.KeyValue:=null;
end;

procedure Tf_lap_penilaian.rb_perjuriClick(Sender: TObject);
begin
 dblkcbbjuri.Enabled:=True;
 dblkcbbjuri.KeyValue:=null;
end;

procedure Tf_lap_penilaian.btnbantuClick(Sender: TObject);
begin
 f_bantu_teater.edt1.Text:='lap_nilai';
 f_bantu_teater.ShowModal;
end;

end.
