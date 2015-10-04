unit lHTMLLayer;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  HTMLDocument, FMX.Controls.Presentation;

type
  THTMLLayer = class(TFrame)
    procedure FramePaint(Sender: TObject; Canvas: TCanvas;
      const [Ref] ARect: TRectF);
  private
    { Private-Deklarationen }
    FHTMLDocument : THTMLDocument;
  public
    { Public-Deklarationen }
    constructor Create(AOwner : TComponent);
    property Document : THTMLDocument read FHTMLDocument;

  end;

implementation

{$R *.fmx}

{ THTMLLayer }

constructor THTMLLayer.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FHTMLDocument := THTMLDocument.Create;
  Document.Body := THTMLBody.Create(Document);
end;

procedure THTMLLayer.FramePaint(Sender: TObject; Canvas: TCanvas;
  const [Ref] ARect: TRectF);
begin
  if Assigned(Document.Body) then
    Document.Body.Draw(0,0,Canvas);
end;

end.
