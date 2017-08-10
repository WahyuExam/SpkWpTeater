unit u_penilaian;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, DBCtrls, jpeg, ExtCtrls;

type
  Tf_trans_penilaian = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp2: TGroupBox;
    Label2: TLabel;
    edttahun: TEdit;
    Label3: TLabel;
    edtnama: TEdit;
    btnbantu: TBitBtn;
    grp3: TGroupBox;
    grp4: TGroupBox;
    Label5: TLabel;
    edtk1_intonasi: TEdit;
    Label6: TLabel;
    edtk1_artikulasi: TEdit;
    grp5: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    edtk2_peng_naskah: TEdit;
    edtk2_peng_watak: TEdit;
    grp6: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    edtk3_ekspresi: TEdit;
    edtk3_bahastubuh: TEdit;
    grp7: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    edtk4_kekompakan: TEdit;
    edtk4_penguasaanpang: TEdit;
    grp8: TGroupBox;
    Label13: TLabel;
    edtk5_tatarias: TEdit;
    grp9: TGroupBox;
    Label15: TLabel;
    edtk6_alur: TEdit;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label4: TLabel;
    cbbpenilai: TComboBox;
    grp10: TGroupBox;
    grp11: TGroupBox;
    btncampur: TBitBtn;
    btnsimpan: TBitBtn;
    btnkeluar: TBitBtn;
    btnubah: TBitBtn;
    btnhapus: TBitBtn;
    dbgrd1: TDBGrid;
    edtkdteater: TEdit;
    btnbatal2: TBitBtn;
    btnubah2: TBitBtn;
    dblkcbbjuri: TDBLookupComboBox;
    img1: TImage;
    grpsm_juri: TGroupBox;
    dbgrd2: TDBGrid;
    procedure btnkeluarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure btncampurClick(Sender: TObject);
    procedure btnbantuClick(Sender: TObject);
    procedure cbbpenilaiClick(Sender: TObject);
    procedure edtk1_intonasiKeyPress(Sender: TObject; var Key: Char);
    procedure cbbpenilaiKeyPress(Sender: TObject; var Key: Char);
    procedure edtk6_alurKeyPress(Sender: TObject; var Key: Char);
    procedure btnsimpanClick(Sender: TObject);
    procedure btnubahClick(Sender: TObject);
    procedure btnbatal2Click(Sender: TObject);
    procedure btnhapusClick(Sender: TObject);
    procedure btnubah2Click(Sender: TObject);
    procedure dblkcbbjuriCloseUp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek_kosong;
    procedure konek_nilai;
    procedure penilaian_mati;
    procedure penilaian_hidup;
    procedure penilaia_tidak_aktif;
    procedure penilaian_aktif;
    procedure cek_semua_isi_nilai;
  end;

var
  f_trans_penilaian: Tf_trans_penilaian;
  kode, kode_proses, status, rata_nil : string;
  a, b, c, d, e : Integer;
  nilai : array [1..10] of Integer;
  ada : Boolean;
  nilai_juri : Integer;
  nilai_kriteria, nilai_3juri, hasil_s, total_s, hasil_v : Real;
  nilai_k, hasil_3juri : string;
 

implementation

uses
  u_dm, StrUtils, DB, u_bantu_teater, ADODB;

{$R *.dfm}

procedure Tf_trans_penilaian.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_trans_penilaian.FormShow(Sender: TObject);
begin
 edttahun.Enabled:=True; edttahun.Text:=FormatDateTime('yyyy',Now);
 edtnama.Clear; edtnama.Enabled:=false;
 btnbantu.Enabled:=True;

 //cbbpenilai.Enabled:=false; cbbpenilai.Text:='';
 dblkcbbjuri.Enabled:=false; dblkcbbjuri.KeyValue:=null;
 penilaian_mati;

 dbgrd1.Enabled:=false;

 btncampur.Enabled:=True; btncampur.Caption:='Tambah'; btncampur.BringToFront;
 btnsimpan.Enabled:=false; btnsimpan.Caption:='Simpan';
 btnubah.Enabled:=false; btnubah2.SendToBack;
 btnhapus.Enabled:=false;
 btnkeluar.Enabled:=True;

 konek_kosong;

 with dm.qrytampil_tmp_rata do
  begin
    close;
    SQL.Clear;
    SQL.add('select c.kd_proses, c.tahun, b.kd_teater, b.nm_grub_teater, a.kr_01, a.kr_02, a.kr_03, a.kr_04, a.kr_05,');
    sql.Add('a.kr_06 from tbl_rangking c, tbl_peserta b, tbl_tmp_rata a where c.kd_teater = b.kd_teater and a.kd_proses = c.kd_proses');
    sql.Add('order by c.kd_proses asc');
    Open;
  end;
  //dbgrd2.BringToFront;
  grpsm_juri.BringToFront;
end;

procedure Tf_trans_penilaian.edttahunKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
end;

procedure Tf_trans_penilaian.btncampurClick(Sender: TObject);
begin
 if btncampur.Caption='Tambah' then
  begin
    if (Trim(edttahun.Text)='') or (edtnama.Text='') then
     begin
       MessageDlg('Tahun dan Grub Teater Wajib Diisi',mtWarning,[mbok],0);
       edttahun.SetFocus;
       Exit;
     end;

    with dm.qryrangking do
     begin
       close;
       SQL.Clear;
       SQL.Text:='select * from tbl_rangking order by kd_proses asc';
       Open;
       if Locate('tahun;kd_teater',VarArrayOf([edttahun.Text,edtkdteater.Text]),[]) then
        begin
          MessageDlg('Grub Teater Sudah Dinilai Pada Tahun ini',mtInformation,[mbOK],0);
          btnubah2.BringToFront; btnubah2.Enabled:=True;
          btnhapus.Enabled:=True;
          btnkeluar.Enabled:=False;
          btncampur.Enabled:=False;
          btnsimpan.Enabled:=false;

          kode_proses:=fieldbyname('kd_proses').AsString;
          status:='ubah';
          Exit;
        end
        else
        begin
         if IsEmpty then kode:='001' else
          begin
           Last;
           kode := RightStr(fieldbyname('kd_proses').AsString,3);
           kode := IntToStr(StrToInt(kode)+1);
          end;
         kode_proses := 'PR-'+Format('%.3d',[StrToInt(kode)]);

         Append;
         FieldByName('kd_proses').AsString:=kode_proses;
         FieldByName('tahun').AsString := edttahun.Text;
         FieldByName('kd_teater').AsString := edtkdteater.Text;
         Post;

         //juri
         with dm.qryjuri do
          begin
            close;
            SQL.Clear;
            SQL.Text:='select * from tbl_juri order by jabatan asc';
            Open;
            for a:= 1 to RecordCount do
             begin
              RecNo:=a;
              with dm.qrysubkriteria do
                begin
                 close;
                 SQL.Clear;
                 SQL.Text:='select * from tbl_sub_kriteria order by kd_sub_kriteria asc';
                 Open;
                 for b:=1 to RecordCount do
                  begin
                   RecNo := b;

                    with dm.qrynilai do
                     begin
                      Append;
                      FieldByName('kd_proses').AsString:= kode_proses;
                      FieldByName('kd_sub_kriteria').AsString := dm.qrysubkriteria.fieldbyname('kd_sub_kriteria').AsString;
                      FieldByName('kd_juri').AsString:= dm.qryjuri.fieldbyname('kd_juri').AsString;
                      Post;
                     end;
                  end;
                  b:=b+1;
                end;
             end;
            a:=a+1;
          end;

         edttahun.Enabled:=false;
         btnbantu.Enabled:=false;
         //cbbpenilai.Enabled:=True;
         dblkcbbjuri.Enabled:=True;

         btncampur.Caption:='Batal';
         btnsimpan.Enabled:=True;
         btnubah.Enabled:=false;
         btnhapus.Enabled:=false;
         btnkeluar.Enabled:=false;
         status:='tambah';
         grpsm_juri.SendToBack;
         //dbgrd2.SendToBack;
        end;
     end;
  end
  else
 if btncampur.Caption='Batal' then
  begin
    if status='tambah' then
     begin
       with dm.qryrangking do
        begin
          Close;
          SQL.Clear;
          SQL.Text:='delete from tbl_rangking where kd_proses='+QuotedStr(kode_proses)+'';
          ExecSQL;
        end;
        FormShow(Sender);
     end
     else
    if status='ubah' then
     begin
       FormShow(Sender);
     end;
  end;

end;

procedure Tf_trans_penilaian.konek_kosong;
begin
 with dm.qrytampil_nilai do
  begin
    close;
    SQL.Clear;
    sql.Add('select a.kd_proses, b.kd_sub_kriteria, b.sub_kriteria, a.nilai, d.kd_juri, d.nm_juri, d.jabatan, c.kd_kriteria, c.kriteria');
    SQL.Add('from tbl_nilai a, tbl_sub_kriteria b, tbl_kriteria c, tbl_juri d where a.kd_sub_kriteria=b.kd_sub_kriteria and b.kd_kriteria=c.kd_kriteria');
    SQL.Add('and a.kd_juri=d.kd_juri and d.kd_juri='+QuotedStr('kosong')+'');
    Open;
  end;
end;

procedure Tf_trans_penilaian.btnbantuClick(Sender: TObject);
begin
 f_bantu_teater.edt1.Text:='penilaian';
 f_bantu_teater.ShowModal;
end;

procedure Tf_trans_penilaian.konek_nilai;
begin
 with dm.qrytampil_nilai do
  begin
    close;
    SQL.Clear;
    SQL.Add('select a.kd_proses, b.kd_sub_kriteria, b.sub_kriteria, a.nilai, d.kd_juri, d.nm_juri, d.jabatan, c.kd_kriteria, c.kriteria');
    SQL.Add('from tbl_nilai a, tbl_sub_kriteria b, tbl_kriteria c, tbl_juri d where a.kd_sub_kriteria=b.kd_sub_kriteria and b.kd_kriteria=c.kd_kriteria');
    sql.Add('and a.kd_juri=d.kd_juri and d.kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+' and a.kd_proses='+QuotedStr(kode_proses)+'');
    Open;
  end;
end;

procedure Tf_trans_penilaian.cbbpenilaiClick(Sender: TObject);
begin
 if cbbpenilai.Text='' then
  begin
    penilaian_mati;
    Exit;
  end;

 konek_nilai;

 with dm.qrynilai do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from tbl_nilai where kd_proses='+QuotedStr(kode_proses)+' and kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+' order by kd_sub_kriteria asc';
    Open;
    ada:=False;
    for a:=1 to RecordCount do
     begin
       RecNo:=a;

       if FieldByName('nilai').AsString='' then ada:=True;
     end;
     a:=a+1;

    if ada=True then
     begin
       penilaian_hidup;

       btncampur.Enabled:=True;
       btnsimpan.Enabled:=True;
       btnubah.Enabled:=false;
       btnhapus.Enabled:=false;
       btnkeluar.Enabled:=false;
     end
    else
     begin
      MessageDlg(cbbpenilai.Text+' Sudah Melakukan Penilaian',mtInformation,[mbOK],0);
      for a:=1 to RecordCount do
       begin
         RecNo := a;

         nilai[a] := fieldbyname('nilai').AsInteger;
       end;
       a:=a+1;

       edtk1_intonasi.Text := IntToStr(nilai[1]);
       edtk1_artikulasi.Text := IntToStr(nilai[2]);
       edtk2_peng_naskah.Text := IntToStr(nilai[3]);
       edtk2_peng_watak.Text := IntToStr(nilai[4]);
       edtk3_ekspresi.Text := IntToStr(nilai[5]);
       edtk3_bahastubuh.Text := IntToStr(nilai[6]);
       edtk4_kekompakan.Text := IntToStr(nilai[7]);
       edtk4_penguasaanpang.Text := IntToStr(nilai[8]);
       edtk5_tatarias.Text := IntToStr(nilai[9]);
       edtk6_alur.Text := IntToStr(nilai[10]);

       penilaia_tidak_aktif;
       btncampur.Enabled:=False;
       btnbatal2.Enabled:=false;
       btnsimpan.Enabled:=false;
       btnubah.Enabled:=True; btnubah.BringToFront;
       btnhapus.Enabled:=false;
       btnkeluar.Enabled:=false;
     end;
  end;

  if btnsimpan.Caption='Proses' then btnsimpan.Enabled:=True;
end;

procedure Tf_trans_penilaian.edtk1_intonasiKeyPress(Sender: TObject;
  var Key: Char);
var a : TEdit;
begin
 a:= sender as TEdit;

 if not (key in ['0'..'9',#13,#9,#8]) then key:=#0;
 if Key=#13 then
  begin
    if a.Text='' then
     begin
       MessageDlg('Nilai Belum Diberikan',mtWarning,[mbOK],0);
       a.SetFocus;
       Exit;
     end;

    if (StrToInt(a.Text)<1) or (StrToInt(a.Text)>100) then
     begin
       MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
       a.Clear;
       a.SetFocus;
     end
     else
     SelectNext(sender as TWinControl, True, True);
  end;
end;

procedure Tf_trans_penilaian.cbbpenilaiKeyPress(Sender: TObject;
  var Key: Char);
begin
 Key:=#0;
end;

procedure Tf_trans_penilaian.edtk6_alurKeyPress(Sender: TObject;
  var Key: Char);
begin
 if not (key in ['0'..'9',#13,#9,#8]) then key:=#0;
 if Key=#13 then
  begin
    if edtk6_alur.Text='' then
     begin
       MessageDlg('Nilai Belum Diberikan',mtWarning,[mbOK],0);
       edtk6_alur.SetFocus;
       Exit;
     end;

    if (StrToInt(edtk6_alur.Text)<1) or (StrToInt(edtk6_alur.Text)>100) then
     begin
       MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
       edtk6_alur.SetFocus;
     end
     else
     btnsimpan.Click;
  end;
end;

procedure Tf_trans_penilaian.btnsimpanClick(Sender: TObject);
begin
 if btnsimpan.Caption='Simpan' then
  begin
   if dblkcbbjuri.KeyValue=null then
    begin
     MessageDlg('Juri Penilai Belum Dipilih',mtWarning,[mbok],0);
     cbbpenilai.SetFocus;
     Exit;
    end;

   if (edtk1_intonasi.Text='') or (edtk1_artikulasi.Text='') or (edtk2_peng_naskah.Text='') or (edtk2_peng_watak.Text='') or
      (edtk3_ekspresi.Text='') or (edtk3_bahastubuh.Text='') or (edtk4_kekompakan.Text='') or (edtk4_penguasaanpang.Text='') or
      (edtk5_tatarias.Text='') or (edtk6_alur.Text='') then
      begin
        MessageDlg('Semua Penilaian Wajib Diisi',mtWarning,[mbok],0);
        Exit;
      end;

   if (StrToInt(edtk1_intonasi.Text)<1) or (StrToInt(edtk1_intonasi.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk1_intonasi.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk1_artikulasi.Text)<1) or (StrToInt(edtk1_artikulasi.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk1_artikulasi.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk2_peng_naskah.Text)<1) or (StrToInt(edtk2_peng_naskah.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk2_peng_naskah.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk2_peng_watak.Text)<1) or (StrToInt(edtk2_peng_watak.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk2_peng_watak.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk3_ekspresi.Text)<1) or (StrToInt(edtk3_ekspresi.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk3_ekspresi.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk3_bahastubuh.Text)<1) or (StrToInt(edtk3_bahastubuh.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk3_bahastubuh.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk4_kekompakan.Text)<1) or (StrToInt(edtk4_kekompakan.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk4_kekompakan.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk4_penguasaanpang.Text)<1) or (StrToInt(edtk4_penguasaanpang.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk4_penguasaanpang.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk5_tatarias.Text)<1) or (StrToInt(edtk5_tatarias.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk5_tatarias.SetFocus;
     Exit;
    end;

   if (StrToInt(edtk6_alur.Text)<1) or (StrToInt(edtk6_alur.Text)>100) then
    begin
     MessageDlg('Inputan Yang Dibolehkan Antara 1 - 100',mtWarning,[mbOK],0);
     edtk6_alur.SetFocus;
     Exit;
    end;

    //simpan nilai
    nilai[1]  := StrToInt(edtk1_intonasi.Text);
    nilai[2]  := StrToInt(edtk1_artikulasi.Text);
    nilai[3]  := StrToInt(edtk2_peng_naskah.Text);
    nilai[4]  := StrToInt(edtk2_peng_watak.Text);
    nilai[5]  := StrToInt(edtk3_ekspresi.Text);
    nilai[6]  := StrToInt(edtk3_bahastubuh.Text);
    nilai[7]  := StrToInt(edtk4_kekompakan.Text);
    nilai[8]  := StrToInt(edtk4_penguasaanpang.Text);
    nilai[9]  := StrToInt(edtk5_tatarias.Text);
    nilai[10] := StrToInt(edtk6_alur.Text);

    with dm.qrynilai do
     begin
       close;
       SQL.Clear;
       SQL.Text:='select * from tbl_nilai where kd_proses='+QuotedStr(kode_proses)+' and kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+' order by kd_sub_kriteria asc';
       Open;
       for a:=1 to RecordCount do
        begin
          RecNo:=a;

          Edit;
          FieldByName('nilai').AsInteger := nilai[a];
          Post;
        end;
        a:=a+1;
     end;
     MessageDlg('Penilaian '+dblkcbbjuri.Text+' Sudah Disimpan',mtInformation,[mbok],0);
     penilaian_mati;
     konek_nilai;

     //cbbpenilai.Text:='';
     dblkcbbjuri.KeyValue:=null;

     //cbbpenilai.Enabled:=True;
     dblkcbbjuri.Enabled:=True;
     btncampur.BringToFront; btncampur.Caption:='Batal'; btncampur.Enabled:=True;

     cek_semua_isi_nilai;

     if status='ubah' then
      begin
        btncampur.BringToFront;
        btncampur.Enabled:=false;
      end;
  end
  else
 if btnsimpan.Caption='Proses' then
  begin
     //simpan ke tmp_rata
     with dm.qrytmp_rata do
       begin
        if Locate('kd_proses',dm.qryrangking.fieldbyname('kd_proses').AsString,[]) then Edit else Append;
        FieldByName('kd_proses').AsString := dm.qryrangking.fieldbyname('kd_proses').AsString;
        Post;
       end;

     with dm.qrykriteria do
      begin
       Close;
       SQL.Clear;
       sql.Text:='select * from tbl_kriteria order by kd_kriteria asc';
       Open;
       for b:=1 to RecordCount do
        begin
          RecNo:=b;

          with dm.qryjuri do
           begin
             close;
             SQL.Clear;
             SQL.Text:='select * from tbl_juri order by kd_juri asc';
             Open;
             for c:=1 to RecordCount do
              begin
               RecNo:=c;
               with dm.qrytampil_nilai do
                 begin
                   Close;
                   SQL.Clear;
                   SQL.Add('select a.kd_proses, b.kd_sub_kriteria, b.sub_kriteria, a.nilai, d.kd_juri, d.nm_juri, d.jabatan, c.kd_kriteria, c.kriteria from');
                   SQL.Add('tbl_nilai a, tbl_sub_kriteria b, tbl_kriteria c, tbl_juri d where a.kd_sub_kriteria=b.kd_sub_kriteria and');
                   SQL.Add('b.kd_kriteria=c.kd_kriteria and a.kd_juri=d.kd_juri and c.kd_kriteria='+QuotedStr(dm.qrykriteria.fieldbyname('kd_kriteria').AsString)+'');
                   sql.Add('and a.kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+' and d.kd_juri='+QuotedStr(dm.qryjuri.fieldbyname('kd_juri').AsString)+'');
                   Open;
                   nilai_kriteria := 0;
                   for d:=1 to RecordCount do
                     begin
                       RecNo:=d;

                       nilai_kriteria:=nilai_kriteria+fieldbyname('nilai').AsVariant;
                     end;
                     d:=d+1;

                   nilai_k := FloatToStr(Round(nilai_kriteria/RecordCount));
                   with dm.qrytemp_nilai do
                    begin
                      Append;
                      FieldByName('kd_proses').AsString:=dm.qryrangking.fieldbyname('kd_proses').AsString;
                      FieldByName('kd_kriteria').AsString:=dm.qrykriteria.fieldbyname('kd_kriteria').AsString;
                      FieldByName('nilai_k').AsString:=nilai_k;
                      FieldByName('kd_juri').AsString:=dm.qryjuri.fieldbyname('kd_juri').AsString;
                      Post;
                    end;
                 end;
              end;
              c:=c+1;
           end;

           //rata2 3 penilai
           with dm.qrytemp_nilai do
            begin
             close;
             SQL.Clear;
             SQL.Add('select * from tbl_temp_nilai where kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+'');
             sql.Add('and kd_kriteria='+QuotedStr(dm.qrykriteria.fieldbyname('kd_kriteria').AsString)+'');
             Open;
             nilai_3juri:=0;
             for e:=1 to RecordCount do
               begin
                 RecNo:=e;
                 nilai_3juri:=nilai_3juri+fieldbyname('nilai_k').AsVariant;
               end;
              e:=e+1;
              hasil_3juri := FloatToStr(Round(nilai_3juri/3));

              //ubah tmp_rata
              with dm.qrytmp_rata do
                begin
                  if Locate('kd_proses',dm.qryrangking.fieldbyname('kd_proses').AsString,[]) then
                   begin
                     Edit;
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-01' then FieldByName('KR_01').AsString := hasil_3juri else
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-02' then FieldByName('KR_02').AsString := hasil_3juri else
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-03' then FieldByName('KR_03').AsString := hasil_3juri else
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-04' then FieldByName('KR_04').AsString := hasil_3juri else
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-05' then FieldByName('KR_05').AsString := hasil_3juri else
                     if dm.qrykriteria.FieldByName('kd_kriteria').AsString='KR-06' then FieldByName('KR_06').AsString := hasil_3juri;
                     Post;
                   end;
                end;
            end;
        end;
      end;

    with dm.qrytemp_nilai do
     begin
      close;
      SQL.Clear;
      SQL.Text:='delete from tbl_temp_nilai';
      ExecSQL;

      close;
      SQL.Clear;
      SQL.Text:='select * from tbl_temp_nilai';
      Open;
     end;

    MessageDlg('Semua Penilaian Juri Sudah Diproses',mtInformation,[mbok],0);
    FormShow(Sender);
  end;
end;

procedure Tf_trans_penilaian.penilaian_mati;
begin
 edtk1_intonasi.Enabled:=false; edtk1_intonasi.Clear;
 edtk1_artikulasi.Enabled:=false; edtk1_artikulasi.Clear;

 edtk2_peng_naskah.Enabled:=false; edtk2_peng_naskah.Clear;
 edtk2_peng_watak.Enabled:=false; edtk2_peng_watak.Clear;

 edtk3_ekspresi.Enabled:=False; edtk3_ekspresi.Clear;
 edtk3_bahastubuh.Enabled:=false; edtk3_bahastubuh.Clear;

 edtk4_kekompakan.Enabled:=false; edtk4_kekompakan.Clear;
 edtk4_penguasaanpang.Enabled:=false; edtk4_penguasaanpang.Clear;

 edtk5_tatarias.Enabled:=false; edtk5_tatarias.Clear;
 edtk6_alur.Enabled:=false; edtk6_alur.Clear;
end;

procedure Tf_trans_penilaian.penilaian_hidup;
begin
 edtk1_intonasi.Enabled:=True; edtk1_intonasi.Clear;
 edtk1_artikulasi.Enabled:=True; edtk1_artikulasi.Clear;

 edtk2_peng_naskah.Enabled:=True; edtk2_peng_naskah.Clear;
 edtk2_peng_watak.Enabled:=True; edtk2_peng_watak.Clear;

 edtk3_ekspresi.Enabled:=True; edtk3_ekspresi.Clear;
 edtk3_bahastubuh.Enabled:=True; edtk3_bahastubuh.Clear;

 edtk4_kekompakan.Enabled:=True; edtk4_kekompakan.Clear;
 edtk4_penguasaanpang.Enabled:=True; edtk4_penguasaanpang.Clear;

 edtk5_tatarias.Enabled:=True; edtk5_tatarias.Clear;
 edtk6_alur.Enabled:=True; edtk6_alur.Clear;

end;

procedure Tf_trans_penilaian.penilaia_tidak_aktif;
begin
 edtk1_intonasi.Enabled:=false;
 edtk1_artikulasi.Enabled:=false;

 edtk2_peng_naskah.Enabled:=false;
 edtk2_peng_watak.Enabled:=false;

 edtk3_ekspresi.Enabled:=False;
 edtk3_bahastubuh.Enabled:=false;

 edtk4_kekompakan.Enabled:=false;
 edtk4_penguasaanpang.Enabled:=false;

 edtk5_tatarias.Enabled:=false;
 edtk6_alur.Enabled:=false;
end;

procedure Tf_trans_penilaian.btnubahClick(Sender: TObject);
begin
 btnbatal2.BringToFront; btnbatal2.Enabled:=True;
 btnsimpan.Caption:='Simpan'; btnsimpan.Enabled:=True;
 btnubah.Enabled:=false;
 penilaian_aktif;
 //cbbpenilai.Enabled:=false;
 dblkcbbjuri.Enabled:=false;
end;

procedure Tf_trans_penilaian.penilaian_aktif;
begin
 edtk1_intonasi.Enabled:=True;
 edtk1_artikulasi.Enabled:=True;

 edtk2_peng_naskah.Enabled:=True;
 edtk2_peng_watak.Enabled:=True;

 edtk3_ekspresi.Enabled:=True;
 edtk3_bahastubuh.Enabled:=True;

 edtk4_kekompakan.Enabled:=True;
 edtk4_penguasaanpang.Enabled:=True;

 edtk5_tatarias.Enabled:=True;
 edtk6_alur.Enabled:=True;
end;

procedure Tf_trans_penilaian.btnbatal2Click(Sender: TObject);
begin
 //cbbpenilai.Text:=''; cbbpenilai.Enabled:=True;
 dblkcbbjuri.KeyValue:=null; dblkcbbjuri.Enabled:=True;
 penilaian_mati;
 konek_kosong;

 btnbatal2.SendToBack;
 btncampur.Enabled:=True;
 btnsimpan.Enabled:=True;

 cek_semua_isi_nilai;
end;

procedure Tf_trans_penilaian.cek_semua_isi_nilai;
begin
  with dm.qrynilai do
   begin
    close;
    SQL.Clear;
    SQL.Text:='select * from tbl_nilai where kd_proses='+QuotedStr(kode_proses)+'';
    Open;
    ada := False;
    for a:=1 to RecordCount do
      begin
        RecNo:=a;
        if FieldByName('nilai').AsString='' then ada:=True;
      end;
      a:=a+1;
   end;
   if ada=False then btnsimpan.Caption:='Proses' else btnsimpan.Caption:='Simpan';
end;

procedure Tf_trans_penilaian.btnhapusClick(Sender: TObject);
begin
 if MessageDlg('Apakah Data Akan Dihapus?',mtConfirmation,[mbYes,mbNo],0)=mryes then
  begin
    with dm.qryrangking do
     begin
       close;
       SQL.Clear;
       SQL.Text:='delete from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+' and kd_teater='+QuotedStr(edtkdteater.Text)+'';
       ExecSQL;
     end;
     MessageDlg('Data Sudah Dihapus',mtInformation,[mbok],0);
     FormShow(Sender);
  end;
end;

procedure Tf_trans_penilaian.btnubah2Click(Sender: TObject);
begin
 btnbantu.Enabled:=false;
 edttahun.Enabled:=false;
 //cbbpenilai.Enabled:=True;
 dblkcbbjuri.Enabled:=True;

 btncampur.BringToFront; btncampur.Caption:='Batal'; btncampur.Enabled:=True;
 btnsimpan.Enabled:=false;
 btnubah2.Enabled:=false;
 btnhapus.Enabled:=false;

 //dbgrd2.SendToBack;
 grpsm_juri.SendToBack;
end;

procedure Tf_trans_penilaian.dblkcbbjuriCloseUp(Sender: TObject);
begin
 if dblkcbbjuri.KeyValue=null then
  begin
    penilaian_mati;
    Exit;
  end;
{ if cbbpenilai.Text='' then
  begin
    penilaian_mati;
    Exit;
  end;         }

 konek_nilai;

 with dm.qrynilai do
  begin
    close;
    SQL.Clear;
    SQL.Text:='select * from tbl_nilai where kd_proses='+QuotedStr(kode_proses)+' and kd_juri='+QuotedStr(dblkcbbjuri.KeyValue)+' order by kd_sub_kriteria asc';
    Open;
    ada:=False;
    for a:=1 to RecordCount do
     begin
       RecNo:=a;

       if FieldByName('nilai').AsString='' then ada:=True;
     end;
     a:=a+1;

    if ada=True then
     begin
       penilaian_hidup;

       btncampur.Enabled:=True;
       btnsimpan.Enabled:=True;
       btnubah.Enabled:=false;
       btnhapus.Enabled:=false;
       btnkeluar.Enabled:=false;
     end
    else
     begin
      MessageDlg(dblkcbbjuri.Text+' Sudah Melakukan Penilaian',mtInformation,[mbOK],0);
      for a:=1 to RecordCount do
       begin
         RecNo := a;

         nilai[a] := fieldbyname('nilai').AsInteger;
       end;
       a:=a+1;

       edtk1_intonasi.Text := IntToStr(nilai[1]);
       edtk1_artikulasi.Text := IntToStr(nilai[2]);
       edtk2_peng_naskah.Text := IntToStr(nilai[3]);
       edtk2_peng_watak.Text := IntToStr(nilai[4]);
       edtk3_ekspresi.Text := IntToStr(nilai[5]);
       edtk3_bahastubuh.Text := IntToStr(nilai[6]);
       edtk4_kekompakan.Text := IntToStr(nilai[7]);
       edtk4_penguasaanpang.Text := IntToStr(nilai[8]);
       edtk5_tatarias.Text := IntToStr(nilai[9]);
       edtk6_alur.Text := IntToStr(nilai[10]);

       penilaia_tidak_aktif;
       btncampur.Enabled:=False;
       btnbatal2.Enabled:=false;
       btnsimpan.Enabled:=false;
       btnubah.Enabled:=True; btnubah.BringToFront;
       btnhapus.Enabled:=false;
       btnkeluar.Enabled:=false;
     end;
  end;

  if btnsimpan.Caption='Proses' then btnsimpan.Enabled:=True;
end;

end.
