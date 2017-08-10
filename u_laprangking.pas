unit u_laprangking;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_laprangking = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    edttahun: TEdit;
    btnlihatdata: TBitBtn;
    btnkeluar: TBitBtn;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure btnlihatdataClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_laprangking: Tf_laprangking;
  a : Integer;
  ada : Boolean;

implementation

uses
  u_dm, DB, u_report_rangking, u_menuutama;

{$R *.dfm}

procedure Tf_laprangking.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_laprangking.edttahunKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then key:=#0;
end;

procedure Tf_laprangking.btnlihatdataClick(Sender: TObject);
begin
 if Trim(edttahun.Text)='' then
  begin
    MessageDlg('Tahun belum Diisi',mtWarning,[mbok],0);
    edttahun.SetFocus;
    Exit;
  end;

 with dm.qrytampil_rangking do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, a.nil_s, a.hasil_wp, a.juara from tbl_rangking a,');
    sql.Add('tbl_peserta b where a.kd_teater=b.kd_teater and a.tahun='+QuotedStr(edttahun.Text)+' order by a.hasil_wp desc');
    Open;
    if IsEmpty then
     begin
       MessageDlg('Data Kosong',mtInformation,[mbok],0);
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
           MessageDlg('Lakukan proses Hasil S dan V Terlebih Dahulu',mtInformation,[mbOK],0);
           Exit;
         end
         else
         begin
           report_rangking.qrlblbulan.Caption:=f_menuutama.bulan(Now);
           report_rangking.qrlbl2.Caption := 'Laporan Hasil Juara Lomba Tearer Tahun '+edttahun.Text;
           report_rangking.Preview;
         end;

     end;

  end;
end;

procedure Tf_laprangking.FormShow(Sender: TObject);
begin
 edttahun.Text:=FormatDateTime('yyyy',Now);
end;

end.
