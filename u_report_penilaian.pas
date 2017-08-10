unit u_report_penilaian;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, DB, ADODB, jpeg;

type
  Treport_penilaian = class(TQuickRep)
    QRGroup1: TQRGroup;
    qrlbl8: TQRLabel;
    qrlbl13: TQRLabel;
    qrlbl15: TQRLabel;
    QRDBText4: TQRDBText;
    qrbndDetailBand1: TQRBand;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    qrbndSummaryBand1: TQRBand;
    qrlbl7: TQRLabel;
    qrlblbulan: TQRLabel;
    qrlbl9: TQRLabel;
    QRDBText5: TQRDBText;
    qrbnd1: TQRBand;
    QRShape9: TQRShape;
    qrylaporan_penilaian: TADOQuery;
    QRGroup2: TQRGroup;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    qrlbl4: TQRLabel;
    qrlbl5: TQRLabel;
    qrlbl11: TQRLabel;
    QRDBText8: TQRDBText;
    qrlbl3: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText6: TQRDBText;
    qrbndTitleBand2: TQRBand;
    qrlbl1: TQRLabel;
    qrlbl2: TQRLabel;
    qrlbl10: TQRLabel;
    qrlbl18: TQRLabel;
    qrlbl19: TQRLabel;
    qrlbl20: TQRLabel;
    QRImage1: TQRImage;
    QRShape7: TQRShape;
  private

  public

  end;

var
  report_penilaian: Treport_penilaian;

implementation

uses
  u_dm;

{$R *.DFM}

end.
