unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm4 }

  TForm4 = class(TForm)
    ButtonExecutar: TButton;
    EditRotacaoGraus: TEdit;
    Label11: TLabel;
    Label3: TLabel;
    RadioButtonEixoX: TRadioButton;
    RadioButtonEixoY: TRadioButton;
    RadioButtonEixoZ: TRadioButton;
    RadioGroup2: TRadioGroup;
    procedure ButtonExecutarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;
  Matriz_Transf: array[1..4, 1..4] of Real;

implementation

uses
  Unit1;
{$R *.lfm}

{ TForm4 }

procedure TForm4.FormCreate(Sender: TObject);
begin

end;

procedure TForm4.ButtonExecutarClick(Sender: TObject);
var
  i, j: Integer;
  radiano: Real;
begin

end;

end.

