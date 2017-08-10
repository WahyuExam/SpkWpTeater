unit u_teater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_mast_teater = class(TForm)
    grp2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edtkode: TEdit;
    grp3: TGroupBox;
    dbgrd1: TDBGrid;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    Label4: TLabel;
    Label7: TLabel;
    edtnama: TEdit;
    edttelp: TEdit;
    mmoalamat: TMemo;
    grp1: TGroupBox;
    Label1: TLabel;
    grp5: TGroupBox;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    Label5: TLabel;
    edtpencarian: TEdit;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btncampurClick(Sender: TObject);
    procedure edtnamaKeyPress(Sender: TObject; var Key: Char);
    procedure edttelpKeyPress(Sender: TObject; var Key: Char);
    procedure mmoalamatKeyPress(Sender: TObject; var Key: Char);
    procedure btnsimpanClick(Sender: TObject);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure btnhapusClick(Sender: TObject);
    procedure edtpencarianChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
  end;

var
  f_mast_teater: Tf_mast_teater;
  status, kode, nm_grub_lama, telp_lama, alamat_lama : string;

implementation

uses
  u_dm, StrUtils, DB;

{$R *.dfm}

procedure Tf_mast_teater.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_mast_teater.FormShow(Sender: TObject);
begin
 edtkode.Enabled:=False; edtkode.Clear;
 edtnama.Enabled:=False; edtnama.Clear;
 edttelp.Enabled:=false; edttelp.Clear;
 mmoalamat.Enabled:=false; mmoalamat.Clear;

 btncampur.Enabled:=True; btncampur.Caption:='Tambah';
 btnsimpan.Enabled:=false;
 btnubah.Enabled:=False;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=True;

 dbgrd1.Enabled:=True;
 edtpencarian.Enabled:=True; edtpencarian.Clear;

 konek;
end;

procedure Tf_mast_teater.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Tambah' then
  begin
    with dm.qrypeserta do
     begin
       close;
       SQL.Clear;
       SQL.Text:='select * from tbl_peserta order by kd_teater asc';
       Open;
       if IsEmpty then kode:='001' else
        begin
          Last;
          kode := RightStr(fieldbyname('kd_teater').AsString,3);
          kode := IntToStr(StrToInt(kode)+1);
        end;
     end;
     edtkode.Text:='TEA-'+format('%.3d',[StrToInt(kode)]);

     edtnama.Enabled:=True; edtnama.SetFocus; edtnama.Clear;
     edttelp.Enabled:=True; edttelp.Clear;
     mmoalamat.Enabled:=True; mmoalamat.Clear;

     btncampur.Caption:='Batal';
     btnsimpan.Enabled:=True;
     btnubah.Enabled:=false;
     btnhapus.Enabled:=false;
     btnkeluar.Enabled:=False;

     dbgrd1.Enabled:=false;
     edtpencarian.Enabled:=false; edtpencarian.Clear;
     status:='simpan';
  end
  else
 if btncampur.Caption='Batal' then FormShow(Sender);
end;

procedure Tf_mast_teater.edtnamaKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['a'..'z','A'..'Z',#13,#32,#8,#9,'0'..'9','.']) then Key:=#0;
 if Key=#13 then
  begin
   if dm.qrypeserta.Locate('nm_grub_teater',edtnama.Text,[]) then
    begin
     MessageDlg('Nama Grub Teater Sudah Ada',mtInformation,[mbok],0);
     edtnama.Clear;
     edtnama.SetFocus;
     Exit;
    end
    else
    edttelp.SetFocus;
  end;
end;

procedure Tf_mast_teater.edttelpKeyPress(Sender: TObject; var Key: Char);
begin
if not (key in [#13,#8,#9,'0'..'9']) then Key:=#0;
 if Key=#13 then mmoalamat.SetFocus;
end;

procedure Tf_mast_teater.mmoalamatKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['a'..'z','A'..'Z',#13,#32,#8,#9,'0'..'9','.']) then Key:=#0;
 if Key=#13 then btnsimpan.Click;
end;

procedure Tf_mast_teater.btnsimpanClick(Sender: TObject);
begin
 if (Trim(edtnama.Text)='') or (edttelp.Text='') or (Trim(mmoalamat.Text)='') then
  begin
    MessageDlg('Semua Data Wajib Disi',mtWarning,[mbok],0);
    if Trim(edtnama.Text)='' then edtnama.SetFocus else
    if edttelp.Text='' then edttelp.SetFocus else
    if Trim(mmoalamat.Text)='' then mmoalamat.SetFocus;
    Exit;
  end;

 with dm.qrypeserta do
  begin
    if status='simpan' then
     begin
       if Locate('nm_grub_teater',edtnama.Text,[]) then
        begin
          MessageDlg('Nama Grub Teater Sudah Ada',mtInformation,[mbok],0);
          edtnama.SetFocus;
          Exit;
        end
        else
        begin
          Append;
          FieldByName('kd_teater').AsString := edtkode.Text;
        end;
     end
     else
    if status='ubah' then
     begin
       if (edtnama.Text = nm_grub_lama) and (edttelp.Text=telp_lama) and (mmoalamat.Text=alamat_lama) then
        begin
          MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
          FormShow(Sender);
          Exit;
        end
        else
       if edtnama.Text <> nm_grub_lama then
        begin
          if Locate('nm_grub_teater',edtnama.Text,[]) then
           begin
             MessageDlg('Nama Grub Teater Sudah Ada',mtWarning,[mbok],0);
             edtnama.SetFocus;
             Exit;
           end
           else
           begin
             if Locate('kd_teater',edtkode.Text,[]) then Edit;
           end;
        end
        else
        begin
          if Locate('kd_teater',edtkode.Text,[]) then Edit;
        end;
     end;

     FieldByName('nm_grub_teater').AsString:= edtnama.Text;
     FieldByName('telp').AsString:= edttelp.Text;
     FieldByName('alamat').AsString:= mmoalamat.Text;
     Post;
     MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
     FormShow(Sender);
  end;
end;

procedure Tf_mast_teater.dbgrd1DblClick(Sender: TObject);
begin
 btnubah.Enabled:=True;
 btnhapus.Enabled:=True;
 btnkeluar.Enabled:=false;
 btncampur.Caption:='Batal';
end;

procedure Tf_mast_teater.btnubahClick(Sender: TObject);
begin
 status:='ubah';

 btncampur.Caption:='Batal';
 btnsimpan.Enabled:=True;
 btnubah.Enabled:=false;
 btnhapus.Enabled:=False;
 btnkeluar.Enabled:=false;

 edtnama.Enabled:=True;  edtnama.SetFocus;
 edttelp.Enabled:=True;
 mmoalamat.Enabled:=True;

 dbgrd1.Enabled:=false;
 edtpencarian.Clear; edtpencarian.Enabled:=False;
end;

procedure Tf_mast_teater.dbgrd1CellClick(Column: TColumn);
begin
 edtkode.Text:= dbgrd1.Fields[0].AsString;
 edtnama.Text:= dbgrd1.Fields[1].AsString;
 nm_grub_lama:= edtnama.Text;
 edttelp.Text:= dbgrd1.Fields[2].AsString;
 telp_lama:=edttelp.Text;
 mmoalamat.Text:= dbgrd1.Fields[3].AsString;
 alamat_lama:=mmoalamat.Text;
end;

procedure Tf_mast_teater.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
    if dm.qrypeserta.Locate('kd_teater',edtkode.Text,[]) then dm.qrypeserta.Delete;
    MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
    FormShow(Sender);
  end;
end;

procedure Tf_mast_teater.konek;
begin
 with dm.qrypeserta do
  begin
    DisableControls;
    close;
    SQL.Clear;
    sql.Text:='select * from tbl_peserta order by kd_teater asc';
    Open;
    EnableControls;
  end;
end;

procedure Tf_mast_teater.edtpencarianChange(Sender: TObject);
begin
 if edtpencarian.Text='' then konek else
  begin
     with dm.qrypeserta do
       begin
        DisableControls;
        close;
        SQL.Clear;
        sql.Text:='select * from tbl_peserta where kd_teater like ''%'+edtpencarian.Text+'%'' or nm_grub_teater like ''%'+edtpencarian.Text+'%''';
        Open;
        EnableControls;
       end;
  end;
end;

end.
