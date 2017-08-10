unit u_bantu_teater;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, DBGrids, jpeg, ExtCtrls;

type
  Tf_bantu_teater = class(TForm)
    grp1: TGroupBox;
    Label1: TLabel;
    grp3: TGroupBox;
    dbgrd1: TDBGrid;
    grp4: TGroupBox;
    btncampur: TBitBtn;
    btnkeluar: TBitBtn;
    edt1: TEdit;
    img1: TImage;
    procedure btnkeluarClick(Sender: TObject);
    procedure btncampurClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_bantu_teater: Tf_bantu_teater;

implementation

uses
  u_penilaian, u_lapnilai, u_lappenilaian;

{$R *.dfm}

procedure Tf_bantu_teater.btnkeluarClick(Sender: TObject);
begin
 close;
end;

procedure Tf_bantu_teater.btncampurClick(Sender: TObject);
begin
 if edt1.Text='penilaian' then
  begin
   f_trans_penilaian.FormShow(Sender);
   f_trans_penilaian.edtkdteater.Text:=dbgrd1.Fields[0].AsString;
   f_trans_penilaian.edtnama.Text:=dbgrd1.Fields[1].AsString;
  end
  else
 if edt1.Text='hasilsv' then
  begin
    f_lapnilai.edtkode.Text:=dbgrd1.Fields[0].AsString;
    f_lapnilai.edtnama.Text:=dbgrd1.Fields[1].AsString;
  end
  else
 if edt1.Text='lap_nilai' then
  begin
    f_lap_penilaian.edtkode.Text:=dbgrd1.Fields[0].AsString;
    f_lap_penilaian.edtnama.Text:=dbgrd1.Fields[1].AsString;
  end;
  Close;
end;

end.
