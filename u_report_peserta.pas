unit u_report_peserta;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, QuickRpt, QRCtrls, jpeg;

type
  Treport_peserta = class(TQuickRep)
    qrbndColumnHeaderBand1: TQRBand;
    qrbndDetailBand1: TQRBand;
    qrlbl2: TQRLabel;
    qrbndSummaryBand1: TQRBand;
    QRShape1: TQRShape;
    QRShape2: TQRShape;
    qrlbl4: TQRLabel;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    qrlbl3: TQRLabel;
    qrlbl5: TQRLabel;
    qrlbl6: TQRLabel;
    QRShape5: TQRShape;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRShape8: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
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
    QRSysData1: TQRSysData;
  private

  public

  end;

var
  report_peserta: Treport_peserta;

implementation

uses
  u_dm;

{$R *.DFM}

end.
