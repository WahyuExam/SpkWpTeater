unit u_report_juri;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, jpeg;

type
  Treport_juri = class(TQuickRep)
    qrbndColumnHeaderBand1: TQRBand;
    qrlbl2: TQRLabel;
    QRShape2: TQRShape;
    qrlbl4: TQRLabel;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    qrlbl5: TQRLabel;
    qrlbl6: TQRLabel;
    qrbndDetailBand1: TQRBand;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    qrbndSummaryBand1: TQRBand;
    QRShape9: TQRShape;
    qrlbl7: TQRLabel;
    qrlbl9: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText5: TQRDBText;
    qrlblbulan: TQRLabel;
    qrbndTitleBand2: TQRBand;
    qrlbl1: TQRLabel;
    qrlbl10: TQRLabel;
    qrlbl18: TQRLabel;
    qrlbl19: TQRLabel;
    qrlbl20: TQRLabel;
    QRImage1: TQRImage;
    QRShape10: TQRShape;
    QRShape1: TQRShape;
    qrlbl3: TQRLabel;
    QRShape5: TQRShape;
    QRSysData1: TQRSysData;
  private

  public

  end;

var
  report_juri: Treport_juri;

implementation

uses
  u_dm;

{$R *.DFM}

end.
