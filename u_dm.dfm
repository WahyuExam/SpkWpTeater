object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 320
  Top = 208
  Height = 484
  Width = 727
  object con1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=dbwp.mdb;Persist Se' +
      'curity Info=False'
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 24
    Top = 16
  end
  object qrykriteria: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_kriteria')
    Left = 24
    Top = 72
  end
  object qrysubkriteria: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_sub_kriteria')
    Left = 88
    Top = 72
  end
  object qrybobot: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_bobot')
    Left = 152
    Top = 72
  end
  object qrypeserta: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_peserta')
    Left = 208
    Top = 72
  end
  object qryjuri: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_juri')
    Left = 264
    Top = 72
  end
  object tblpengguna: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 'tbl_login'
    Left = 72
    Top = 16
  end
  object qrytampil_bobot: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_bobot, b.kd_kriteria, b.kriteria, a.bobot from tbl_b' +
        'obot a, tbl_kriteria b where a.kd_kriteria=b.kd_kriteria')
    Left = 152
    Top = 128
  end
  object dstampil_bobot: TDataSource
    DataSet = qrytampil_bobot
    Left = 152
    Top = 184
  end
  object XPManifest1: TXPManifest
    Left = 128
    Top = 16
  end
  object dspesera: TDataSource
    DataSet = qrypeserta
    Left = 216
    Top = 128
  end
  object qryrangking: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_rangking')
    Left = 368
    Top = 80
  end
  object qryproses: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_proses')
    Left = 440
    Top = 80
  end
  object qrynilai: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_nilai')
    Left = 488
    Top = 80
  end
  object qrynilai_s: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_hasil_s')
    Left = 536
    Top = 80
  end
  object qrynilai_v: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_hasil_v')
    Left = 592
    Top = 80
  end
  object qrytampil_nilai: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_proses, b.kd_sub_kriteria, b.sub_kriteria, a.nilai, ' +
        'd.kd_juri, d.nm_juri, d.jabatan, c.kd_kriteria, c.kriteria from '
      
        'tbl_nilai a, tbl_sub_kriteria b, tbl_kriteria c, tbl_juri d wher' +
        'e a.kd_sub_kriteria=b.kd_sub_kriteria and b.kd_kriteria=c.kd_kri' +
        'teria and a.kd_juri=d.kd_juri')
    Left = 488
    Top = 136
  end
  object dstampil_nilai: TDataSource
    DataSet = qrytampil_nilai
    Left = 488
    Top = 192
  end
  object qrytampil_nilai_s: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.ha' +
        'sil_s from tbl_rangking a, tbl_peserta b, tbl_hasil_s c where a.' +
        'kd_teater=b.kd_teater and c.kd_proses=a.kd_proses')
    Left = 544
    Top = 152
  end
  object dstampil_nilai_s: TDataSource
    DataSet = qrytampil_nilai_s
    Left = 552
    Top = 208
  end
  object qrytampil_nilai_v: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, c.ha' +
        'sil_v from tbl_rangking a, tbl_peserta b, tbl_hasil_v c where a.' +
        'kd_teater=b.kd_teater and c.kd_proses=a.kd_proses')
    Left = 608
    Top = 136
  end
  object dstampil_nilai_v: TDataSource
    DataSet = qrytampil_nilai_v
    Left = 616
    Top = 192
  end
  object qrytemp_nilai: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_temp_nilai')
    Left = 656
    Top = 80
  end
  object qrytampil_rangking: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.te' +
        'lp, b.alamat, a.nil_s, a.hasil_wp, a.juara from tbl_rangking a, ' +
        'tbl_peserta b where a.kd_teater=b.kd_teater')
    Left = 368
    Top = 136
  end
  object dstampil_rangking: TDataSource
    DataSet = qrytampil_rangking
    Left = 384
    Top = 192
  end
  object tblpenanggungjawab: TADOTable
    Active = True
    Connection = con1
    CursorType = ctStatic
    TableName = 'tbl_jawab'
    Left = 208
    Top = 24
  end
  object dsjuri: TDataSource
    DataSet = qryjuri
    Left = 280
    Top = 128
  end
  object qrytmp_rata: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select * from tbl_tmp_rata')
    Left = 112
    Top = 328
  end
  object qrytampil_tmp_rata: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select c.kd_proses, c.tahun, b.kd_teater, b.nm_grub_teater, a.kr' +
        '_01, a.kr_02, a.kr_03, a.kr_04, a.kr_05, a.kr_06 from tbl_rangki' +
        'ng c, tbl_peserta b, tbl_tmp_rata a where c.kd_teater = b.kd_tea' +
        'ter and a.kd_proses = c.kd_proses  ')
    Left = 168
    Top = 352
  end
  object dstampil_tmp_rata: TDataSource
    DataSet = qrytampil_tmp_rata
    Left = 216
    Top = 328
  end
  object qrytmp_nil: TADOQuery
    Active = True
    Connection = con1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        'select a.kd_proses, a.tahun, b.kd_teater, b.nm_grub_teater, b.te' +
        'lp, b.alamat, c.kr_01, c.kr_02, c.kr_03, c.kr_04, c.kr_05, c.kr_' +
        '06, d.hasil_s from tbl_rangking a, tbl_peserta b, tbl_tmp_rata c' +
        ', tbl_hasil_s d where a.kd_teater=b.kd_teater and c.kd_proses=a.' +
        'kd_proses and d.kd_proses=a.kd_proses')
    Left = 400
    Top = 336
  end
  object dstmp_nil: TDataSource
    DataSet = qrytmp_nil
    Left = 472
    Top = 360
  end
end
