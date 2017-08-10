unit u_report_hasilsv;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB, jpeg;

type
  Treport_hasilsv = class(TQuickRep)
    QRGroup1: TQRGroup;
    QRShape1: TQRShape;
    qrlbl3: TQRLabel;
    QRShape2: TQRShape;
    qrlbl4: TQRLabel;
    QRShape3: TQRShape;
    qrlbl5: TQRLabel;
    qrylaphasilsv: TADOQuery;
    qrbndTitleBand2: TQRBand;
    qrlbl1: TQRLabel;
    qrlbl2: TQRLabel;
    qrbndDetailBand1: TQRBand;
    qrbndSummaryBand1: TQRBand;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    qrlbl8: TQRLabel;
    qrlbl13: TQRLabel;
    qrlbl15: TQRLabel;
    QRDBText4: TQRDBText;
    qrbnd1: TQRBand;
    QRShape9: TQRShape;
    qrlbl7: TQRLabel;
    qrlbl9: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText5: TQRDBText;
    qrlblbulan: TQRLabel;
    qrlbl10: TQRLabel;
    qrlbl18: TQRLabel;
    qrlbl19: TQRLabel;
    qrlbl20: TQRLabel;
    QRImage1: TQRImage;
    QRShape7: TQRShape;
    qrlbl21: TQRLabel;
    qrlbl22: TQRLabel;
    qrlbl11: TQRLabel;
    qrlbl6: TQRLabel;
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qrbndDetailBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure qrbnd1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QRGroup1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
  private

  public
    total, nom : Integer;

  end;

var
  report_hasilsv: Treport_hasilsv;

implementation

uses
  u_dm;

{$R *.DFM}

procedure Treport_hasilsv.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
 total := 0;
end;

procedure Treport_hasilsv.qrbndDetailBand1BeforePrint(
  Sender: TQRCustomBand; var PrintBand: Boolean);
begin
 total := total + qrylaphasilsv.fieldbyname('nilai').AsInteger;
 nom := nom+1;
 qrlbl6.Caption:=IntToStr(nom);
end;

procedure Treport_hasilsv.qrbnd1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
 qrlbl11.Caption:=IntToStr(total);
end;

procedure Treport_hasilsv.QRGroup1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
 nom := 0;
 total:=0;
end;

end.
