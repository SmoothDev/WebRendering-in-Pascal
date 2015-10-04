unit HTMLDocument;

interface

uses
  FMX.Graphics,
  FMX.Types,
  System.Types,
  System.Math,
  CSSMatrix,
  FMX.Forms,
  System.UITypes;

type
  IHTMLElement = class;

  THTMLHead = class;

  THTMLBody = class;

  THTMLDocument = class;

  THTMLElements = class
  protected
    FElements : array of IHTMLElement;
    function FGetElement(Index : integer) : IHTMLElement;
  public
    constructor Create;
    procedure Remove(Index : integer);
    procedure Add(AHTMLElement : IHTMLElement);
    property Elements[Index : integer] : IHTMLElement read FGetElement; default;
  end;

  IHTMLElement = class
  protected
    FParent : IHTMLElement;
    function FGetLeft : integer; virtual;
    function FGetTop : integer; virtual;
    function FGetRight : integer; virtual;
    function FGetBottom : integer; virtual;

    function FGetMarginLeft : integer; virtual;
    function FGetMarginTop : integer; virtual;
    function FGetMarginRight : integer; virtual;
    function FGetMarginBottom : integer; virtual;

    function FGetPaddingLeft : integer; virtual;
    function FGetPaddingTop : integer; virtual;
    function FGetPaddingRight : integer; virtual;
    function FGetPaddingBottom : integer; virtual;


    function FGetHeight : integer; virtual;
    function FGetWidth : integer; virtual;

    function FGetOffsetX : integer; virtual;
    function FGetOffsetY : integer; virtual;
  public
    Elements : THTMLElements;
    CSSMatrix : TCSSMatrix;
    constructor Create(AParent : IHTMLElement);
    function GetBody : THTMLBody;
    procedure SetCanvasProperties(ACanvas : TCanvas);
    function Draw(X,Y:Single; ACanvas : TCanvas) : TPointF; virtual; abstract;
    procedure DrawElements(X,Y:Single;ACanvas : TCanvas);

    property Parent : IHTMLElement read FParent write FParent;

    property Left : integer read FGetLeft;
    property Top : integer read FGetTop;
    property Right : integer read FGetRight;
    property Bottom : integer  read FGetBottom;

    property MarginLeft : integer read FGetMarginLeft;
    property MarginTop : integer read FGetMarginTop;
    property MarginRight : integer read FGetMarginRight;
    property MarginBottom : integer  read FGetMarginBottom;

    property PaddingLeft : integer read FGetPaddingLeft;
    property PaddingTop : integer read FGetPaddingTop;
    property PaddingRight : integer read FGetPaddingRight;
    property PaddingBottom : integer  read FGetPaddingBottom;

    property Height : integer read FGetHeight;
    property Width : integer read FGetWidth;

    property OffsetX : integer read FGetOffsetX;
    property OffsetY : integer read FGetOffsetY;
  end;

  THTMLTextElement = class(IHTMLElement)
  private
    function FGetHeight : integer; override;
    function FGetWidth : integer; override;
  public
    Text : string;
    function Draw(X,Y:Single; ACanvas : TCanvas): TPointF; override;
  end;

  IHTMLBaseContainer = class(IHTMLElement)
  private
  public
    constructor Create(AParent : IHTMLElement);
  end;

  THTMLBody = class(IHTMLBaseContainer)
  protected
    FDocument : THTMLDocument;
    function FGetHeight : integer; override;
    function FGetWidth : integer; override;
  public
    constructor Create(ADocument : THTMLDocument);
    function Draw(X,Y:Single; ACanvas : TCanvas) : TPointF; override;
    property Document : THTMLDocument read FDocument;
  end;

  THTMLHead = class

  end;

  THTMLDocument = class
  private
    function FGetHeight : integer;
    function FGetWidth : integer;
  public
    Head : THTMLHead;
    Body : THTMLBody;
    Frame : TFrame;
    property Height : integer read FGetHeight;
    property Width : integer read FGetWidth;
  end;

  function CSSLengthToPixel(ACSSLength : TCSSLength; RelativeTo : Single) : integer;

implementation

function CSSLengthToPixel(ACSSLength : TCSSLength; RelativeTo : Single) : integer;
begin
  case ACsSLength.LengthUnit of
    cluPX: Result := round(ACSSLength.Value);
    cluEM: ;
    cluPercent: Result := round(RelativeTo * ACSSLength.Value);
    cluAuto: ;
  end;
end;

{ THTMLElements }

procedure THTMLElements.Add(AHTMLElement: IHTMLElement);
begin
  SetLength(FElements, Length(FElements)+1);
  FElements[Length(FElements)-1] := AHTMLElement;
end;

constructor THTMLElements.Create;
begin
  SetLength(FElements, 0);
end;

function THTMLElements.FGetElement(Index: integer): IHTMLElement;
begin
  Result := FElements[Index];
end;

procedure THTMLElements.Remove(Index: integer);
var
  ALength: Cardinal;
  TailElements: Cardinal;
begin
  ALength := Length(FElements);
  Assert(ALength > 0);
  Assert(Index < ALength);
  Finalize(FElements[Index]);
  TailElements := ALength - Index;
  if TailElements > 0 then
    Move(FElements[Index + 1], FElements[Index], SizeOf(FElements) * TailElements);
  Initialize(FElements[ALength - 1]);
  SetLength(FElements, ALength - 1);
end;

{ THTMLTextElement }

function THTMLTextElement.Draw(X,Y:Single; ACanvas : TCanvas) : TPointF;
begin
  ACanvas.Fill.Color := CSSMatrix.FontColor.ToAlphaColor;
  ACanvas.Font.Family := CSSMatrix.FontFamily;
  ACanvas.Font.Size := CSSMatrix.FontSize.Value;

  ACanvas.Font.Style := [ TFontStyle.fsBold ];

  ACanvas.FillText(
    RectF(X+OffsetX,Y+OffsetY,X+OffsetX+ACanvas.TextWidth(Text),Y+OffsetY+ACanvas.TextHeight(Text)),
    Text,
    false,
    1,
    [],
    TTextAlign.Leading
  );

  Result.X := X + Width;
  Result.Y := Y;
end;

{ IHTMLBody }

constructor THTMLBody.Create(ADocument : THTMLDocument);
begin
  inherited Create(nil);
  FDocument := ADocument;
  CSSMatrix.Margin :=  CSSRectPX(8,8,8,8);
end;

function THTMLBody.Draw(X, Y: Single; ACanvas: TCanvas) : TPointF;
begin
  ACanvas.Fill.Color := CSSMatrix.BackgroundColor.ToAlphaColor;
  ACanvas.Font.Family := CSSMatrix.FontFamily;
  ACanvas.Font.Size := CSSMatrix.FontSize.Value;

  ACanvas.FillRect(
    RectF(X,Y,X+Width,Y+Height),
    0,0,
    AllCorners,
    1
  );

  DrawElements(X,Y,ACanvas);
end;

function THTMLBody.FGetHeight: integer;
begin
  Result := Round(FDocument.Height);
end;

function THTMLBody.FGetWidth: integer;
begin
  Result := Round(FDocument.Width);
end;

function THTMLTextElement.FGetHeight: integer;
begin

end;

function THTMLTextElement.FGetWidth: integer;
begin
  Result := round(GetBody.Document.Frame.Canvas.TextWidth(Text));
end;

{ IHTMLElement }

constructor IHTMLElement.Create(AParent : IHTMLElement);
begin
  Elements := THTMLElements.Create;
  CSSMatrix := DefaultMatrix();
  FParent := AParent;
end;

procedure IHTMLElement.DrawElements(X, Y: Single; ACanvas: TCanvas);
var
  c : integer;
  cursor : TPointF;
begin
  for c := 0 to Length(Elements.FElements)-1 do
  begin
    cursor := Elements.FElements[c].Draw(X+cursor.x,Y+cursor.y,ACanvas);
  end;
end;

function IHTMLElement.FGetMarginBottom: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Margin.Bottom, 0);
end;

function IHTMLElement.FGetMarginLeft: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Margin.Left, 0);
end;

function IHTMLElement.FGetMarginRight: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Margin.Right, 0);
end;

function IHTMLElement.FGetMarginTop: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Margin.Top, 0);
end;

function IHTMLElement.FGetOffsetX: integer;
begin
  case CSSMatrix.Position of
    cptAbsolute: Result := Left;
    cptFixed: Result := Left;
    cptRelative: if Assigned(Parent) then Result := Parent.MarginLeft + PaddingLeft else Result := PaddingLeft;
  end;
end;

function IHTMLElement.FGetOffsetY: integer;
begin
  case CSSMatrix.Position of
    cptAbsolute: Result := Top;
    cptFixed: Result := Top;
    cptRelative: if Assigned(Parent) then Result := Parent.MarginTop + PaddingTop else Result := PaddingTop;
  end;
end;

function IHTMLElement.FGetPaddingBottom: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Padding.Bottom, 0);
end;

function IHTMLElement.FGetPaddingLeft: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Padding.Left, 0);
end;

function IHTMLElement.FGetPaddingRight: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Padding.Right, 0);
end;

function IHTMLElement.FGetPaddingTop: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Padding.Top, 0);
end;

function IHTMLElement.FGetRight: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Right, 0);
end;

function IHTMLElement.FGetTop: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Left, 0);
end;

function IHTMLElement.FGetWidth: integer;
begin
end;

function IHTMLElement.FGetBottom: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Bottom, 0);
end;

function IHTMLElement.FGetHeight: integer;
begin

end;

function IHTMLElement.FGetLeft: integer;
begin
  Result := CSSLengthToPixel(CSSMatrix.Left, 0);
end;

function IHTMLElement.GetBody: THTMLBody;
begin
  if (self is THTMLBody) then
    Result := THTMLBody(self)
  else if (Parent = nil) then
    Result := nil
  else
    Result := Parent.GetBody;
end;

procedure IHTMLElement.SetCanvasProperties(ACanvas: TCanvas);
begin
  ACanvas.Font.Family := CSSMatrix.FontFamily;
end;

{ IHTMLBaseContainer }

constructor IHTMLBaseContainer.Create(AParent : IHTMLElement);
begin
  inherited Create(AParent);
end;

{ THTMLDocument }

function THTMLDocument.FGetHeight: integer;
begin
  Result := round(Frame.Height);
end;

function THTMLDocument.FGetWidth: integer;
begin
  Result := round(Frame.width);
end;

end.
