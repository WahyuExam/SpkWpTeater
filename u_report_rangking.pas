unit u_report_rangking;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, jpeg;

type
  Treport_rangking = class(TQuickRep)
    qrbndColumnHeaderBand1: TQRBand;
    qrlbl2: TQRLabel;
    QRShape2: TQRShape;
    qrlbl4: TQRLabel;
    QRShape3: TQRShape;
    qrlbl5: TQRLabel;
    qrbndDetailBand1: TQRBand;
    QRShape6: TQRShape;
    QRShape8: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    qrbndSummaryBand1: TQRBand;
    QRShape9: TQRShape;
    QRShape4: TQRShape;
    QRShape7: TQRShape;
    qrlbl6: TQRLabel;
    QRSysData1: TQRSysData;
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
    QRShape1: TQRShape;
    QRShape5: TQRShape;
    QRShape10: TQRShape;
    qrlbl3: TQRLabel;
    QRDBText1: TQRDBText;
  private

  public

  end;

var
  report_rangking: Treport_rangking;

implementation

uses
  u_dm;

{$R *.DFM}

end.
