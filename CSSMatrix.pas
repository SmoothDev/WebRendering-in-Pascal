unit CSSMatrix;

interface

uses
  System.Types,
  System.UITypes;

type
  TCSSPositionType = (
    cptAbsolute,
    cptFixed,
    cptRelative
  );

  TCSSLengthUnit = (
    cluPX,
    cluEM,
    cluPercent,
    cluAuto
  );

  TCSSLength = record
    Value : Single;
    LengthUnit : TCSSLengthUnit;
  end;

  TCSSRect = record
    Top, Left, Bottom, Right : TCSSLength;
  end;

  TCSSColor = record
    R,G,B,A : byte;
    function ToAlphaColor : TAlphaColor;
  end;

  TCSSTextDecoration = (
    ctdBold,
    ctdNone
  );

  TCSSMatrix = record
    { Positionen, Abstände und Grössen }
    Height : TCSSLength;
    Width : TCSSLength;

    Margin : TCSSRect;
    Padding : TCSSRect;

    Position : TCSSPositionType; // [TYPE] Absolute | Relative | Fixed...

    // Absolute Distanzen
    Top, Left, Bottom, Right : TCSSLength;

    // Färbungen
    BackgroundColor : TCSSColor;

    // Schrift
    FontFamily : string;
    FontSize : TCSSLength;
    FontColor : TCSSColor;

  end;



  { CSSLength }
  function CSSLength(AValue : Single; ALengthUnit : TCSSLengthUnit) : TCSSLength;
  function CSSLengthPX(AValue : integer) : TCSSLength;
  function CSSLengthEM(AValue : double) : TCSSLength;
  function CSSLengthPercent(AValue : double) : TCSSLength;

  { CSSRect }
  function CSSRect(Top, Left, Bottom, Right : TCSSLength) : TCSSRect;
  function CSSRectPX(Top, Left, Bottom, Right : integer) : TCSSRect;
  function CSSRectEM(Top, Left, Bottom, Right : single) : TCSSRect;
  function CSSRectPercent(Top, Left, Bottom, Right : single) : TCSSRect;

  { CSSColor }
  function CSSColor(R,G,B,A:byte) : TCSSColor;

  { CSSMatrix }
  function DefaultMatrix : TCSSMatrix;

implementation

function CSSLength(AValue : Single; ALengthUnit : TCSSLengthUnit) : TCSSLength;
begin
  Result.Value := AValue;
  Result.LengthUnit := ALengthUnit;
end;

function CSSLengthPX(AValue : integer) : TCSSLength;
begin
  Result := CSSLength(AValue, cluPx);
end;

function CSSLengthEM(AValue : double) : TCSSLength;
begin
  Result := CSSLength(AValue, cluEM);
end;

function CSSLengthPercent(AValue : double) : TCSSLength;
begin
  Result := CSSLength(AValue, cluPercent);
end;


function CSSRect(Top, Left, Bottom, Right : TCSSLength) : TCSSRect;
begin
  Result.Top := Top;
  Result.Left := Left;
  Result.Bottom := Bottom;
  Result.Right := Right;
end;

function CSSRectPX(Top, Left, Bottom, Right : integer) : TCSSRect;
begin
  Result.Top := CSSLengthPX(Top);
  Result.Left := CSSLengthPX(Left);
  Result.Bottom := CSSLengthPX(Bottom);
  Result.Right := CSSLengthPX(Right);
end;

function CSSRectEM(Top, Left, Bottom, Right : single) : TCSSRect;
begin
  Result.Top := CSSLengthEM(Top);
  Result.Left := CSSLengthEM(Left);
  Result.Bottom := CSSLengthEM(Bottom);
  Result.Right := CSSLengthEM(Right);
end;

function CSSRectPercent(Top, Left, Bottom, Right : single) : TCSSRect;
begin
  Result.Top := CSSLengthPercent(Top);
  Result.Left := CSSLengthPercent(Left);
  Result.Bottom := CSSLengthPercent(Bottom);
  Result.Right := CSSLengthPercent(Right);
end;


function DefaultMatrix : TCSSMatrix;
begin
  Result.Height := CSSLength(10,cluPX);
  Result.Width := CSSLength(0,cluAuto);

  Result.Margin := CSSRectPX(0,0,0,0);
  Result.Padding := CSSRectPX(0,0,0,0);

  Result.Position := cptRelative;

  Result.FontFamily := 'Times New Roman';
  Result.FontColor := CSSColor(0,0,0,255);
  Result.FontSize := CSSLength(16,cluPX);

  Result.BackgroundColor := CSSColor(255,255,255,255);
end;

function CSSColor(R,G,B,A:byte) : TCSSColor;
begin
  Result.R := R;
  Result.G := G;
  Result.B := B;
  Result.A := A;
end;

{ TCSSColor }

function TCSSColor.ToAlphaColor: TAlphaColor;
var
  LColor : TAlphaColorRec;
begin
  LColor.R := R;
  LColor.G := G;
  LColor.B := B;
  LColor.A := A;
  Result := TAlphaColor(LColor);
end;

end.