unit HTMLParser;

interface

uses
  HTMLDocument;


  function ParseHTML(AHTMLString : string) : THTMLBody;

implementation

function ParseHTML(AHTMLString : string) : THTMLBody;
var
  LBody : THTMLBody;

  LBuffer : string;
  LCurrentChar : Char;
  LCurrentCharIndex : integer;
begin
  LBuffer := '';

  for LCurrentCharIndex := 1 to Length(AHTMLString) do
  begin
    LCurrentChar := AHTMLString[LCurrentCharIndex];

  end;
end;



end.
