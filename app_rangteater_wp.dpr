program app_rangteater_wp;

uses
  Forms,
  u_menuutama in 'u_menuutama.pas' {f_menuutama},
  u_dm in 'u_dm.pas' {dm: TDataModule},
  u_bobot in 'u_bobot.pas' {f_mast_bobot},
  u_teater in 'u_teater.pas' {f_mast_teater},
  u_penilaian in 'u_penilaian.pas' {f_trans_penilaian},
  u_bantu_teater in 'u_bantu_teater.pas' {f_bantu_teater},
  u_hasil_sv in 'u_hasil_sv.pas' {f_trans_nilasv},
  u_trans_wp in 'u_trans_wp.pas' {f_trans_perangkiganwp},
  u_peng_login in 'u_peng_login.pas' {f_peng_gantisandi},
  u_peng_jawab in 'u_peng_jawab.pas' {f_peng_penanggungjawab},
  u_peng_salindata in 'u_peng_salindata.pas' {f_peng_salindata},
  u_report_peserta in 'u_report_peserta.pas' {report_peserta: TQuickRep},
  u_lapnilai in 'u_lapnilai.pas' {f_lapnilai},
  u_report_hasilsv in 'u_report_hasilsv.pas' {report_hasilsv: TQuickRep},
  u_laprangking in 'u_laprangking.pas' {f_laprangking},
  u_report_rangking in 'u_report_rangking.pas' {report_rangking: TQuickRep},
  u_lappenilaian in 'u_lappenilaian.pas' {f_lap_penilaian},
  u_report_penilaian in 'u_report_penilaian.pas' {report_penilaian: TQuickRep},
  u_mast_juri in 'u_mast_juri.pas' {f_maste_juri},
  u_report_juri in 'u_report_juri.pas' {report_juri: TQuickRep},
  u_login in 'u_login.pas' {f_login};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(Tf_login, f_login);
  Application.CreateForm(Tf_menuutama, f_menuutama);
  Application.CreateForm(Tf_trans_penilaian, f_trans_penilaian);
  Application.CreateForm(Tf_mast_bobot, f_mast_bobot);
  Application.CreateForm(Tf_mast_teater, f_mast_teater);
  Application.CreateForm(Tf_bantu_teater, f_bantu_teater);
  Application.CreateForm(Tf_trans_nilasv, f_trans_nilasv);
  Application.CreateForm(Tf_trans_perangkiganwp, f_trans_perangkiganwp);
  Application.CreateForm(Tf_peng_gantisandi, f_peng_gantisandi);
  Application.CreateForm(Tf_peng_penanggungjawab, f_peng_penanggungjawab);
  Application.CreateForm(Tf_peng_salindata, f_peng_salindata);
  Application.CreateForm(Tf_lapnilai, f_lapnilai);
  Application.CreateForm(Tf_laprangking, f_laprangking);
  Application.CreateForm(Tf_maste_juri, f_maste_juri);
  Application.CreateForm(Tf_lap_penilaian, f_lap_penilaian);
  Application.CreateForm(Treport_rangking, report_rangking);
  Application.CreateForm(Treport_penilaian, report_penilaian);
  Application.CreateForm(Treport_hasilsv, report_hasilsv);
  Application.CreateForm(Treport_juri, report_juri);
  Application.CreateForm(Treport_peserta, report_peserta);
  Application.Run;
end.
