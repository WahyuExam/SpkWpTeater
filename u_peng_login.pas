unit u_peng_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_peng_gantisandi = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtpengguna: TEdit;
    edtsandilama: TEdit;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    Label4: TLabel;
    edtsandibaru: TEdit;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncampurClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_peng_gantisandi: Tf_peng_gantisandi;

implementation

uses
  u_dm;

{$R *.dfm}

procedure Tf_peng_gantisandi.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_peng_gantisandi.FormShow(Sender: TObject);
begin
  edtpengguna.Enabled:=false; edtpengguna.Text:=dm.tblpengguna.fieldbyname('pengguna').AsString;
  edtsandilama.Enabled:=false; edtsandilama.Text:=dm.tblpengguna.fieldbyname('sandi').AsString;
  edtsandibaru.Clear; edtsandibaru.Enabled:=false;

  btncampur.Enabled:=True; btncampur.Caption:='Ubah';
  btnsimpan.Enabled:=false;
  btnkeluar.Enabled:=True;
end;

procedure Tf_peng_gantisandi.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Ubah' then
  begin
   edtsandibaru.Enabled:=True;
   edtsandibaru.SetFocus;

   btncampur.Caption:='Batal';
   btnsimpan.Enabled:=True;
   btnkeluar.Enabled:=false;
  end
  else
 if btncampur.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_peng_gantisandi.btnsimpanClick(Sender: TObject);
begin
 if Trim(edtsandibaru.Text)='' then
  begin
    MessageDlg('Kata Sandi Baru Belum Diisi',mtWarning,[mbok],0);
    edtsandibaru.SetFocus;
    Exit;
  end;
  
 with dm.tblpengguna do
  begin
    Edit;
    FieldByName('sandi').AsString:=edtsandibaru.Text;
    Post;
  end;
  MessageDlg('Kata Sandi Sudah Diubah',mtInformation,[mbok],0);
  FormShow(Sender);
end;

end.
