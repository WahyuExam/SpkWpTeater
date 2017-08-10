unit u_mast_juri;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_maste_juri = class(TForm)
    grp2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    edtkode: TEdit;
    edtnama: TEdit;
    edttelp: TEdit;
    grp3: TGroupBox;
    dbgrd1: TDBGrid;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    grp1: TGroupBox;
    Label1: TLabel;
    grp5: TGroupBox;
    Label5: TLabel;
    edtpencarian: TEdit;
    cbbjabatan: TComboBox;
    img1: TImage;
    procedure FormShow(Sender: TObject);
    procedure cbbjabatanKeyPress(Sender: TObject; var Key: Char);
    procedure btncampurClick(Sender: TObject);
    procedure btnsimpanClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure btnkeluarClick(Sender: TObject);
    procedure dbgrd1CellClick(Column: TColumn);
    procedure dbgrd1DblClick(Sender: TObject);
    procedure edtpencarianChange(Sender: TObject);
    procedure edtnamaKeyPress(Sender: TObject; var Key: Char);
    procedure edttelpKeyPress(Sender: TObject; var Key: Char);
    procedure cbbjabatanClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
  end;

var
  f_maste_juri: Tf_maste_juri;
  status, kode, nm_juri, telp_lama, jabatan_lama : string;
  a : Integer;

implementation

uses
  u_dm, StrUtils;

{$R *.dfm}

procedure Tf_maste_juri.FormShow(Sender: TObject);
begin
  with dm.qryjuri do
  begin
    close;
    SQL.Clear;
    sql.Text:='select * from tbl_juri order by kd_juri asc';
    Open;
    if IntToStr(RecordCount)='3' then
     begin
      btncampur.Enabled:=false;
      btnsimpan.Enabled:=False;
      btnubah.Enabled:=false;
      btnhapus.Enabled:=false;
      btnkeluar.Enabled:=True;
      dbgrd1.Enabled:=True;
      edtpencarian.Enabled:=True;
     end
     else
     begin
       btncampur.Enabled:=True; btncampur.Caption:='Tambah';
       btnsimpan.Enabled:=false;
       btnubah.Enabled:=False;
       btnhapus.Enabled:=false;
       btnkeluar.Enabled:=True;
     end;
     edtkode.Enabled:=False; edtkode.Clear;
     edtnama.Enabled:=False; edtnama.Clear;
     edttelp.Enabled:=false; edttelp.Clear;
     cbbjabatan.Enabled:=False; cbbjabatan.Text:='';
     dbgrd1.Enabled:=True;
     edtpencarian.Enabled:=True; edtpencarian.Clear;
  end;
  konek;
end;

procedure Tf_maste_juri.cbbjabatanKeyPress(Sender: TObject; var Key: Char);
begin
 Key:=#0;
end;

procedure Tf_maste_juri.konek;
begin
 with dm.qryjuri do
  begin
    DisableControls;
    close;
    SQL.Clear;
    sql.Text:='select * from tbl_juri order by kd_juri asc';
    Open;
    EnableControls;
  end;
end;

procedure Tf_maste_juri.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Tambah' then
  begin
    with dm.qryjuri do
     begin
       close;
       SQL.Clear;
       SQL.Text:='select * from tbl_juri order by kd_juri asc';
       Open;
       if IsEmpty then kode:='001' else
        begin
          Last;
          kode := RightStr(fieldbyname('kd_juri').AsString,3);
          kode := IntToStr(StrToInt(kode)+1);
        end;
     end;
     edtkode.Text:='JUR-'+format('%.3d',[StrToInt(kode)]);

     edtnama.Enabled:=True; edtnama.SetFocus; edtnama.Clear;
     edttelp.Enabled:=True; edttelp.Clear;
     cbbjabatan.Enabled:=True; cbbjabatan.Text:='';

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

procedure Tf_maste_juri.btnsimpanClick(Sender: TObject);
begin
 if (Trim(edtnama.Text)='') or (edttelp.Text='') or (cbbjabatan.Text='') then
  begin
    MessageDlg('Semua Data Wajib Disi',mtWarning,[mbok],0);
    if Trim(edtnama.Text)='' then edtnama.SetFocus else
    if edttelp.Text='' then edttelp.SetFocus else
    if cbbjabatan.Text='' then cbbjabatan.SetFocus;
    Exit;
  end;

 with dm.qryjuri do
  begin
    if status='simpan' then
     begin
       if Locate('nm_juri',edtnama.Text,[]) then
        begin
          MessageDlg('Nama Juri Sudah Ada',mtWarning,[mbok],0);
          edtnama.SetFocus;
          Exit;
        end
        else
       if Locate('jabatan',cbbjabatan.Text,[]) then
        begin
          MessageDlg('Jabatan Sudah Ada',mtWarning,[mbok],0);
          cbbjabatan.SetFocus;
          Exit;
        end
        else
        begin
          Append;
          FieldByName('kd_juri').AsString := edtkode.Text;
        end;
     end
     else
    if status='ubah' then
     begin
       if (edtnama.Text = nm_juri) and (edttelp.Text=telp_lama) and (cbbjabatan.Text=jabatan_lama) then
        begin
          MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
          FormShow(Sender);
          Exit;
        end
        else
       if edtnama.Text <> nm_juri then
        begin
          if Locate('nm_juri',edtnama.Text,[]) then
           begin
             MessageDlg('Nama Juri Sudah Ada',mtWarning,[mbok],0);
             edtnama.SetFocus;
             Exit;
           end
           else
           begin
             if Locate('kd_juri',edtkode.Text,[]) then Edit;
           end;
        end
        else
       if cbbjabatan.Text<>jabatan_lama then
        begin
          if Locate('jabatan',cbbjabatan.Text,[]) then
            begin
             MessageDlg('Jabatan Sudah Ada',mtWarning,[mbok],0);
             cbbjabatan.SetFocus;
              Exit;
            end
            else
            begin
              if Locate('kd_juri',edtkode.Text,[]) then Edit;
            end;
        end
        else
        begin
          if Locate('kd_juri',edtkode.Text,[]) then Edit;
        end;
     end;

     FieldByName('nm_juri').AsString:= edtnama.Text;
     FieldByName('telp').AsString:= edttelp.Text;
     FieldByName('jabatan').AsString:= cbbjabatan.Text;
     Post;
     MessageDlg('Data Sudah Disimpan',mtInformation,[mbok],0);
     FormShow(Sender);
  end;
end;

procedure Tf_maste_juri.btnubahClick(Sender: TObject);
begin
 status:='ubah';

 btncampur.Caption:='Batal';
 btnsimpan.Enabled:=True;
 btnubah.Enabled:=false;
 btnhapus.Enabled:=False;
 btnkeluar.Enabled:=false;

 edtnama.Enabled:=True;  edtnama.SetFocus;
 edttelp.Enabled:=True;
 cbbjabatan.Enabled:=True;
 
 dbgrd1.Enabled:=false;
 edtpencarian.Clear; edtpencarian.Enabled:=False;

end;

procedure Tf_maste_juri.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Yakin Data Akan Dihapus ?',mtConfirmation,[mbyes,mbno],0)=mryes then
  begin
    if dm.qryjuri.Locate('kd_juri',edtkode.Text,[]) then dm.qryjuri.Delete;
    MessageDlg('Data Sudah Dihapus',mtInformation,[mbOK],0);
    FormShow(Sender);
  end;
end;

procedure Tf_maste_juri.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_maste_juri.dbgrd1CellClick(Column: TColumn);
begin
 edtkode.Text:= dbgrd1.Fields[0].AsString;
 edtnama.Text:= dbgrd1.Fields[1].AsString;
 nm_juri:= edtnama.Text;
 edttelp.Text:= dbgrd1.Fields[2].AsString;
 telp_lama:=edttelp.Text;
 cbbjabatan.Text:= dbgrd1.Fields[3].AsString;
 jabatan_lama:=cbbjabatan.Text;
end;

procedure Tf_maste_juri.dbgrd1DblClick(Sender: TObject);
begin
 btnubah.Enabled:=True;
 btnhapus.Enabled:=True;
 btnkeluar.Enabled:=false;
 btncampur.Caption:='Batal';
 btncampur.Enabled:=True;
end;

procedure Tf_maste_juri.edtpencarianChange(Sender: TObject);
begin
 if edtpencarian.Text='' then konek else
  begin
     with dm.qryjuri do
       begin
        DisableControls;
        close;
        SQL.Clear;
        sql.Text:='select * from tbl_juri where kd_juri like ''%'+edtpencarian.Text+'%'' or nm_juri like ''%'+edtpencarian.Text+'%''';
        Open;
        EnableControls;
       end;
  end;
end;

procedure Tf_maste_juri.edtnamaKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['a'..'z','A'..'Z',#13,#32,#8,#9,'.',',']) then Key:=#0;
 if Key=#13 then edttelp.SetFocus;
end;

procedure Tf_maste_juri.edttelpKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in [#13,#8,#9,'0'..'9']) then Key:=#0;
 if Key=#13 then cbbjabatan.SetFocus;
end;

procedure Tf_maste_juri.cbbjabatanClick(Sender: TObject);
begin
 btnsimpan.SetFocus;
end;

end.
