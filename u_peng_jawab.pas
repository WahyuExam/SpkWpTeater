unit u_peng_jawab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_peng_penanggungjawab = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edtnama: TEdit;
    edtjabatan: TEdit;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    Label2: TLabel;
    edtnip: TEdit;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncampurClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure edtnipKeyPress(Sender: TObject; var Key: Char);
    procedure edtnamaKeyPress(Sender: TObject; var Key: Char);
    procedure edtjabatanKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_peng_penanggungjawab: Tf_peng_penanggungjawab;

implementation

uses
  u_dm;

{$R *.dfm}

procedure Tf_peng_penanggungjawab.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_peng_penanggungjawab.FormShow(Sender: TObject);
begin
 edtnama.Enabled:=false; edtnama.Text:=dm.tblpenanggungjawab.fieldbyname('nm_jawab').AsString;
 edtjabatan.Enabled:=False; edtjabatan.Text:=dm.tblpenanggungjawab.fieldbyname('jabatan').AsString;

 btncampur.Caption:='Ubah'; btncampur.Enabled:=True;
 btnsimpan.Enabled:=false;
 btnkeluar.Enabled:=True;
end;

procedure Tf_peng_penanggungjawab.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Ubah' then
  begin
   edtnama.Enabled:=True; edtnama.SetFocus;
   edtjabatan.Enabled:=True;

   btncampur.Caption:='Batal';
   btnsimpan.Enabled:=True;
   btnkeluar.Enabled:=false;

  end
  else
 if btncampur.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_peng_penanggungjawab.btnsimpanClick(Sender: TObject);
begin
 if (Trim(edtnip.Text)='') or (Trim(edtnama.Text)='') or (Trim(edtjabatan.Text)='') then
  begin
    MessageDlg('Semua Data Wajib Diisi',mtWarning,[mbOK],0);
    if (Trim(edtnama.Text)='') then edtnama.SetFocus else
    if (Trim(edtjabatan.Text)='') then edtjabatan.SetFocus;
    Exit;
  end;

 with dm.tblpenanggungjawab do
  begin
   Edit;
   FieldByName('nm_jawab').AsString:=edtnama.Text;
   FieldByName('jabatan').AsString:=edtjabatan.Text;
   Post;
  end;
  MessageDlg('Penangungg Jawab Sudah Disimpan',mtInformation,[mbok],0);
  FormShow(Sender);
end;

procedure Tf_peng_penanggungjawab.edtnipKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#32,#8,#9]) then Key:=#0;
 if Key=#13 then edtnama.SetFocus;
end;

procedure Tf_peng_penanggungjawab.edtnamaKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['a'..'z','A'..'Z','.',',',#13,#32,#8,#9]) then Key:=#0;
 if Key=#13 then edtjabatan.SetFocus;
end;

procedure Tf_peng_penanggungjawab.edtjabatanKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['a'..'z','A'..'Z','.',',',#13,#32,#8,#9]) then Key:=#0;
 if Key=#13 then btnsimpan.Click;
end;

end.
