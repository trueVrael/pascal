{Program symulujacy auromat komorkowy "Gry w zycie".}
{Patryk Chmielewski, 20.01.2013}

program conway;

type 
    PMapa = ^Mapa;
    PLinia = ^Linia;
    PPunkt = ^Punkt;
    Mapa = record
        pocz, akt: PLinia
    end;
    Linia = record
        x: LongInt;
        pocz, akt: PPunkt;
        nast: PLinia
    end;
    Punkt = record
        x: LongInt;
        sas: ShortInt;
        nast: PPunkt
    end;

{Dodaje nowego sasiada podzczas zliczania. Licznik dla komorki}
{uwzglednia sama siebie. Wartosc ujemna oznacza, ze komorka jest martwa}
procedure inkrementAbs(var x: ShortInt; ozyw: Boolean);
begin
    if ozyw then
        x := -x+1
    else if x>0 then
        x := x+1
    else
        x := x-1
end;

{Inicjalizuje nowa mape (liste linii), razem z atrapa linii}
procedure nowaMapa(var m: PMapa);
var atrapa: PLinia;
begin
    new(m);
    new(atrapa);
    
    atrapa^.x := -MAXLONGINT;
    atrapa^.nast := nil;
    m^.pocz:= atrapa;
    m^.akt := atrapa
end;

{Inicjalizuje nowa linie, razem z atrapa punktu}
procedure nowaLinia(var l: PLinia; a: LongInt);
var nowa: PLinia;
    atrapa: PPunkt;
begin
    new(nowa);
    new(atrapa);
    
    nowa^.nast := l^.nast;
    l^.nast := nowa;
    
    atrapa^.x := -MAXLONGINT;
    atrapa^.nast := nil;
    nowa^.x := a;
    nowa^.pocz:= atrapa;
    nowa^.akt := atrapa
end;

{Tworzy nowy punkt w linii}
procedure nowyPunkt(var p: PPunkt; a: LongInt);
var nowy: PPunkt;
begin
    new(nowy);
    
    nowy^.nast := p^.nast;
    p^.nast := nowy;
        
    nowy^.x := a;
    nowy^.sas := 0
end;

{Znajduje linie o danej wspolrzednej w mapie lub tworzy brakujaca}
procedure znajdzWMapie(var l: PLinia; i: LongInt);
var szukanie: Boolean;
begin
    szukanie := true;
    while szukanie do
        if l^.nast = nil then
            szukanie := false
        else if l^.nast^.x >= i+1 then
            szukanie := false
        else
            l := l^.nast;
    
    if l^.x <> i then begin
        nowaLinia(l,i);
        l := l^.nast
    end;
    
    l^.akt := l^.pocz
end;

{Znajduje punkt o danej wspolrzednej w linii lub tworzy brakujacy}
procedure znajdzWLinii(var p: PPunkt; i: LongInt);
var szukanie: Boolean;
begin
    szukanie := true;
    while szukanie do
        if p^.nast = nil then
            szukanie := false
        else if p^.nast^.x >= i+1 then
            szukanie := false
        else
            p := p^.nast;
    
    if p^.x <> i then begin
        nowyPunkt(p,i);
        p := p^.nast
    end
end;

{Ustawia wskazniki do nowych linii}
procedure resetujWskazniki(var l: PLinia; i: LongInt);
var ost: PLinia;
begin
    znajdzWMapie(l,i-1);
    ost := l;
    znajdzWMapie(ost,i);
    znajdzWMapie(ost,i+1)
end;

{Odnotowuje nowego sasiada w trzech najblizszych komorkach}
procedure stawiajKomorke(var p: PPunkt; i: LongInt; ozyw: Boolean);
var ost: PPunkt;
begin
    znajdzWLinii(p,i-1);
    inkrementAbs(p^.sas,false);
    znajdzWLinii(p,i);
    inkrementAbs(p^.sas,ozyw);
    ost := p;
    znajdzWLinii(ost,i+1);
    inkrementAbs(ost^.sas,false)
end;

{Odczytuje mape ze standardowego wejscia i buduje mape sasiedztw}
procedure czytajMape(var m: PMapa; var w,k: LongInt);
var i,j: LongInt;
    c: Char;
    bylpunkt: Boolean;
begin
    i := 0;
    while not eoln do begin
        i := i+1;
        j := 0; bylpunkt := false;
        while not eoln do begin
            j := j+1;
            read(c);
            if c = '0' then begin
                if not bylpunkt then begin
                    resetujWskazniki(m^.akt, i);
                    bylpunkt := true
                end;
                stawiajKomorke(m^.akt^.akt, j, false);
                stawiajKomorke(m^.akt^.nast^.akt, j, true);
                stawiajKomorke(m^.akt^.nast^.nast^.akt, j, false)
            end
        end;
        readln()
    end;
    w := i; k := j
end;
{Odczytuje zywe komorki z mapy sasiedztw i wylicza nastepny etap}
procedure liczMape(var m: PMapa; zrodlo: PMapa);
var i,j: LongInt;
    lin: PLinia; pkt: PPunkt;
    bylpunkt: Boolean;
begin
    lin := zrodlo^.pocz^.nast;
    while lin <> nil do begin
        pkt := lin^.pocz^.nast;
        i := lin^.x;
        bylpunkt := false;
        while pkt <> nil do begin
            j := pkt^.x;
            if (pkt^.sas = 3) or (pkt^.sas = 4) or (pkt^.sas = -3) then begin
                if not bylpunkt then begin
                    resetujWskazniki(m^.akt, i);
                    bylpunkt := true
                end;
                stawiajKomorke(m^.akt^.akt, j, false);
                stawiajKomorke(m^.akt^.nast^.akt, j, true);
                stawiajKomorke(m^.akt^.nast^.nast^.akt, j, false)
            end;
            pkt := pkt^.nast
        end;
        lin := lin^.nast
    end
end;

{Usuwa wszystkie komorki z mapy, pozostawiajac atrape}
procedure resetujMape(var m: PMapa);
var lin, tl: PLinia;
    pkt, tp: PPunkt;
begin
    lin := m^.pocz^.nast;
    while lin <> nil do begin
        pkt := lin^.pocz;
        while pkt <> nil do begin
            tp := pkt;
            pkt := pkt^.nast;
            dispose(tp)
        end;
        tl := lin;
        lin := lin^.nast;
        dispose(tl)
    end;
    m^.akt := m^.pocz;
    m^.pocz^.nast := nil
end;

{Zwalnia calkowicie pamiec zajmowana przez mape}
procedure niszcz(var m: PMapa);
begin
    resetujMape(m);
    dispose(m^.pocz);
    dispose(m)
end;

{Oblicza kolejny etap symulacji i zapisuje go w miejscu poprzedniego}
procedure generuj(var m: PMapa; n: LongInt);
var i: LongInt;
    t,a: PMapa;
begin
    nowaMapa(t);
    for i:=1 to n do begin
        liczMape(t,m);
        resetujMape(m);
        a := m;
        m := t;
        t := a;
    end;
    niszcz(t)
end;

{Wypisuje komorki w podanym zakresie}
procedure piszMape(m: PMapa; i1,i2,j1,j2: LongInt);
var lin: PLinia;
    pkt: PPunkt;
    i,j: LongInt;
    szukanie: Boolean;
begin
    lin := m^.pocz^.nast;

    for i := i1 to i2 do begin
        szukanie := true;
        if lin = nil then
            szukanie := false
        else while (lin <> nil) and szukanie do begin
            if lin^.x >= i then
                szukanie := false
            else
                lin := lin^.nast
        end;    
        if lin = nil then begin
            for j := j1 to j2 do
                write('.')
        end else begin
            pkt := lin^.pocz^.nast;
            for j := j1 to j2 do begin
                szukanie := true;
                while (pkt <> nil) and szukanie do begin
                    if pkt^.x >= j then
                        szukanie := false
                    else
                        pkt := pkt^.nast
                end;
                if pkt = nil then
                    write('.')
                else if pkt^.x > j then
                    write('.')
                else begin
                    if pkt^.sas > 0 then
                        write('0')
                    else
                        write('.');
                    pkt := pkt^.nast
                end
            end
        end;
        if lin <> nil then if lin^.x < i then
            lin := lin^.nast;
        writeln()
    end;
    writeln()
end;
{****************************************************************}
var biezaca: PMapa;
    w1,w2,k1,k2: LongInt;
    wej: LongInt;
begin
    nowaMapa(biezaca);
    w1 := 1; k1 := 1;
    
    czytajMape(biezaca, w2, k2);
    piszMape(biezaca,w1,w2,k1,k2);
    while not eof do begin
        if eoln then {pusta linia}
            generuj(biezaca,1)
        else begin
            read(wej);
            if eoln then {jedna liczba}
                generuj(biezaca,wej)
            else begin{cztery liczby}
                w1 := wej; read(w2); read(k1); read(k2)
            end
        end;
        piszMape(biezaca,w1,w2,k1,k2);
        readln()
    end;
    
    niszcz(biezaca)
end.