unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, lHTMLLayer,
  HTMLDocument, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Menus,
  FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo1: TMemo;
    StyleBook1: TStyleBook;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    HTMLLayer : THTMLLayer;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  HTMLTextElement : THTMLTextElement;
begin
  HTMLTextElement := THTMLTextElement.Create(HTMLLayer.Document.Body);
  HTMLTextElement.Text := 'testtest';
  HTMLLayer.Document.Body.Elements.Add(HTMLTextElement);
  Invalidate;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  showmessage(HTMLLayer.Document.Body.Elements[0].Left.ToString);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  HTMLLayer := THTMLLayer.Create(self);
  HTMLLayer.Parent := Panel3;
  HTMLLayer.Document.Frame := HTMLLayer;
end;

end.
