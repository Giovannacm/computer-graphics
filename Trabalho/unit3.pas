unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    ButtonCancelar: TButton;
    ButtonExecutar: TButton;
    EditEscalaX: TEdit;
    EditTranslacaoX: TEdit;
    EditMa: TEdit;
    EditMd: TEdit;
    EditMg: TEdit;
    EditMl: TEdit;
    EditMp: TEdit;
    EditEscalaY: TEdit;
    EditTranslacaoY: TEdit;
    EditMb: TEdit;
    EditMe: TEdit;
    EditMh: TEdit;
    EditMm: TEdit;
    EditMq: TEdit;
    EditEscalaZ: TEdit;
    EditEscalaGlobal: TEdit;
    EditTranslacaoZ: TEdit;
    EditMc: TEdit;
    EditMf: TEdit;
    EditMi: TEdit;
    EditMn: TEdit;
    EditMr: TEdit;
    EditMs: TEdit;
    EditRotacaoGraus: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioButtonEixoX: TRadioButton;
    RadioButtonEixoY: TRadioButton;
    RadioButtonEixoZ: TRadioButton;
    RadioButtonShearing: TRadioButton;
    RadioButtonRotacaoCentroObj: TRadioButton;
    RadioButtonRotacaoOrigem: TRadioButton;
    RadioButtonTranslacao: TRadioButton;
    RadioButtonEscalaGlobal: TRadioButton;
    RadioButtonEscalaLocal: TRadioButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    procedure ButtonCancelarClick(Sender: TObject);
    procedure ButtonExecutarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonEscalaGlobalChange(Sender: TObject);
    procedure RadioButtonEscalaLocalChange(Sender: TObject);
    procedure RadioButtonRotacaoCentroObjChange(Sender: TObject);
    procedure RadioButtonRotacaoOrigemChange(Sender: TObject);
    procedure RadioButtonShearingChange(Sender: TObject);
    procedure RadioButtonTranslacaoChange(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;
  Casa3D_Resultado: array[1..10, 1..4] of Integer;
  Matriz_Transf: array[1..4, 1..4] of Real;

implementation

uses
  Unit1;
{$R *.lfm}

{ TForm3 }

procedure TForm3.ButtonCancelarClick(Sender: TObject);
begin
   Close();
end;

procedure TForm3.ButtonExecutarClick(Sender: TObject);
var
  i, j, OffsetX, OffsetY: Integer;
  radiano, fator, centroX, centroY, centroZ: Real;
begin
   Form1.Image1.Canvas.Clear;

   OffsetX := Unit1.OffsetX;
   OffsetY := Unit1.OffsetY;

   if(RadioButtonEscalaLocal.Checked) then
      begin
        for i:=1 to 10 do
            begin
                 Unit1.Casa3D[i, 1] := Round(Unit1.Casa3D[i, 1] * StrToFloat(EditEscalaX.Text));
                 Unit1.Casa3D[i, 2] := Round(Unit1.Casa3D[i, 2] * StrToFloat(EditEscalaY.Text));
                 Unit1.Casa3D[i, 3] := Round(Unit1.Casa3D[i, 3] * StrToFloat(EditEscalaZ.Text));

                 Casa3D_Resultado[i, 1] := Unit1.Casa3D[i, 1];
                 Casa3D_Resultado[i, 2] := Unit1.Casa3D[i, 2];
                 Casa3D_Resultado[i, 3] := Unit1.Casa3D[i, 3];
            end;
      end
   else if(RadioButtonEscalaGlobal.Checked) then
      begin
        fator := 1.0/StrToFloat(EditEscalaGlobal.Text);

        for i:=1 to 10 do
            begin
                 Unit1.Casa3D[i, 1] := Round(Unit1.Casa3D[i, 1] * fator);
                 Unit1.Casa3D[i, 2] := Round(Unit1.Casa3D[i, 2] * fator);
                 Unit1.Casa3D[i, 3] := Round(Unit1.Casa3D[i, 3] * fator);

                 Casa3D_Resultado[i, 1] := Unit1.Casa3D[i, 1];
                 Casa3D_Resultado[i, 2] := Unit1.Casa3D[i, 2];
                 Casa3D_Resultado[i, 3] := Unit1.Casa3D[i, 3];
            end;
      end
   else if(RadioButtonTranslacao.Checked) then
      begin
        for i:=1 to 10 do
            begin
                 Unit1.Casa3D[i, 1] := Round(Unit1.Casa3D[i, 1] + StrToFloat(EditTranslacaoX.Text));
                 Unit1.Casa3D[i, 2] := Round(Unit1.Casa3D[i, 2] + StrToFloat(EditTranslacaoY.Text));
                 Unit1.Casa3D[i, 3] := Round(Unit1.Casa3D[i, 3] + StrToFloat(EditTranslacaoZ.Text));

                 Casa3D_Resultado[i, 1] := Unit1.Casa3D[i, 1];
                 Casa3D_Resultado[i, 2] := Unit1.Casa3D[i, 2];
                 Casa3D_Resultado[i, 3] := Unit1.Casa3D[i, 3];
            end;
      end
   else if(RadioButtonRotacaoOrigem.Checked) then
      begin
        for i:=1 to 4 do
            for j:=1 to 4 do
                begin
                     Matriz_Transf[i, j] := 0;
                end;

        radiano := ((StrToFloat(EditRotacaoGraus.Text))*Pi)/180;

        if(RadioButtonEixoX.Checked) then
           begin
             Matriz_Transf[1, 1] := 1.0;
             Matriz_Transf[4, 4] := 1.0;
             Matriz_Transf[2, 2] := cos(radiano);
             Matriz_Transf[2, 3] := -sin(radiano);
             Matriz_Transf[3, 2] := sin(radiano);
             Matriz_Transf[3, 3] := cos(radiano);
           end
        else if(RadioButtonEixoY.Checked) then
           begin
             Matriz_Transf[1, 1] := cos(radiano);
             Matriz_Transf[1, 3] := sin(radiano);
             Matriz_Transf[2, 2] := 1.0;
             Matriz_Transf[3, 1] := -sin(radiano);
             Matriz_Transf[3, 3] := cos(radiano);
             Matriz_Transf[4, 4] := 1.0;
           end
        else if(RadioButtonEixoZ.Checked) then
           begin
             Matriz_Transf[1, 1] := cos(radiano);
             Matriz_Transf[1, 2] := -sin(radiano);
             Matriz_Transf[2, 1] := sin(radiano);
             Matriz_Transf[2, 2] := cos(radiano);
             Matriz_Transf[3, 3] := 1.0;
             Matriz_Transf[4, 4] := 1.0;
           end;

        for i:=1 to 10 do
            begin
                 Casa3D_Resultado[i, 1] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,1]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,1]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,1]));
                 Casa3D_Resultado[i, 2] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,2]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,2]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,2]));
                 Casa3D_Resultado[i, 3] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,3]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,3]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,3]));
            end;

        for i:=1 to 10 do
            begin
                 Unit1.Casa3D[i, 1] := Casa3D_Resultado[i, 1];
                 Unit1.Casa3D[i, 2] := Casa3D_Resultado[i, 2];
                 Unit1.Casa3D[i, 3] := Casa3D_Resultado[i, 3];
            end;
      end
   else if(RadioButtonRotacaoCentroObj.Checked) then
      begin
        for i:=1 to 4 do
            for j:=1 to 4 do
                begin
                     Matriz_Transf[i, j] := 0;
                end;

        radiano := ((StrToFloat(EditRotacaoGraus.Text))*Pi)/180;

        centroX := (Unit1.Casa3D[1,1]+Unit1.Casa3D[2,1]+Unit1.Casa3D[3,1]+Unit1.Casa3D[4,1]+Unit1.Casa3D[5,1]+Unit1.Casa3D[6,1]+Unit1.Casa3D[7,1]+Unit1.Casa3D[8,1]+Unit1.Casa3D[9,1]+Unit1.Casa3D[10,1])/10;
        centroY := (Unit1.Casa3D[1,2]+Unit1.Casa3D[2,2]+Unit1.Casa3D[3,2]+Unit1.Casa3D[4,2]+Unit1.Casa3D[5,2]+Unit1.Casa3D[6,2]+Unit1.Casa3D[7,2]+Unit1.Casa3D[8,2]+Unit1.Casa3D[9,2]+Unit1.Casa3D[10,2])/10;
        centroZ := (Unit1.Casa3D[1,3]+Unit1.Casa3D[2,3]+Unit1.Casa3D[3,3]+Unit1.Casa3D[4,3]+Unit1.Casa3D[5,3]+Unit1.Casa3D[6,3]+Unit1.Casa3D[7,3]+Unit1.Casa3D[8,3]+Unit1.Casa3D[9,3]+Unit1.Casa3D[10,3])/10;

        for i:=1 to 10 do   //Voltando para a origem
            begin
                 Unit1.Casa3D[i, 1] := Unit1.Casa3D[i, 1] - Round(centroX);
                 Unit1.Casa3D[i, 2] := Unit1.Casa3D[i, 2] - Round(centroY);
                 Unit1.Casa3D[i, 3] := Unit1.Casa3D[i, 3] - Round(centroZ);
            end;

        if(RadioButtonEixoX.Checked) then
           begin
             Matriz_Transf[1, 1] := 1.0;
             Matriz_Transf[4, 4] := 1.0;
             Matriz_Transf[2, 2] := cos(radiano);
             Matriz_Transf[2, 3] := -sin(radiano);
             Matriz_Transf[3, 2] := sin(radiano);
             Matriz_Transf[3, 3] := cos(radiano);
           end
        else if(RadioButtonEixoY.Checked) then
           begin
             Matriz_Transf[1, 1] := cos(radiano);
             Matriz_Transf[1, 3] := sin(radiano);
             Matriz_Transf[2, 2] := 1.0;
             Matriz_Transf[3, 1] := -sin(radiano);
             Matriz_Transf[3, 3] := cos(radiano);
             Matriz_Transf[4, 4] := 1.0;
           end
        else if(RadioButtonEixoZ.Checked) then
           begin
             Matriz_Transf[1, 1] := cos(radiano);
             Matriz_Transf[1, 2] := -sin(radiano);
             Matriz_Transf[2, 1] := sin(radiano);
             Matriz_Transf[2, 2] := cos(radiano);
             Matriz_Transf[3, 3] := 1.0;
             Matriz_Transf[4, 4] := 1.0;
           end;

        for i:=1 to 10 do
            begin
                 Casa3D_Resultado[i, 1] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,1]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,1]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,1]));
                 Casa3D_Resultado[i, 2] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,2]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,2]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,2]));
                 Casa3D_Resultado[i, 3] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,3]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,3]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,3]));
            end;

        for i:=1 to 10 do    //Voltando para o centro
            begin
                 Casa3D_Resultado[i, 1] := Casa3D_Resultado[i, 1] + Round(centroX);
                 Casa3D_Resultado[i, 2] := Casa3D_Resultado[i, 2] + Round(centroY);
                 Casa3D_Resultado[i, 3] := Casa3D_Resultado[i, 3] + Round(centroZ);

                 Unit1.Casa3D[i, 1] := Casa3D_Resultado[i, 1];
                 Unit1.Casa3D[i, 2] := Casa3D_Resultado[i, 2];
                 Unit1.Casa3D[i, 3] := Casa3D_Resultado[i, 3];
            end;
      end
   else if(RadioButtonShearing.Checked) then
      begin
        Matriz_Transf[1, 1] := 1.0;
        Matriz_Transf[2, 2] := 1.0;
        Matriz_Transf[3, 3] := 1.0;
        Matriz_Transf[4, 4] := 1.0;
        Matriz_Transf[1, 2] := StrToFloat(EditMb.Text);
        Matriz_Transf[1, 3] := StrToFloat(EditMc.Text);
        Matriz_Transf[2, 1] := StrToFloat(EditMd.Text);
        Matriz_Transf[2, 3] := StrToFloat(EditMf.Text);
        Matriz_Transf[3, 1] := StrToFloat(EditMg.Text);
        Matriz_Transf[3, 2] := StrToFloat(EditMh.Text);

        for i:=1 to 10 do
            begin
                 Casa3D_Resultado[i, 1] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,1]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,1]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,1]));
                 Casa3D_Resultado[i, 2] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,2]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,2]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,2]));
                 Casa3D_Resultado[i, 3] := Round((Unit1.Casa3D[i,1] * Matriz_Transf[1,3]) + (Unit1.Casa3D[i,2] * Matriz_Transf[2,3]) + (Unit1.Casa3D[i,3] * Matriz_Transf[3,3]));
            end;

        for i:=1 to 10 do
            begin
                 Unit1.Casa3D[i, 1] := Casa3D_Resultado[i, 1];
                 Unit1.Casa3D[i, 2] := Casa3D_Resultado[i, 2];
                 Unit1.Casa3D[i, 3] := Casa3D_Resultado[i, 3];
            end;
      end;

   Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY-1] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX, OffsetY-1] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX, OffsetY] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY+1] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX, OffsetY+1] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX-1, OffsetY+1] := clRed;
   Form1.Image1.Canvas.Pixels[OffsetX+1, OffsetY-1] := clRed;

   Form1.Image1.Canvas.Line(Casa3D_Resultado[1,1] + OffsetX, Casa3D_Resultado[1,2] + OffsetY, Casa3D_Resultado[2,1] + OffsetX, Casa3D_Resultado[2,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[2,1] + OffsetX, Casa3D_Resultado[2,2] + OffsetY, Casa3D_Resultado[3,1] + OffsetX, Casa3D_Resultado[3,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[3,1] + OffsetX, Casa3D_Resultado[3,2] + OffsetY, Casa3D_Resultado[4,1] + OffsetX, Casa3D_Resultado[4,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[4,1] + OffsetX, Casa3D_Resultado[4,2] + OffsetY, Casa3D_Resultado[5,1] + OffsetX, Casa3D_Resultado[5,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[5,1] + OffsetX, Casa3D_Resultado[5,2] + OffsetY, Casa3D_Resultado[1,1] + OffsetX, Casa3D_Resultado[1,2] + OffsetY);

   Form1.Image1.Canvas.Line(Casa3D_Resultado[6,1] + OffsetX, Casa3D_Resultado[6,2] + OffsetY, Casa3D_Resultado[7,1] + OffsetX, Casa3D_Resultado[7,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[7,1] + OffsetX, Casa3D_Resultado[7,2] + OffsetY, Casa3D_Resultado[8,1] + OffsetX, Casa3D_Resultado[8,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[8,1] + OffsetX, Casa3D_Resultado[8,2] + OffsetY, Casa3D_Resultado[9,1] + OffsetX, Casa3D_Resultado[9,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[9,1] + OffsetX, Casa3D_Resultado[9,2] + OffsetY, Casa3D_Resultado[10,1] + OffsetX, Casa3D_Resultado[10,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[10,1] + OffsetX, Casa3D_Resultado[10,2] + OffsetY, Casa3D_Resultado[6,1] + OffsetX, Casa3D_Resultado[6,2] + OffsetY);

   Form1.Image1.Canvas.Line(Casa3D_Resultado[1,1] + OffsetX, Casa3D_Resultado[1,2] + OffsetY, Casa3D_Resultado[6,1] + OffsetX, Casa3D_Resultado[6,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[2,1] + OffsetX, Casa3D_Resultado[2,2] + OffsetY, Casa3D_Resultado[7,1] + OffsetX, Casa3D_Resultado[7,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[3,1] + OffsetX, Casa3D_Resultado[3,2] + OffsetY, Casa3D_Resultado[8,1] + OffsetX, Casa3D_Resultado[8,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[4,1] + OffsetX, Casa3D_Resultado[4,2] + OffsetY, Casa3D_Resultado[9,1] + OffsetX, Casa3D_Resultado[9,2] + OffsetY);
   Form1.Image1.Canvas.Line(Casa3D_Resultado[5,1] + OffsetX, Casa3D_Resultado[5,2] + OffsetY, Casa3D_Resultado[10,1] + OffsetX, Casa3D_Resultado[10,2] + OffsetY);

   Close();
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  RadioButtonEscalaLocal.Checked := True;
  RadioButtonEscalaGlobalChange(Sender);
  RadioButtonEscalaLocalChange(Sender);
  RadioButtonRotacaoCentroObjChange(Sender);
  RadioButtonRotacaoOrigemChange(Sender);
  RadioButtonShearingChange(Sender);
  RadioButtonTranslacaoChange(Sender);
end;

procedure TForm3.RadioButtonEscalaGlobalChange(Sender: TObject);
begin
  if(RadioButtonEscalaGlobal.Checked) then
     EditEscalaGlobal.Enabled := True
  else
     EditEscalaGlobal.Enabled := False;
end;

procedure TForm3.RadioButtonEscalaLocalChange(Sender: TObject);
begin
  if(RadioButtonEscalaLocal.Checked) then
     begin
       EditEscalaX.Enabled := True;
       EditEscalaY.Enabled := True;
       EditEscalaZ.Enabled := True;
     end
  else
     begin
       EditEscalaX.Enabled := False;
       EditEscalaY.Enabled := False;
       EditEscalaZ.Enabled := False;
     end;
end;

procedure TForm3.RadioButtonRotacaoCentroObjChange(Sender: TObject);
begin
  if(RadioButtonRotacaoCentroObj.Checked) then
     begin
       EditRotacaoGraus.Enabled := True;
       RadioGroup2.Enabled := True;
     end
  else
     begin
       EditRotacaoGraus.Enabled := False;
       RadioGroup2.Enabled := False;
     end;
end;

procedure TForm3.RadioButtonRotacaoOrigemChange(Sender: TObject);
begin
  if(RadioButtonRotacaoOrigem.Checked) then
     begin
       EditRotacaoGraus.Enabled := True;
       RadioGroup2.Enabled := True;
     end
  else
     begin
       EditRotacaoGraus.Enabled := False;
       RadioGroup2.Enabled := False;
     end;
end;

procedure TForm3.RadioButtonShearingChange(Sender: TObject);
begin
  if(RadioButtonShearing.Checked) then
     begin
       EditMb.Enabled := True;
       EditMc.Enabled := True;
       EditMf.Enabled := True;
       EditMd.Enabled := True;
       EditMg.Enabled := True;
       EditMh.Enabled := True;
     end
  else
     begin
       EditMb.Enabled := False;
       EditMc.Enabled := False;
       EditMf.Enabled := False;
       EditMd.Enabled := False;
       EditMg.Enabled := False;
       EditMh.Enabled := False;
     end;
end;

procedure TForm3.RadioButtonTranslacaoChange(Sender: TObject);
begin
  if(RadioButtonTranslacao.Checked) then
     begin
       EditTranslacaoX.Enabled := True;
       EditTranslacaoY.Enabled := True;
       EditTranslacaoZ.Enabled := True;
     end
  else
     begin
       EditTranslacaoX.Enabled := False;
       EditTranslacaoY.Enabled := False;
       EditTranslacaoZ.Enabled := False;
     end;
end;

end.

