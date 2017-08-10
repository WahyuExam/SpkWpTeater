unit u_hasil_sv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, jpeg, ExtCtrls;

type
  Tf_trans_nilasv = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp3: TGroupBox;
    grp11: TGroupBox;
    btnkeluar: TBitBtn;
    Label2: TLabel;
    edttahun: TEdit;
    dbgrd1: TDBGrid;
    grp2: TGroupBox;
    dbgrd2: TDBGrid;
    btnbersih: TBitBtn;
    btnproses: TBitBtn;
    img1: TImage;
    Label3: TLabel;
    edt1: TEdit;
    procedure btnkeluarClick(Sender: TObject);
    procedure edttahunKeyPress(Sender: TObject; var Key: Char);
    procedure btnprosesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edttahunChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure konek;
  end;

var
  f_trans_nilasv: Tf_trans_nilasv;
  a, b, c, d, e, jml_sub : Byte;
  nilai_kriteria, nilai_3juri, hasil_s, total_s, hasil_v : Real;
  nilai_k, hasil_3juri : string;
  nilai_s : array[1..6] of real;
  nilai_v : array[1..6] of real;

implementation

uses
  u_dm, ADODB, DB, Math, u_trans_wp;

{$R *.dfm}

procedure Tf_trans_nilasv.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_trans_nilasv.edttahunKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in ['0'..'9',#13,#8,#9]) then Key:=#0;
end;

procedure Tf_trans_nilasv.btnprosesClick(Sender: TObject);
begin
 if Trim(edttahun.Text)='' then
  begin
    MessageDlg('Tahun Belum Diisi',mtWarning,[mbok],0);
    edttahun.SetFocus;
    Exit;
  end;

 with dm.qryrangking do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='select * from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+'';
    Open;
    if IsEmpty then
     begin
       MessageDlg('Data Penilaian Pada Tahun ini Tidak Ada',mtInformation,[mbok],0);
       edttahun.SetFocus;
       Exit;
     end
     else
     begin
       //menyimpan data ke dalam table proses
       with dm.qryrangking do
        begin
          close;
          SQL.Clear;
          SQL.Text:='select * from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+' order by kd_proses asc';
          Open;

          total_s:=0;
          for a:=1 to RecordCount do
           begin
             RecNo:=a;

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
                        //   d:=d+1;

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
                    //   c:=c+1;
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
                      //  e:=e+1;
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

                        with dm.qryproses do
                         begin
                          close;
                          SQL.Clear;
                          sql.Text:='select * from tbl_proses';
                          Open;

                          if Locate('kd_proses;kd_kriteria',VarArrayOf([dm.qryrangking.FieldByName('kd_proses').AsString,dm.qrykriteria.FieldByName('kd_kriteria').AsString]),[]) then Edit else Append;

                          FieldByName('kd_proses').AsString := dm.qryrangking.fieldbyname('kd_proses').AsString;
                          FieldByName('kd_kriteria').AsString:= dm.qrykriteria.fieldbyname('kd_kriteria').AsString;
                          FieldByName('nilai').AsString:=hasil_3juri;
                          Post;
                         end;
                     end;
                 end;
               //  b:=b+1;
              end;

              //proses wp
              with dm.qryproses do
               begin
                 Close;
                 SQL.Clear;
                 SQL.Text:='select * from tbl_proses where kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+'';
                 Open;
                 hasil_s:=1;
                 for b:=1 to RecordCount do
                  begin
                    RecNo:=b;

                    with dm.qrybobot do
                     begin
                       Close;
                       SQL.Clear;
                       SQL.Text:='select * from tbl_bobot where kd_kriteria='+QuotedStr(dm.qryproses.fieldbyname('kd_kriteria').AsString)+'';
                       Open;

                       nilai_s[b] := Power(dm.qryproses.fieldbyname('nilai').AsVariant,(fieldbyname('bobot').AsVariant/100));
                       //nilai_s[b] := FormatFloat('0.#####',Power(dm.qryproses.fieldbyname('nilai').AsVariant,(fieldbyname('bobot').AsVariant/100)));
                       hasil_s:=hasil_s*nilai_s[b];
                       //hasil_s:=hasil_s*StrToFloat(nilai_s[b]);
                     end;
                  end;
                 // b:=b+1;

                  //simpan hasil s
                  with dm.qrynilai_s do
                   begin
                     close;
                     SQL.Clear;
                     SQL.Text:='select * from tbl_hasil_s where kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+'';
                     Open;
                     if IsEmpty then Append else Edit;
                     FieldByName('kd_proses').AsString:=dm.qryrangking.fieldbyname('kd_proses').AsString;
                     FieldByName('hasil_s').AsString:=FormatFloat('0.#####',hasil_s);
                     Post;
                   end;
               end;

               //hasil v
               nilai_v[a]:=hasil_s;;
               //nilai_v[a]:=FormatFloat('0.#####',hasil_s);
               total_s:=total_s+nilai_v[a];
               //total_s:=total_s+StrToFloat(nilai_v[a]);
           end;
        //   a:=a+1;

           with dm.qryrangking do
            begin
              Close;
              SQL.Clear;
              SQL.Text:='select * from tbl_rangking where tahun='+QuotedStr(edttahun.Text)+' order by kd_proses asc';
              Open;
              for a:=1 to RecordCount do
               begin
                 RecNo:=a;

                 with dm.qrynilai_v do
                  begin
                    close;
                    SQL.Clear;
                    SQL.Text:='select * from tbl_hasil_v where kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+'';
                    Open;
                    if IsEmpty then Append else Edit;

                    FieldByName('kd_proses').AsString:=dm.qryrangking.fieldbyname('kd_proses').AsString;
                    FieldByName('hasil_v').AsString:=FormatFloat('#.#####',nilai_v[a]/total_s);
                    //FieldByName('hasil_v').AsString:=FormatFloat('#.#####',StrToFloat(nilai_v[a])/total_s);
                    Post;
                  end;

                 Edit;
                 FieldByName('hasil_wp').AsString:=FormatFloat('#.#####',nilai_v[a]/total_s);
                 //FieldByName('hasil_wp').AsString:=FormatFloat('#.#####',StrToFloat(nilai_v[a])/total_s);
                 Post;

                 //tambahan again
                 with dm.qrynilai_s do
                  begin
                    close;
                    SQL.Clear;
                    SQL.Text:='select * from tbl_hasil_s where kd_proses='+QuotedStr(dm.qryrangking.fieldbyname('kd_proses').AsString)+'';
                    Open;
                    for b:=1 to RecordCount do
                     begin
                       RecNo:=b;

                       with dm.qryrangking do
                        begin
                         if Locate('kd_proses',dm.qrynilai_s.fieldbyname('kd_proses').AsString,[]) then Edit;
                         FieldByName('nil_s').AsString := FormatFloat('#.#####',dm.qrynilai_s.fieldbyname('hasil_s').AsVariant)+' / '+FormatFloat('#.####',total_s);
                         Post;
                        end;
                     end;
                  end;
               end;
          //     a:=a+1;
            end;
        end;
        edt1.Text:=FormatFloat('#.#####',total_s);

        //hapus tbl_temp_nilai
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

         //tampil tbl_hasil_s/v
         konek;
       {  with dm.qrytmp_nil do
          begin
            close;
            sql.Clear;
            SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, c.kr_01, c.kr_02, c.kr_03, c.kr_04, c.kr_05,');
            SQL.add('c.kr_06, d.hasil_s from tbl_rangking a, tbl_peserta b, tbl_tmp_rata c, tbl_hasil_s d where a.kd_teater=b.kd_teater');
            sql.Add('and c.kd_proses=a.kd_proses and d.kd_proses=a.kd_proses and a.tahun='+QuotedStr(edttahun.Text)+'');
            Open;
          end;
         with dm.qrytampil_nilai_s do
          begin
            DisableControls;
            close;
            SQL.Clear;
            SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.hasil_s from tbl_rangking a, tbl_peserta b, tbl_hasil_s c');
            sql.Add('where a.kd_teater=b.kd_teater and c.kd_proses=a.kd_proses and a.tahun='+QuotedStr(edttahun.Text)+'');
            Open;
            EnableControls
          end;

         with dm.qrytampil_nilai_v do
          begin
            DisableControls;
            close;
            SQL.Clear;
            SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.hasil_v from tbl_rangking a, tbl_peserta b, tbl_hasil_v c');
            sql.Add('where a.kd_teater=b.kd_teater and c.kd_proses=a.kd_proses and a.tahun='+QuotedStr(edttahun.Text)+'');
            Open;
            EnableControls;
          end;     }

         MessageDlg('Proses Perhitungan Selesai',mtInformation,[mbok],0);
         edttahun.Enabled:=True;
         btnproses.Enabled:=false;
         btnbersih.Enabled:=True;
         btnkeluar.Enabled:=True;
     end;
  end;
end;

procedure Tf_trans_nilasv.FormShow(Sender: TObject);
begin
 edttahun.Text:=FormatDateTime('yyyy',Now);
 edttahun.Enabled:=True;
 edttahun.SetFocus;
 edt1.Clear; edt1.Enabled:=False;

 with dm.qrytmp_nil do
  begin
   close;
   sql.Clear;
   SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, c.kr_01, c.kr_02, c.kr_03, c.kr_04, c.kr_05,');
   SQL.add('c.kr_06, d.hasil_s from tbl_rangking a, tbl_peserta b, tbl_tmp_rata c, tbl_hasil_s d where a.kd_teater=b.kd_teater');
   sql.Add('and c.kd_proses=a.kd_proses and d.kd_proses=a.kd_proses and a.tahun='+QuotedStr('kosong')+'');
   Open;
  end;

 {with dm.qrytampil_nilai_s do
   begin
     DisableControls;
     close;
     SQL.Clear;
     SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.hasil_s from tbl_rangking a, tbl_peserta b, tbl_hasil_s c');
     sql.Add('where a.kd_teater=b.kd_teater and c.kd_proses=a.kd_proses and a.tahun='+QuotedStr('kosong')+'');
     Open;
     EnableControls;
   end;

 with dm.qrytampil_nilai_v do
  begin
    DisableControls;
    close;
    SQL.Clear;
    SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.hasil_v from tbl_rangking a, tbl_peserta b, tbl_hasil_v c');
    sql.Add('where a.kd_teater=b.kd_teater and c.kd_proses=a.kd_proses and a.tahun='+QuotedStr('kosong')+'');
    Open;
    EnableControls;
  end;                                             }

  btnproses.Enabled:=True;
  btnbersih.Enabled:=False;
  btnkeluar.Enabled:=True;

  for a:=1 to 6 do
   begin
     nilai_s[a]:=0;
     nilai_v[a]:=0;
   end;
end;

procedure Tf_trans_nilasv.konek;
begin
 with dm.qrytmp_nil do
  begin
   close;
   sql.Clear;
   SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, c.kr_01, c.kr_02, c.kr_03, c.kr_04, c.kr_05,');
   SQL.add('c.kr_06, d.hasil_s from tbl_rangking a, tbl_peserta b, tbl_tmp_rata c, tbl_hasil_s d where a.kd_teater=b.kd_teater');
   sql.Add('and c.kd_proses=a.kd_proses and d.kd_proses=a.kd_proses and a.tahun='+QuotedStr(edttahun.Text)+'');
   Open;
  end;
end;

procedure Tf_trans_nilasv.edttahunChange(Sender: TObject);
begin
  with dm.qrytmp_nil do
  begin
   close;
   sql.Clear;
   SQL.Add('select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.telp, b.alamat, c.kr_01, c.kr_02, c.kr_03, c.kr_04, c.kr_05,');
   SQL.add('c.kr_06, d.hasil_s from tbl_rangking a, tbl_peserta b, tbl_tmp_rata c, tbl_hasil_s d where a.kd_teater=b.kd_teater');
   sql.Add('and c.kd_proses=a.kd_proses and d.kd_proses=a.kd_proses and a.tahun='+QuotedStr('kosong')+'');
   Open;
  end;
  btnproses.Enabled:=True;
end;

end.
