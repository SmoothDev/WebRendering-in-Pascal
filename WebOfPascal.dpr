program WebOfPascal;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Styles,
  MainForm in 'MainForm.pas' {Form1},
  lHTMLLayer in 'lHTMLLayer.pas' {HTMLLayer: TFrame},
  HTMLDocument in 'HTMLDocument.pas',
  CSSMatrix in 'CSSMatrix.pas',
  HTMLParser in 'HTMLParser.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
