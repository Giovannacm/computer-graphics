unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ExtCtrls,
  StdCtrls, Unit2, Unit3;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonOperacoes3D: TButton;
    ButtonEditar: TButton;
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemSalvar: TMenuItem;
    MenuItemSair: TMenuItem;
    MenuItemNovo: TMenuItem;
    MenuItemSalvarComo: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    RadioButtonSeedFill8: TRadioButton;
    RadioButtonSeedFill4: TRadioButton;
    RadioButtonEdgeFill: TRadioButton;
    RadioButtonCohenSutherlang: TRadioButton;
    RadioButtonCasa: TRadioButton;
    RadioButtonLinha: TRadioButton;
    RadioButtonCircunferencia: TRadioButton;
    RadioGroup1: TRadioGroup;
    SaveDialog1: TSaveDialog;
    ShapeCor: TShape;
    procedure ButtonEditarClick(Sender: TObject);
    procedure ButtonOperacoes3DClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemNovoClick(Sender: TObject);
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);
    procedure MenuItemSalvarComoClick(Sender: TObject);
    procedure RadioButtonCasaChange(Sender: TObject);
    procedure RadioButtonCohenSutherlangChange(Sender: TObject);
    procedure RadioButtonEdgeFillChange(Sender: TObject);
    procedure RadioButtonSeedFill4Change(Sender: TObject);
    procedure RadioButtonSeedFill8Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  Pressionado, DesenhouJanela, DesenhouForma: Boolean;
  NomeImagemSalvar, NomeImagemAbrir: String;
  X1, Y1, X2, Y2, OffsetX, OffsetY, XMax, YMax, XMin, YMin, ClickCount: Integer;
  Casa3D: array[1..10, 1..4] of Integer;
  Forma1: array[1..5, 1..2] of Integer;
  Forma2: array[1..8, 1..2] of Integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  Pressionado := False;
  DesenhouJanela := False;
  DesenhouForma := False;
  ClickCount := 0;
  NomeImagemSalvar := '';
  NomeImagemAbrir := '';
  Image1.Canvas.Pen.Color := clBlack;
  Image1.Canvas.Pen.Width := 2;
  Image1.Canvas.Clear;
  Image1.Canvas.Clear;
  ShapeCor.Brush.Color := clBlack;
  ButtonOperacoes3D.Enabled := False;
end;

procedure LinhaBresenham(X1, Y1, X2, Y2: Integer; cor: TColor);
var
  xi, yi, dx, dy, d, incX, incY, c, m: Integer;
begin
       xi := X1;
       yi := Y1;

       d := 0;

       dx := X2 - X1;
       dy := Y2 - Y1;

       incX := 1;
       incY := 1;

       if(dx < 0) then
          begin
            incX := -1;
            dx := -1 * dx;
          end;

       if(dy < 0) then
          begin
            incY := -1;
            dy := -1 * dy;
          end;

       if(dy <= dx) then   //dx >= dy
          begin
             c := 2 * dx;
             m := 2 * dy;

             if(incX < 0) then
                dx := dx + 1;

             Form1.Image1.Canvas.Pixels[xi,yi] := cor;

             while(xi <> X2) do
               begin
                    xi := xi + incX;
                    d := d + m;
                    if(d >= dx) then
                       begin
                         yi := yi + incY;
                         d := d - c;
                       end;

                    Form1.Image1.Canvas.Pixels[xi,yi] := cor;
               end;
          end
       else            //dy > dx
          begin
             c := 2 * dy;
             m := 2 * dx;

             if(incY < 0) then
                dy := dy + 1;

             Form1.Image1.Canvas.Pixels[xi,yi] := cor;

             while(yi <> Y2) do
               begin
                    yi := yi + incY;
                    d := d + m;
                    if(d >= dy) then
                       begin
                         xi := xi + incX;
                         d := d - c;
                       end;
                    Form1.Image1.Canvas.Pixels[xi,yi] := cor;
               end;
          end;
end;

procedure CircunferenciaBresenham(X1, Y1, X2, Y2: Integer; cor: TColor);
var
  xi, yi, R, u, v, E: Integer;
begin
       R := Round(sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)));

       xi := 0;
       yi := R;

       u := 1;
       v := 2*r - 1;
       E := 0;

       Form1.Image1.Canvas.Pixels[xi + X1, yi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[xi + X1, -yi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[yi + X1, -xi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[-yi + X1, -xi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[-xi + X1, -yi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[-xi + X1, yi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[-yi + X1, xi + Y1] := cor;
       Form1.Image1.Canvas.Pixels[yi + X1, xi + Y1] := cor;

       while(xi < yi) do
         begin
            xi := xi + 1;
            E := E + u;
            u := u + 2;

            if(v < 2 * E) then
              begin
                yi := yi - 1;
                E := E - v;
                v := v - 2;
              end;

            Form1.Image1.Canvas.Pixels[xi + X1, yi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[xi + X1, -yi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[yi + X1, -xi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[-yi + X1, -xi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[-xi + X1, -yi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[-xi + X1, yi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[-yi + X1, xi + Y1] := cor;
            Form1.Image1.Canvas.Pixels[yi + X1, xi + Y1] := cor;
         end;
end;

function Codigo(const X, Y:Integer):Integer;
var Cod:Integer;
begin
     Cod := 0;
     if(X < XMin) then
        Cod := Cod + 1;
     if(X > XMax) then
        Cod := Cod + 2;
     if(Y < YMin) then
        Cod := Cod + 4;
     if(Y > YMax) then
        Cod := Cod + 8;
     Result := Cod;
end;

procedure CohenSutherlang(X1, Y1, X2, Y2, XMin, YMin, XMax, YMax: Integer; cor: TColor);
var
  Cod1, Cod2: Integer;
  m: Real;
begin
       //Passo 1
       Cod1 := Codigo(X1, Y1);
       Cod2 := Codigo(X2, Y2);

       //Passo 2
       if((Cod1 = 0) and (Cod2 = 0)) then
          LinhaBresenham(X1, Y1, X2, Y2, cor);

       //Passo 3
       if((Cod1 and Cod2) = 0) then
         begin
           while(Cod1 <> 0) do             //Passo 4 e 5
             begin
                m := (Y2 - Y1)/(X2 - X1);
                if((Cod1 and 1) = 1) then
                   begin
                     X1 := XMin;
                     Y1 := Round(m*(XMin - X1) + Y1);
                   end
                else if((Cod1 and 2) = 2) then
                   begin
                     X1 := XMax;
                     Y1 := Round(m*(XMax - X1) + Y1);
                   end
                else if((Cod1 and 4) = 4) then
                   begin
                     X1 := Round((YMin - Y1)/m + X1);
                     Y1 := YMin;
                   end
                else if((Cod1 and 8) = 8) then
                   begin
                     X1 := Round((YMax - Y1)/m + X1);
                     Y1 := YMax;
                   end;
                Cod1 := Codigo(X1, Y1);
             end;

           while(Cod2 <> 0) do                //Passo 4 e 5
             begin
                m := (Y2 - Y1)/(X2 - X1);
                if((Cod2 and 1) = 1) then
                   begin
                     X2 := XMin;
                     Y2 := Round(m*(XMin - X1) + Y1);
                   end
                else if((Cod2 and 2) = 2) then
                   begin
                     X2 := XMax;
                     Y2 := Round(m*(XMax - X1) + Y1);
                   end
                else if((Cod2 and 4) = 4) then
                   begin
                     X2 := Round((YMin - Y1)/m + X1);
                     Y2 := YMin;
                   end
                else if((Cod2 and 8) = 8) then
                   begin
                     X2 := Round((YMax - Y1)/m + X1);
                     Y2 := YMax;
                   end;
                Cod2 := Codigo(X2, Y2);
             end;

           LinhaBresenham(X1, Y1, X2, Y2, cor);
         end;
end;

procedure EdgeFill(X_BBox: Integer; cor_linha, cor: TColor);
var
  i, proximo, inicio_x, inicio_y: Integer;
  cor_atual: TColor;
  m: Real;
begin
       for i:= 1 to 5 do
         begin
              if(i<>5) then proximo := i+1
              else proximo := 1;

              if(Forma1[i, 2] <> Forma1[proximo, 2]) then       //Não é horizontal, então vamos até o limite do bounding box mudando a cor
                 begin
                   if(Forma1[proximo, 1] <>  Forma1[i, 1]) then
                      m := (Forma1[proximo, 2] - Forma1[i, 2])/(Forma1[proximo, 1] - Forma1[i, 1]);

                   if(Forma1[i, 2] < Forma1[proximo, 2]) then
                      begin
                        inicio_y := Forma1[i, 2] + OffsetY;
                        while(inicio_y <= Forma1[proximo, 2] + OffsetY) do
                            begin
                               if(Forma1[proximo, 1] <>  Forma1[i, 1]) then
                                  inicio_x := Round((inicio_y - (Forma1[i, 2]+OffsetY))/m) + (Forma1[i, 1]+OffsetX)
                               else
                                  inicio_x := Forma1[i, 1] + OffsetX;

                              while(inicio_x < X_BBox) do
                                  begin
                                    cor_atual:= Form1.Image1.Canvas.Pixels[inicio_x,inicio_y];
                                    if(cor_atual = cor) and (cor_atual <> cor_linha) then
                                       Form1.Image1.Canvas.Pixels[inicio_x,inicio_y] := clWhite
                                     else if(cor_atual = clWhite) and (cor_atual <> cor_linha) then
                                        Form1.Image1.Canvas.Pixels[inicio_x,inicio_y] := cor;
                                     inicio_x := inicio_x + 1;
                                  end;

                               inicio_y := inicio_y + 1;
                            end;
                      end
                   else
                     begin
                        inicio_y := Forma1[i, 2] + OffsetY;
                        while(inicio_y >= Forma1[proximo, 2] + OffsetY) do
                            begin
                               if(Forma1[proximo, 1] <>  Forma1[i, 1]) then
                                  inicio_x := Round((inicio_y - (Forma1[i, 2]+OffsetY))/m) + (Forma1[i, 1]+OffsetX)
                               else
                                  inicio_x := Forma1[i, 1] + OffsetX;

                              while(inicio_x < X_BBox) do
                                  begin
                                    cor_atual:= Form1.Image1.Canvas.Pixels[inicio_x,inicio_y];
                                    if(cor_atual = cor) and (cor_atual <> cor_linha) then
                                       Form1.Image1.Canvas.Pixels[inicio_x,inicio_y] := clWhite
                                     else if(cor_atual = clWhite) and (cor_atual <> cor_linha) then
                                        Form1.Image1.Canvas.Pixels[inicio_x,inicio_y] := cor;
                                     inicio_x := inicio_x + 1;
                                  end;

                               inicio_y := inicio_y - 1;
                            end;
                      end
                 end;
         end;
end;

procedure SeedFill4(X, Y: Integer; cor_linha, cor: TColor);
begin
       if(Form1.Image1.Canvas.Pixels[X,Y] <> cor_linha) and (Form1.Image1.Canvas.Pixels[X,Y] <> cor) then
          begin
             Form1.Image1.Canvas.Pixels[X,Y] := cor;

             SeedFill4(X+1, Y, cor_linha, cor);
             SeedFill4(X-1, Y, cor_linha, cor);
             SeedFill4(X, Y+1, cor_linha, cor);
             SeedFill4(X, Y-1, cor_linha, cor);
          end;
end;

procedure SeedFill8(X, Y: Integer; cor_linha, cor: TColor);
begin
       if(Form1.Image1.Canvas.Pixels[X,Y] <> cor_linha) and (Form1.Image1.Canvas.Pixels[X,Y] <> cor) then
          begin
             Form1.Image1.Canvas.Pixels[X,Y] := cor;

             SeedFill8(X+1, Y, cor_linha, cor);
             SeedFill8(X-1, Y, cor_linha, cor);
             SeedFill8(X, Y+1, cor_linha, cor);
             SeedFill8(X, Y-1, cor_linha, cor);
             SeedFill8(X+1, Y+1, cor_linha, cor);
             SeedFill8(X-1, Y+1, cor_linha, cor);
             SeedFill8(X+1, Y-1, cor_linha, cor);
             SeedFill8(X-1, Y-1, cor_linha, cor);
          end;
end;

procedure DesenhaCasa(X, Y: Integer; cor: TColor);
begin
       OffsetX := X;
       OffsetY := Y;

       Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY-1] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX, OffsetY-1] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX, OffsetY] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY+1] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX, OffsetY+1] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY+1] := clRed;
       Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY-1] := clRed;

       //X                       //Y                       //Z                       //Coordenada Homogênea
       Casa3D[1,1] := 0;         Casa3D[1,2] := 150;       Casa3D[1,3] := 0;         Casa3D[1,4] := 1;
       Casa3D[2,1] := 100;       Casa3D[2,2] := 150;       Casa3D[2,3] := 0;         Casa3D[2,4] := 1;
       Casa3D[3,1] := 100;       Casa3D[3,2] := 50;        Casa3D[3,3] := 0;         Casa3D[3,4] := 1;
       Casa3D[4,1] := 50;        Casa3D[4,2] := 0;         Casa3D[4,3] := 0;         Casa3D[4,4] := 1;
       Casa3D[5,1] := 0;         Casa3D[5,2] := 50;        Casa3D[5,3] := 0;         Casa3D[5,4] := 1;
       Casa3D[6,1] := 0;         Casa3D[6,2] := 150;       Casa3D[6,3] := 100;       Casa3D[6,4] := 1;
       Casa3D[7,1] := 100;       Casa3D[7,2] := 150;       Casa3D[7,3] := 100;       Casa3D[7,4] := 1;
       Casa3D[8,1] := 100;       Casa3D[8,2] := 50;        Casa3D[8,3] := 100;       Casa3D[8,4] := 1;
       Casa3D[9,1] := 50;        Casa3D[9,2] := 0;         Casa3D[9,3] := 100;       Casa3D[9,4] := 1;
       Casa3D[10,1] := 0;        Casa3D[10,2] := 50;       Casa3D[10,3] := 100;      Casa3D[10,4] := 1;

       Form1.Image1.Canvas.Pen.Color := cor;
       Form1.Image1.Canvas.Line(Casa3D[1,1] + OffsetX, Casa3D[1,2] + OffsetY, Casa3D[2,1] + OffsetX, Casa3D[2,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[2,1] + OffsetX, Casa3D[2,2] + OffsetY, Casa3D[3,1] + OffsetX, Casa3D[3,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[3,1] + OffsetX, Casa3D[3,2] + OffsetY, Casa3D[4,1] + OffsetX, Casa3D[4,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[4,1] + OffsetX, Casa3D[4,2] + OffsetY, Casa3D[5,1] + OffsetX, Casa3D[5,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[5,1] + OffsetX, Casa3D[5,2] + OffsetY, Casa3D[1,1] + OffsetX, Casa3D[1,2] + OffsetY);

       Form1.Image1.Canvas.Line(Casa3D[6,1] + OffsetX, Casa3D[6,2] + OffsetY, Casa3D[7,1] + OffsetX, Casa3D[7,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[7,1] + OffsetX, Casa3D[7,2] + OffsetY, Casa3D[8,1] + OffsetX, Casa3D[8,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[8,1] + OffsetX, Casa3D[8,2] + OffsetY, Casa3D[9,1] + OffsetX, Casa3D[9,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[9,1] + OffsetX, Casa3D[9,2] + OffsetY, Casa3D[10,1] + OffsetX, Casa3D[10,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[10,1] + OffsetX, Casa3D[10,2] + OffsetY, Casa3D[6,1] + OffsetX, Casa3D[6,2] + OffsetY);

       Form1.Image1.Canvas.Line(Casa3D[1,1] + OffsetX, Casa3D[1,2] + OffsetY, Casa3D[6,1] + OffsetX, Casa3D[6,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[2,1] + OffsetX, Casa3D[2,2] + OffsetY, Casa3D[7,1] + OffsetX, Casa3D[7,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[3,1] + OffsetX, Casa3D[3,2] + OffsetY, Casa3D[8,1] + OffsetX, Casa3D[8,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[4,1] + OffsetX, Casa3D[4,2] + OffsetY, Casa3D[9,1] + OffsetX, Casa3D[9,2] + OffsetY);
       Form1.Image1.Canvas.Line(Casa3D[5,1] + OffsetX, Casa3D[5,2] + OffsetY, Casa3D[10,1] + OffsetX, Casa3D[10,2] + OffsetY);
end;

procedure DesenhaForma1(X, Y: Integer; cor: TColor);
begin
       OffsetX := X;
       OffsetY := Y;

       //X                            //Y
       Forma1[1,1] := 0 * 20;         Forma1[1,2] := 0 * 20;
       Forma1[2,1] := 4 * 20;         Forma1[2,2] := 4 * 20;
       Forma1[3,1] := 7 * 20;         Forma1[3,2] := 1 * 20;
       Forma1[4,1] := 7 * 20;         Forma1[4,2] := 6 * 20;
       Forma1[5,1] := 0 * 20;         Forma1[5,2] := 6 * 20;

       LinhaBresenham(Forma1[1,1] + OffsetX, Forma1[1,2] + OffsetY, Forma1[2,1] + OffsetX, Forma1[2,2] + OffsetY, cor);
       LinhaBresenham(Forma1[2,1] + OffsetX, Forma1[2,2] + OffsetY, Forma1[3,1] + OffsetX, Forma1[3,2] + OffsetY, cor);
       LinhaBresenham(Forma1[3,1] + OffsetX, Forma1[3,2] + OffsetY, Forma1[4,1] + OffsetX, Forma1[4,2] + OffsetY, cor);
       LinhaBresenham(Forma1[4,1] + OffsetX, Forma1[4,2] + OffsetY, Forma1[5,1] + OffsetX, Forma1[5,2] + OffsetY, cor);
       LinhaBresenham(Forma1[5,1] + OffsetX, Forma1[5,2] + OffsetY, Forma1[1,1] + OffsetX, Forma1[1,2] + OffsetY, cor);
end;

procedure DesenhaForma2(X, Y: Integer; cor: TColor);
begin
       OffsetX := X;
       OffsetY := Y;

       //X                             //Y
       Forma2[1,1] := 0;          Forma2[1,2] := 0;
       Forma2[2,1] := 80;         Forma2[2,2] := 0;
       Forma2[3,1] := 80;         Forma2[3,2] := 79;
       Forma2[4,1] := 0;          Forma2[4,2] := 80;

       Forma2[5,1] := 160;        Forma2[5,2] := 79;
       Forma2[6,1] := 160;        Forma2[6,2] := 160;
       Forma2[7,1] := 79;         Forma2[7,2] := 160;
       Forma2[8,1] := 79;         Forma2[8,2] := 80;

       LinhaBresenham(Forma2[1,1] + OffsetX, Forma2[1,2] + OffsetY, Forma2[2,1] + OffsetX, Forma2[2,2] + OffsetY, cor);
       LinhaBresenham(Forma2[2,1] + OffsetX, Forma2[2,2] + OffsetY, Forma2[3,1] + OffsetX, Forma2[3,2] + OffsetY, cor);
       LinhaBresenham(Forma2[3,1] + OffsetX, Forma2[3,2] + OffsetY, Forma2[5,1] + OffsetX, Forma2[5,2] + OffsetY, cor);
       LinhaBresenham(Forma2[5,1] + OffsetX, Forma2[5,2] + OffsetY, Forma2[6,1] + OffsetX, Forma2[6,2] + OffsetY, cor);
       LinhaBresenham(Forma2[6,1] + OffsetX, Forma2[6,2] + OffsetY, Forma2[7,1] + OffsetX, Forma2[7,2] + OffsetY, cor);
       LinhaBresenham(Forma2[7,1] + OffsetX, Forma2[7,2] + OffsetY, Forma2[8,1] + OffsetX, Forma2[8,2] + OffsetY, cor);
       LinhaBresenham(Forma2[8,1] + OffsetX, Forma2[8,2] + OffsetY, Forma2[4,1] + OffsetX, Forma2[4,2] + OffsetY, cor);
       LinhaBresenham(Forma2[4,1] + OffsetX, Forma2[4,2] + OffsetY, Forma2[1,1] + OffsetX, Forma2[1,2] + OffsetY, cor);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cor, cor2: TColor;
begin
  Pressionado := True;

  if RadioButtonLinha.Checked then
     begin
       X1 := X;
       Y1 := Y;
     end;

  if RadioButtonCircunferencia.Checked then
     begin
       X1 := X;
       Y1 := Y;
     end;

  if RadioButtonCasa.Checked then    //Desenha a casa
     begin
       Image1.Canvas.Clear;

       cor := Image1.Canvas.Pen.Color;

       DesenhaCasa(X, Y, cor);
     end;

  if RadioButtonCohenSutherlang.Checked then
     begin
       if (not DesenhouJanela) then
          Image1.Canvas.Clear;

       X1 := X;
       Y1 := Y;
     end;

  if RadioButtonEdgeFill.Checked then
     begin
       if (not DesenhouForma) then
          Image1.Canvas.Clear;


       if (ClickCount = 0) then
          begin
            cor := Image1.Canvas.Pen.Color;
            DesenhaForma1(X, Y, cor);
            ClickCount := ClickCount + 1;
            DesenhouForma := True;
            //Definindo o X do bounding box (até onde o preenchimento das poligonais não horizontais deve ir)
            X1 := Forma1[4,1] + X + 3;
          end
       else
          begin
            cor2 := Image1.Canvas.Pen.Color;
            EdgeFill(X1, cor, cor2);
          end
     end;

  if RadioButtonSeedFill4.Checked then
     begin
       if (not DesenhouForma) then
          Image1.Canvas.Clear;

       if (ClickCount = 0) then
          begin
            cor := Image1.Canvas.Pen.Color;
            DesenhaForma2(X, Y, cor);
            ClickCount := ClickCount + 1;
            DesenhouForma := True;
          end
       else
          begin
            cor2 := Image1.Canvas.Pen.Color;
            SeedFill4(X, Y, cor, cor2);
            Form1.Image1.Canvas.Pixels[X,Y] := clGreen;
          end
     end;

  if RadioButtonSeedFill8.Checked then
     begin
       if (not DesenhouForma) then
          Image1.Canvas.Clear;

       if (ClickCount = 0) then
          begin
            cor := Image1.Canvas.Pen.Color;
            DesenhaForma2(X, Y, cor);
            ClickCount := ClickCount + 1;
            DesenhouForma := True;
          end
       else
          begin
            cor2 := Image1.Canvas.Pen.Color;
            SeedFill8(X, Y, cor, cor2);
            Form1.Image1.Canvas.Pixels[X,Y] := clGreen;
          end
     end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  cor: TColor;
begin
  Pressionado := False;

  if RadioButtonLinha.Checked then           //Linha Bresenham
     begin
       cor := Image1.Canvas.Pen.Color;

       X2 := X;
       Y2 := Y;

       LinhaBresenham(X1, Y1, X2, Y2, cor);
     end;

  if RadioButtonCircunferencia.Checked then    //Circunferência Bresenham
     begin
       cor := Image1.Canvas.Pen.Color;

       X2 := X;
       Y2 := Y;

       CircunferenciaBresenham(X1, Y1, X2, Y2, cor);
     end;

  if RadioButtonCohenSutherlang.Checked then   //Algoritmo Cohen Sutherlang
     begin
       cor := Image1.Canvas.Pen.Color;

       X2 := X;
       Y2 := Y;

       if(not DesenhouJanela) then
          begin
            LinhaBresenham(X1, Y1, X1, Y2, cor);
            LinhaBresenham(X1, Y2, X2, Y2, cor);
            LinhaBresenham(X2, Y2, X2, Y1, cor);
            LinhaBresenham(X2, Y1, X1, Y1, cor);
            DesenhouJanela := True;
            if((X1 < X2) and (Y1 < Y2)) then
               begin
                 XMin := X1;
                 YMin := Y1;
                 XMax := X2;
                 YMax := Y2;
               end
            else if((X1 > X2) and (Y1 > Y2)) then
               begin
                 XMin := X2;
                 YMin := Y2;
                 XMax := X1;
                 YMax := Y1;

               end
            else if((X1 > X2) and (Y1 < Y2)) then
               begin
                 XMin := X2;
                 YMin := Y1;
                 XMax := X1;
                 YMax := Y2;
               end
            else if((X1 < X2) and (Y1 > Y2)) then
               begin
                 XMin := X1;
                 YMin := Y2;
                 XMax := X2;
                 YMax := Y1;
               end;
          end
       else
          begin
            CohenSutherlang(X1, Y1, X2, Y2, XMin, YMin, XMax, YMax, cor);
          end;
     end;
end;

procedure TForm1.ButtonEditarClick(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.ButtonOperacoes3DClick(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.MenuItemAbrirClick(Sender: TObject);
begin
  if(OpenDialog1.Execute()) then
     begin
       NomeImagemAbrir := OpenDialog1.FileName;
       Image1.Picture.LoadFromFile(NomeImagemAbrir);
       NomeImagemSalvar := '';
     end;
end;

procedure TForm1.MenuItemNovoClick(Sender: TObject);
begin
  Image1.Canvas.Clear;
  Image1.Canvas.Clear;
  NomeImagemSalvar := '';
  NomeImagemAbrir := '';
end;

procedure TForm1.MenuItemSairClick(Sender: TObject);
begin
  Close();
end;

procedure TForm1.MenuItemSalvarClick(Sender: TObject);
begin
  if NomeImagemSalvar <> '' then
     begin
       Image1.Picture.SaveToFile(NomeImagemSalvar);
     end
  else
     begin
       if(OpenDialog1.Execute()) then
          begin
            NomeImagemSalvar := OpenDialog1.FileName;
            Image1.Picture.SaveToFile(NomeImagemSalvar);
          end;
     end;
end;

procedure TForm1.MenuItemSalvarComoClick(Sender: TObject);
begin
  if(OpenDialog1.Execute()) then
     begin
       NomeImagemSalvar := OpenDialog1.FileName;
       Image1.Picture.SaveToFile(NomeImagemSalvar);
     end;
end;

procedure TForm1.RadioButtonCasaChange(Sender: TObject);
begin
  if(RadioButtonCasa.Checked) then
     ButtonOperacoes3D.Enabled := True
  else
     ButtonOperacoes3D.Enabled := False;
end;

procedure TForm1.RadioButtonCohenSutherlangChange(Sender: TObject);
begin
  if(RadioButtonCohenSutherlang.Checked) then
     DesenhouJanela := False;
end;

procedure TForm1.RadioButtonEdgeFillChange(Sender: TObject);
begin
  if(RadioButtonEdgeFill.Checked) then
     begin
       ClickCount := 0;
       DesenhouForma := False;
     end;
end;

procedure TForm1.RadioButtonSeedFill4Change(Sender: TObject);
begin
  if(RadioButtonSeedFill4.Checked) then
     begin
       ClickCount := 0;
       DesenhouForma := False;
     end;
end;

procedure TForm1.RadioButtonSeedFill8Change(Sender: TObject);
begin
  if(RadioButtonSeedFill8.Checked) then
     begin
       ClickCount := 0;
       DesenhouForma := False;
     end;
end;

end.

