let canvas = document.getElementById("myCanvas");
let context = canvas.getContext("2d");
context.fillStyle = "#FF0000";

let altura = canvas.height;
let largura = canvas.width;
let origem = inicializaCanvas(context, altura, largura);

window.onload = function() 
{
    document.getElementById('ZBuffer').addEventListener('click', clicked);
    document.getElementById('SupBilinear').addEventListener('click', clicked);
    document.getElementById('VarrRot').addEventListener('click', clicked);
    document.getElementById('Iluminacao').addEventListener('click', clicked);
    clicked();
}

function clicked()
{
    context.clearRect(0, 0, canvas.width, canvas.height);
    document.getElementById('grau').disabled = false;
    document.getElementById('eixoX').disabled = false;
    document.getElementById('eixoY').disabled = false;
    document.getElementById('eixoZ').disabled = false;
    document.getElementById('btnRotacao').disabled = false;
    document.getElementById('aplicarVarredura').disabled = true;
    document.getElementById('Ia').disabled = true;
    document.getElementById('Ka').disabled = true;
    document.getElementById('Il').disabled = true;
    document.getElementById('k').disabled = true;
    document.getElementById('n').disabled = true;
    document.getElementById('aplicarIluminacao1').disabled = true;
    document.getElementById('aplicarIluminacao2').disabled = true;

    if(document.getElementById('ZBuffer').checked) //ZBuffer
    { 
        let zBuffer = inicializaZBuffer(largura, altura);
        
        let objetoAzul = coordenadasObjetoAzul(10, 30, 20, 40); 
        let objetoVermelho = coordenadasObjetoVermelho(50, 100, 30, 80); 
        let objetoAmarelo = coordenadasObjetoAmarelo(0, 50, 0, 2 * Math.PI); 
        let objetoVerde = coordenadasObjetoVerde(0, 2 * Math.PI, 0, 2 * Math.PI); 
        let objetoBranco = coordenadasObjetoBranco(0, 40); 

        aplicaZBuffer(origem, zBuffer, objetoAzul, [0, 0, 255]); 
        aplicaZBuffer(origem, zBuffer, objetoVermelho, [255, 0, 0]); 
        aplicaZBuffer(origem, zBuffer, objetoAmarelo, [255, 255, 0]); 
        aplicaZBuffer(origem, zBuffer, objetoVerde, [0, 255, 0]); 
        aplicaZBuffer(origem, zBuffer, objetoBranco, [255, 255, 255]); 

        desenhaZBuffer(context, zBuffer, largura, altura);

        document.getElementById('btnRotacao').onclick = function()
        {
            let grau = Number(document.getElementById('grau').value) * (Math.PI / 180);
            
            if(document.getElementById('eixoX').checked)
            {
                rotacaoX(objetoAzul, grau);
                rotacaoX(objetoVermelho, grau);
                rotacaoX(objetoAmarelo, grau);
                rotacaoX(objetoVerde, grau);
                rotacaoX(objetoBranco, grau);
            }
            else if(document.getElementById('eixoY').checked)
            {
                rotacaoY(objetoAzul, grau);
                rotacaoY(objetoVermelho, grau);
                rotacaoY(objetoAmarelo, grau);
                rotacaoY(objetoVerde, grau);
                rotacaoY(objetoBranco, grau);
            }
            else if(document.getElementById('eixoZ').checked)
            {
                rotacaoZ(objetoAzul, grau);
                rotacaoZ(objetoVermelho, grau);
                rotacaoZ(objetoAmarelo, grau);
                rotacaoZ(objetoVerde, grau);
                rotacaoZ(objetoBranco, grau);
            }

            zBuffer = inicializaZBuffer(largura, altura);

            aplicaZBuffer(origem, zBuffer, objetoAzul, [0, 0, 255]); 
            aplicaZBuffer(origem, zBuffer, objetoVermelho, [255, 0, 0]); 
            aplicaZBuffer(origem, zBuffer, objetoAmarelo, [255, 255, 0]); 
            aplicaZBuffer(origem, zBuffer, objetoVerde, [0, 255, 0]); 
            aplicaZBuffer(origem, zBuffer, objetoBranco, [255, 255, 255]); 

            desenhaZBuffer(context, zBuffer, largura, altura);
        }
    } 
    else if(document.getElementById('SupBilinear').checked) //Superfície bilinear
    { 
        let zBuffer = inicializaZBuffer(largura, altura);
        let objetos = coordenadasObjetos();   

        aplicaZBufferObjetos(origem, zBuffer, objetos);

        desenhaZBuffer(context, zBuffer, largura, altura);

        document.getElementById('btnRotacao').onclick = function()
        {            
            let grau = Number(document.getElementById('grau').value) * (Math.PI / 180);

            if(document.getElementById('eixoX').checked)
                rotacaoX(objetos, grau);
            else if(document.getElementById('eixoY').checked)
                rotacaoY(objetos, grau);
            else if(document.getElementById('eixoZ').checked)  
                rotacaoZ(objetos, grau);

            zBuffer = inicializaZBuffer(largura, altura);

            aplicaZBufferObjetos(origem, zBuffer, objetos);

            desenhaZBuffer(context, zBuffer, largura, altura);
        }
    }
    else if(document.getElementById('VarrRot').checked) //Varredura Rotacional
    { 
        document.getElementById('grau').disabled = true;
        document.getElementById('eixoX').disabled = true;
        document.getElementById('eixoY').disabled = true;
        document.getElementById('eixoZ').disabled = true;
        document.getElementById('btnRotacao').disabled = true;
        document.getElementById('aplicarVarredura').disabled = false;

        context.beginPath();
        context.moveTo(500, 0);
        context.lineTo(500, 500);
        context.stroke();

        let isDown = false;
        let x1, y1, x2, y2;
        let coords1 = [];
        let coords2 = [];
        let eixo = canvas.width/2;
        
        canvas.onmousedown = function(evt)
        {
            if (isDown == false) 
            {
                isDown = true;

                context.clearRect(0, 0, canvas.width, canvas.height);

                coords1 = [];
                coords2 = [];

                context.beginPath();
                context.moveTo(500, 0);
                context.lineTo(500, 500);
                context.stroke();

                x1 = evt.clientX - canvas.offsetLeft;
                y1 = evt.clientY - canvas.offsetTop;
            }
        }

        canvas.onmousemove = function(evt)
        {
            if(isDown)
            {
                x2 = evt.clientX - canvas.offsetLeft;
                y2 = evt.clientY - canvas.offsetTop;

                context.fillRect(x2, y2, 1, 1);
                coords1.push({x: x2, y: y2, z: 0});
            
                x1 = x2;
                y1 = y2;
            }
        }

        canvas.onmouseup = function(evt)
        {
            if (isDown == true) 
            {
                isDown = false;
                x2 = evt.clientX - canvas.offsetLeft;
                y2 = evt.clientY - canvas.offsetTop;

                context.fillRect(x2, y2, 1, 1);
                coords1.push({x: x2, y: y2, z: 0});

                aplicarVarredura(coords1, coords2, eixo);
            }
        }

        document.getElementById('aplicarVarredura').onclick = function()
        {
            let cavaleiraCoords = Cavaleira(coords2);
            desenhaVarredura(cavaleiraCoords, context, 'black', eixo);

            coords1 = [];
            coords2 = [];        
        }
    }
    else if(document.getElementById('Iluminacao').checked) //Iluminação
    { 
        document.getElementById('grau').disabled = true;
        document.getElementById('eixoX').disabled = true;
        document.getElementById('eixoY').disabled = true;
        document.getElementById('eixoZ').disabled = true;
        document.getElementById('btnRotacao').disabled = true;
        document.getElementById('aplicarIluminacao1').disabled = false;
        document.getElementById('aplicarIluminacao2').disabled = false;
        document.getElementById('Ia').disabled = false;
        document.getElementById('Ka').disabled = false;
        document.getElementById('Il').disabled = false;
        document.getElementById('k').disabled = false;
        document.getElementById('n').disabled = false;

        let zBuffer = inicializaZBuffer(largura, altura);
        
        let esfera = coordenadasEsfera(0, 50); 
        let plano = coordenadasPlano(0, 100, 0, 100); 
        
        aplicaZBuffer(origem, zBuffer, esfera, [255, 90, 255]); 
        aplicaZBuffer(origem, zBuffer, plano, [0, 0, 255]); 

        desenhaZBuffer(context, zBuffer, largura, altura);

        let Ia = Number(document.getElementById('Ia').value);
        let Ka = Number(document.getElementById('Ka').value);
        let Il = Number(document.getElementById('Il').value);

        document.getElementById('aplicarIluminacao1').onclick = function()
        {
            zBuffer = inicializaZBuffer(largura, altura);

            aplicaModeloDeIluminacao1(esfera, Ia, Ka, Il, 0.3, 'esfera', luz = [100, 0, 100], origem, zBuffer, cor = [255, 90, 255]);
            aplicaModeloDeIluminacao1(plano, Ia, Ka, Il, 0.7, 'plano', luz = [100, 0, 100], origem, zBuffer, cor = [0, 0, 255]);

            desenhaZBuffer(context, zBuffer, largura, altura);
        }
        document.getElementById('aplicarIluminacao2').onclick = function()
        {
            let k = Number(document.getElementById('k').value);
            let n = Number(document.getElementById('n').value);

            zBuffer = inicializaZBuffer(largura, altura);

            aplicaModeloDeIluminacao2(esfera, Ia, Ka, Il, 0.3, k, 0.8, n, 'esfera', luz = [100, 0, 100], observador = [0, 0, 100], origem, zBuffer, cor = [255, 90, 255]);
            aplicaModeloDeIluminacao2(plano, Ia, Ka, Il, 0.7, k, 0.4, n, 'plano', luz = [100, 0, 100], observador = [0, 0, 100], origem, zBuffer, cor = [0, 0, 255]);

            desenhaZBuffer(context, zBuffer, largura, altura);
        }
    }
}


function inicializaCanvas(context, altura, largura) 
{
    context.clearRect(0, 0, altura, largura);
    return {x: parseInt(largura / 2), y: parseInt(altura / 2)}
}

function inicializaZBuffer(largura, altura) 
{
    let linhas = [];
        
    for (let i = 0; i < largura; i++) 
    {
        let colunas = Array(altura);
        for (let j = 0; j < altura; j++) 
        {
            colunas[j] = { valor: Number.MAX_SAFE_INTEGER, cor: [0, 0, 0] }
        }
        linhas.push(colunas);
    }
    
    return linhas;
}

function aplicaZBuffer(origem, zBuffer, coords, cor) 
{
    for (let i = 0; i < coords.length; i++) 
    {
        let x = Math.round(coords[i].x + origem.x);
        let y = Math.round(origem.y - coords[i].y);
        if (zBuffer[x] != undefined && zBuffer[x][y] != undefined && coords[i].z < zBuffer[x][y].valor) 
        {
            zBuffer[x][y].valor = coords[i].z;
            zBuffer[x][y].cor = cor;
        }
    }    
}

function desenhaZBuffer(context, zBuffer, largura, altura) 
{
    for (let i = 0; i < largura; i++) {
        for (let j = 0; j < altura; j++) {
            let cor = zBuffer[i][j].cor;
            context.fillStyle = 'rgb(' + cor[0] + ',' + cor[1] + ',' + cor[2] + ')';
            context.fillRect(i, j, 1, 1);
        }
    }
}


function coordenadasObjetoAzul(x1, x2, y1, y2) 
{
    let aux = [];

    for(let i = x1; i < x2; i++)
    {
        for(let j = y1; j < y2; j++)
        {
            aux.push({x: i, y: j, z: (i*i) + j});
        }
    }

    return aux;
}

function coordenadasObjetoVermelho(x1, x2, y1, y2) 
{
    let aux = [];

    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({x: i, y: j, z: 3 * i - 2 * j + 5});
        }
    }
    
    return aux;
}

function coordenadasObjetoAmarelo(t1, t2, a1, a2) 
{
    let aux = [];
    let inc = 0.01;
    
    for (let a = a1; a <= a2; a += inc)
    {
        for (let t = t1; t <= t2; t += 1)
        {
            aux.push({x: Math.round(30 + t * Math.cos(a)), y: Math.round(50 + t * Math.sin(a)), z: Math.round(10 + t)});
        }
    }
    
    return aux;
}

function coordenadasObjetoVerde(a1, a2, b1, b2) 
{
    let aux = [];
    let inc = 0.01;
            
    for (let a = a1; a <= a2; a += inc)
    {
        for (let b = b1; b <= b2; b += inc)
        {
            aux.push({x: Math.round(100 + 30 * Math.cos(a) * Math.cos(b)), y: Math.round(50 + 30 * Math.cos(a) * Math.sin(b)), z: Math.round(20 + 30 * Math.sin(a))});
        }
    }
    
    return aux;
}
       
function coordenadasObjetoBranco(origem, lado) 
{
    let aux = [];
    let x1 = Math.round(origem - lado/2);
    let x2 = Math.round(origem + lado/2);
    let y1 = Math.round(origem - lado/2);
    let y2 = Math.round(origem + lado/2);
    let aux1 = Math.round(origem - lado/2);
    let aux2 = Math.round(origem + lado/2);

    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: i, y: j, z: aux1 });
        }
    }
    
    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: i, y: j, z: aux2 });
        }
    }
            
    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: i, y: aux1, z: j });
        }
    }

    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: i, y: aux2, z: j });
        }
    }

    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: aux1, y: i, z: j });
        }
    }
            
    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: aux2, y: i, z: j });
        }
    }
            
    return aux;
}


function coordenadasObjetos()
{
    let aux = [];
    //Objeto verde
    aux.push({ x: 0, y: 0, z: 0 });
    aux.push({ x: 20, y: 0, z: 0 });
    aux.push({ x: 0, y: 0, z: 80 });
    aux.push({ x: 20, y: 0, z: 80 });
    
    aux.push({ x: 0, y: 0, z: 0 });
    aux.push({ x: 0, y: 40, z: 0 });
    aux.push({ x: 0, y: 0, z: 80 });
    aux.push({ x: 0, y: 40, z: 80 });

    aux.push({ x: 0, y: 0, z: 80 });
    aux.push({ x: 20, y: 0, z: 80 });
    aux.push({ x: 0, y: 40, z: 80 });
    aux.push({ x: 20, y: 40, z: 80 });

    aux.push({ x: 0, y: 0, z: 0 });
    aux.push({ x: 20, y: 0, z: 0 });
    aux.push({ x: 0, y: 40, z: 0 });
    aux.push({ x: 20, y: 40, z: 0 });

    aux.push({ x: 0, y: 40, z: 0 });
    aux.push({ x: 20, y: 40, z: 0 });
    aux.push({ x: 0, y: 40, z: 80 });
    aux.push({ x: 20, y: 40, z: 80 });
    
    //Objeto vermelho
    aux.push({ x: 20, y: 0, z: 0 });
    aux.push({ x: 100, y: 0, z: 0 });
    aux.push({ x: 20, y: 40, z: 0 });
    aux.push({ x: 100, y: 40, z: 0 });

    //Objeto amarelo
    aux.push({ x: 20, y: 0, z: 0 });
    aux.push({ x: 20, y: 40, z: 0 });
    aux.push({ x: 20, y: 0, z: 80 });
    aux.push({ x: 20, y: 40, z: 80 });

    //Objeto azul
    aux.push({ x: 20, y: 0, z: 80 });
    aux.push({ x: 100, y: 0, z: 0 });
    aux.push({ x: 20, y: 40, z: 80 });
    aux.push({ x: 100, y: 40, z: 0 });

    //Objeto marrom
    aux.push({ x: 100, y: 0, z: 0 });
    aux.push({ x: 120, y: 0, z: 0 });
    aux.push({ x: 100, y: 40, z: 0 });
    aux.push({ x: 120, y: 40, z: 0 });

    return aux;
}

function interpolacao(p00, p10, p01, p11) 
{
    let aux = [];
    for (let u = 0; u <= 1; u += 0.002) {
        for (let v = 0; v <= 1; v += 0.002) {
            aux.push({
                x: (p00.x * (1 - u) * (1 - v) + p10.x * v * (1 - u) +
                    p01.x * (1 - v) * u + p11.x * u * v),
                y: (p00.y * (1 - u) * (1 - v) + p10.y * v * (1 - u) +
                    p01.y * (1 - v) * u + p11.y * u * v),
                z: (p00.z * (1 - u) * (1 - v) + p10.z * v * (1 - u) +
                    p01.z * (1 - v) * u + p11.z * u * v)
            });
        }
    }
    return aux;
}

function aplicaZBufferObjetos(origem, zBuffer, coords) 
{
    //Objeto verde
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[0], coords[1], coords[2], coords[3]), [0, 255, 0]);
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[4], coords[5], coords[6], coords[7]), [0, 255, 0]);
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[8], coords[9], coords[10], coords[11]), [0, 255, 0]);
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[12], coords[13], coords[14], coords[15]), [0, 255, 0]);
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[16], coords[17], coords[18], coords[19]), [0, 255, 0]);
    
    //Objeto vermelho
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[20], coords[21], coords[22], coords[23]), [255, 0, 0]);
    
    //Objeto amarelo
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[24], coords[25], coords[26], coords[27]), [255, 255, 0]);
    
    //Objeto azul
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[28], coords[29], coords[30], coords[31]), [0, 0, 255]);

    //Objeto marrom
    aplicaZBuffer(origem, zBuffer, interpolacao(coords[32], coords[33], coords[34], coords[35]), [160, 80, 0]);
}

function rotacaoX(coords, ang) 
{
    for (let i = 0; i < coords.length; i++) 
        coords[i] = {x: coords[i].x, y: Math.round(coords[i].y * Math.cos(ang) + coords[i].z * Math.sin(ang)), z: Math.round(-coords[i].y * Math.sin(ang) + coords[i].z * Math.cos(ang))};
}

function rotacaoY(coords, ang) 
{
    for (let i = 0; i < coords.length; i++) 
        coords[i] = {x: Math.round(coords[i].x * Math.cos(ang) - coords[i].z * Math.sin(ang)), y: coords[i].y, z: Math.round(coords[i].x * Math.sin(ang) + coords[i].z * Math.cos(ang))};
}

function rotacaoZ(coords, ang) 
{
    for (let i = 0; i < coords.length; i++)
        coords[i] = {x: Math.round(coords[i].x * Math.cos(ang) + coords[i].y * Math.sin(ang)), y: Math.round(-coords[i].x * Math.sin(ang) + coords[i].y * Math.cos(ang)), z: coords[i].z};
}


function aplicarVarredura(coords, circleCoords, eixo)
{
    for(let i = 0; i < coords.length; i++)
    {
        let raio = Math.abs(coords[i].x - eixo);
        let x = 0;
        let z = raio;
        let d = 3 - (2 * raio);

        while(x <= z)
        {
            if(d < 0)
            {
                d += (4 * x) + 6;
            }
            else
            {
                d += 4 * (x - z) + 10;
                z--;
            }
            x++;
            circleCoords.push({x: x, y: coords[i].y, z: z});
            circleCoords.push({x: z, y: coords[i].y, z: x});
            circleCoords.push({x: -x, y: coords[i].y, z: z});
            circleCoords.push({x: -z, y: coords[i].y, z: x});
            circleCoords.push({x: -x, y: coords[i].y, z: -z});
            circleCoords.push({x: -z, y: coords[i].y, z: -x});
            circleCoords.push({x: x, y: coords[i].y, z: -z});
            circleCoords.push({x: z, y: coords[i].y, z: -x});
        }
    }
}

function desenhaVarredura(coords, context, color, offset)
{
    for(let i = 0; i < coords.length; i++)
    {
        context.fillStyle = color;
        context.fillRect(coords[i].x + offset, coords[i].y, 1, 1);
    }
}

function Cavaleira(coord) 
{
    let aux = [];

    for (let i = 0; i < coord.length; i++) 
        aux.push({x: coord[i].x + coord[i].z * Math.cos(45 * Math.PI/180), y: coord[i].y + coord[i].z * Math.sin(45 * Math.PI/180), z: 0});
    
    return aux;
}


function coordenadasEsfera(origem, raio) 
{
    let aux = [];
    let inc = 0.01;
            
    for (let a = 0; a <= 2 * Math.PI; a += inc)
    {
        for (let b = 0; b <= 2 * Math.PI; b += inc)
        {
            aux.push({x: Math.round(origem + raio * Math.cos(a) * Math.cos(b)), y: Math.round(origem + raio * Math.cos(a) * Math.sin(b)), z: Math.round(origem + raio * Math.sin(a))});
        }
    }
    
    return aux;
}

function coordenadasPlano(x1, x2, y1, y2) 
{
    let aux = [];

    for (let i = x1; i < x2; i++)
    {
        for (let j = y1; j < y2; j++)
        {
            aux.push({ x: i, y: j, z: 0 });
        }
    }
            
    return aux;
}

function produtoEscalar(v1, v2) 
{
    var result = 0;

    for (var i = 0; i < 3; i++)
        result += v1[i] * v2[i];
    
    return result;
}

function norma(v1)
{
    var result = 0;

    for (var i = 0; i < 3; i++)
        result += v1[i] * v1[i];
    
    return Math.sqrt(result);
}

function distancia(p1, p2)
{
    var result = 0;

    for (var i = 0; i < 3; i++)
        result += Math.pow(p1[i] - p2[i], 2);
    
    return Math.sqrt(result);
}

function aplicaModeloDeIluminacao1(coords, Ia, Ka, Il, Kd, tipo, luz = [100, 0, 100], origem, zBuffer, cor)
{
    let I = 0;
    let normal = [0, 0, 0];

    for(let i = 0; i < coords.length; i++)
    {
        if(tipo == 'plano')
            normal = [coords[i].x, coords[i].y, 1];
        else if(tipo == 'esfera')
            normal = [coords[i].x, coords[i].y, coords[i].z];

        cosAng = produtoEscalar(normal, luz)/(norma(normal)*norma(luz));

        I = Ia*Ka + Il*Kd*cosAng;

        let x = Math.round(coords[i].x + origem.x);
        let y = Math.round(origem.y - coords[i].y);
        if (zBuffer[x] != undefined && zBuffer[x][y] != undefined && coords[i].z < zBuffer[x][y].valor) 
        {
            zBuffer[x][y].valor = coords[i].z;
            zBuffer[x][y].cor = cor.map(canal => canal * I);;
        }
    }  
}

function aplicaModeloDeIluminacao2(coords, Ia, Ka, Il, Kd, k, Ks, n, tipo, luz = [100, 0, 100], observador = [0, 0, 100], origem, zBuffer, cor)
{
    let I = 0;
    let normal = [0, 0, 0];
    let alfa = 0;
    let d = 0;

    for(let i = 0; i < coords.length; i++)
    {
        if(tipo == 'plano')
            normal = [coords[i].x, coords[i].y, 1];
        else if(tipo == 'esfera')
            normal = [coords[i].x, coords[i].y, coords[i].z];

        cosAng = produtoEscalar(normal, luz)/(norma(normal)*norma(luz));
        alfa = Math.acos(produtoEscalar(observador, luz)/(norma(observador)*norma(luz))) - 2*Math.acos(cosAng);
        cosAlfa = Math.cos(alfa);
        
        d = distancia([coords[i].x, coords[i].y, coords[i].z], luz);

        I = Ia*Ka + (Il/(d+k))*(Kd*cosAng + Ks*Math.pow(cosAlfa, n));

        let x = Math.round(coords[i].x + origem.x);
        let y = Math.round(origem.y - coords[i].y);
        if (zBuffer[x] != undefined && zBuffer[x][y] != undefined && coords[i].z < zBuffer[x][y].valor) 
        {
            zBuffer[x][y].valor = coords[i].z;
            zBuffer[x][y].cor = cor.map(canal => canal * I);;
        }
    }
}