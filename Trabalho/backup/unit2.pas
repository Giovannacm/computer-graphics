unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Windows;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButtonHSLtoRGB: TButton;
    ButtonRGBtoHSL: TButton;
    ButtonOK: TButton;
    ButtonCancelar: TButton;
    EditH: TEdit;
    EditS: TEdit;
    EditL: TEdit;
    EditR: TEdit;
    EditG: TEdit;
    EditB: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ShapeCor: TShape;
    procedure ButtonHSLtoRGBClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonRGBtoHSLClick(Sender: TObject);
    procedure ButtonCancelarClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

uses
  Unit1;
{$R *.lfm}

{ TForm2 }

procedure TForm2.ButtonCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure MinMax3Valores(const V1, V2, V3: Real; var Min, Max: Real);
begin
  if V1 > V2 then
  begin
    if V1 > V3 then
      Max := V1
    else
      Max := V3;
    if V2 < V3 then
      Min := V2
    else
      Min := V3
  end
  else
  begin
    if V2 > V3 then
      Max := V2
    else
      Max := V3;
    if V1 < V3 then
      Min := V1
    else
      Min := V3
  end;
end;

procedure TForm2.ButtonRGBtoHSLClick(Sender: TObject); //RGB para HSL
var
  R, G, B, H, S, L, min, max, delta: Real;
begin
  R := StrToFloat(EditR.Text);
  G := StrToFloat(EditG.Text);
  B := StrToFloat(EditB.Text);

  ShapeCor.Brush.Color := RGB(Round(R), Round(G), Round(B));

  R := R/255;       //Convertendo os valores para o intervalo [0, 1]
  G := G/255;
  B := B/255;

  min := 0.0;
  max := 0.0;
  MinMax3Valores(R, G, B, min, max);  //Encontrando o menor e maior valor entre R, G e B
  delta := max - min;                 //Calculando a variaçã entre o maior e menor canal

  L := (max + min)/2;                 //Calculando L (luminância) a partir do valor médio entre o maior e manor canal

  if(delta = 0) then                  //Se não houve variação entre o maior e menor canal, ou seja, eles são iguais, isso quer dizer que não houve saturação, dessa forma, ocorre um tom de cinza
      S := 0
  else if(L <= 0.5) then              //Existe saturação
      S := delta/(max + min)
  else if(L > 0.5) then
      S := delta/(2.0 - max - min);

  if(delta = 0) then                  //Se não houve saturação (delta = 0), não é necessário calcular a matiz (H), dessa forma, ela fica como 0 graus
       H := 0
  else if(max = R) then               //Se houve variação, deve ser analisado o maior valor dos canais RGB
       H := (G-B)/delta
  else if(max = G) then
       H := 2.0 + (B-R)/delta
  else                                //max = B
       H := 4.0 + (R-G)/delta;

  H := H * 60;                        //É necessário multiplicar o valor por 60 para convertê-lo para graus

  if(H < 0) then                      //Se ele for negativo, é adicionado 360 graus
       H := H + 360;

  EditH.Text := FloatToStr(Round((H/360)*239));  //Considerando os intervalos do paint, é feito uma normalização desses valores
  EditS.Text := FloatToStr(Round(S * 240));
  EditL.Text := FloatToStr(Round(L * 240));
end;

procedure TForm2.ButtonOKClick(Sender: TObject);
begin
  Form1.ShapeCor.Brush.Color := ShapeCor.Brush.Color;
  Form1.Image1.Canvas.Pen.Color := ShapeCor.Brush.Color;
  Close();
end;

procedure TForm2.ButtonHSLtoRGBClick(Sender: TObject); //HSL para RGB
var
  R, G, B, H, S, L, aux1, aux2, auxR, auxG, auxB: Real;
begin
  H := StrToFloat(EditH.Text);
  S := StrToFloat(EditS.Text);
  L := StrToFloat(EditL.Text);

  H := (H*360)/239;            //Saindo do intervalo do paint para o intervalo do HSL (0º, 1 e 1)
  S := S/240;
  L := L/240;

  if(S = 0) then               //Se não tem saturação, é um tom de cinza, então basta calcular os canais de acordo com a porcentagem de luminância
       begin
          R := 255 * L;
          G := 255 * L;
          B := 255 * L;
       end
  else                         //Existe saturação
       begin
          if(L < 0.5) then
               aux1 := L * (1.0 + S)
          else if(L >= 0.5) then
               aux1 := L + S - (L * S);

          aux2 := 2 * L - aux1;

          H := H/360;

          auxR := H + 0.333;
          auxG := H;
          auxB := H - 0.333;

          if(auxR < 0) then auxR := auxR + 1
          else if(auxR > 1) then auxR := auxR - 1;

          if(auxG < 0) then auxG := auxG + 1
          else if(auxG > 1) then auxG := auxG - 1;

          if(auxB < 0) then auxB := auxB + 1
          else if(auxB > 1) then auxB := auxB - 1;

          if(6 * auxR < 1) then
               R := aux2 + (aux1 - aux2)*6*auxR
          else if(2 * auxR < 1) then
               R := aux1
          else if(3 * auxR < 2) then
               R := aux2 + (aux1 - aux2)*(0.666 - auxR)*6
          else
               R := aux2;

          if(6 * auxG < 1) then
               G := aux2 + (aux1 - aux2)*6*auxG
          else if(2 * auxG < 1) then
               G := aux1
          else if(3 * auxG < 2) then
               G := aux2 + (aux1 - aux2)*(0.666 - auxG)*6
          else
               G := aux2;

          if(6 * auxB < 1) then
               B := aux2 + (aux1 - aux2)*6*auxB
          else if(2 * auxB < 1) then
               B := aux1
          else if(3 * auxB < 2) then
               B := aux2 + (aux1 - aux2)*(0.666 - auxB)*6
          else
               B := aux2;

          R := R * 255.0;             //Multiplicando por 255 para retornar ao intervalo
          G := G * 255.0;
          B := B * 255.0;
         end;
    EditR.Text := FloatToStr(Round(R));
    EditG.Text := FloatToStr(Round(G));
    EditB.Text := FloatToStr(Round(B));

  ShapeCor.Brush.Color := RGB(Round(R), Round(G), Round(B));
end;

procedure TForm2.FormActivate(Sender: TObject);
var
  cor: TColor;
begin
  cor := Form1.ShapeCor.Brush.Color;
  EditR.Text := IntToStr(GetRValue(cor));
  EditG.Text := IntToStr(GetGValue(cor));
  EditB.Text := IntToStr(GetBValue(cor));
  TForm2.ButtonRGBtoHSLClick(Sender);
  ShapeCor.Brush.Color := RGB(StrToInt(EditR.Text), StrToInt(EditG.Text), StrToInt(EditB.Text));
end;

end.

