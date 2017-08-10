unit u_bobot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_mast_bobot = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtkriteria: TEdit;
    edtbobot: TEdit;
    Label4: TLabel;
    grp3: TGroupBox;
    dbgrd1: TDBGrid;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    Label5: TLabel;
    edtjumlah: TEdit;
    Label6: TLabel;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncampurClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure edtbobotKeyPress(Sender: TObject; var Key: Char);
    procedure btnsimpanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_mast_bobot: Tf_mast_bobot;
  jml_bobot, bobot, a, ttl_bobot : Integer;

implementation

uses
  u_dm, DB;

{$R *.dfm}

procedure Tf_mast_bobot.btnkeluarClick(Sender: TObject);
begin
 if StrToInt(edtjumlah.Text)<100 then
  begin
    MessageDlg('Jumlah Bobot Harus Bernilai 100 %',mtWarning,[mbok],0);
    Exit;
  end
  else
  close;
end;

procedure Tf_mast_bobot.FormShow(Sender: TObject);
begin
 edtkriteria.Clear; edtkriteria.Enabled:=false;
 edtbobot.Clear; edtbobot.Enabled:=false;

 dbgrd1.Enabled:=True;
 edtjumlah.Enabled:=false; edtjumlah.Text:='100';

 btncampur.Caption:='Ubah'; btncampur.Enabled:=True;
 btnsimpan.Enabled:=false;
 btnkeluar.Enabled:=True;

 with dm.qrybobot do
  begin
    close;
    SQL.Clear;
    sql.Text:='select * from tbl_bobot';
    Open;
    ttl_bobot:=0;
    for a:=1 to RecordCount do
     begin
       RecNo:=a;
       ttl_bobot:=ttl_bobot+fieldbyname('bobot').AsInteger;
     end;
     a:=a+1;
     edtjumlah.Text:=IntToStr(ttl_bobot);
  end;

 with dm.qrytampil_bobot do
  begin
    DisableControls;
    close;
    SQL.Clear;
    SQL.Text:='select a.kd_bobot, b.kd_kriteria, b.kriteria, a.bobot from tbl_bobot a, tbl_kriteria b where a.kd_kriteria=b.kd_kriteria';
    open;
    EnableControls;
  end;
end;

procedure Tf_mast_bobot.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Ubah' then
  begin
   if edtkriteria.Text='' then
    begin
      MessageDlg('Data Belum Dipilih',mtWarning,[mbok],0);
      Exit;
    end
    else
    begin
      btncampur.Caption:='Batal';
      btnkeluar.Enabled:=false;
      btnsimpan.Enabled:=True;
      edtbobot.Enabled:=True; edtbobot.SetFocus;
    end;
  end
  else
 if btncampur.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_mast_bobot.dbgrd1DblClick(Sender: TObject);
begin
 edtkriteria.Text:=dbgrd1.Fields[2].AsString;
 edtbobot.Text:=dbgrd1.Fields[3].AsString;
 bobot:=StrToInt(edtbobot.Text);
end;

procedure Tf_mast_bobot.edtbobotKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#9,#8]) then Key:=#0;
 if Key=#13 then btnsimpan.Click;
end;

procedure Tf_mast_bobot.btnsimpanClick(Sender: TObject);
begin
 jml_bobot := (StrToInt(edtjumlah.Text)-bobot)+StrToInt(edtbobot.Text);
 if jml_bobot > 100 then
  begin
    MessageDlg('Jumlah Bobot Harus Bernilai 100 %',mtWarning,[mbok],0);
    edtbobot.Text:=IntToStr(bobot);
    edtbobot.SetFocus;
  end
  else
  begin
    with dm.qrybobot do
     begin
      Locate('kd_bobot',dbgrd1.Fields[0].AsString,[]);
      Edit;
      FieldByName('bobot').AsString := edtbobot.Text;
      Post;
     end;
     MessageDlg('Bobot Sudah Diubah',mtInformation,[mbOK],0);
     FormShow(Sender);
     if StrToInt(edtjumlah.Text) < 100 then
      begin
        MessageDlg('Jumlah Bobot Kurang Dari 100',mtInformation,[mbOK],0);
      end;
  end;
end;

end.
