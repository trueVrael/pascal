program Gra;

var N,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon,x,i : longInt;
var znak : char;
var is,zywy: boolean;

type pole=^elempole;
elempole=record {struktura zawieraj¹ca potrzebne komorki w danym wierszu}
   x: integer;
   w: integer;
   poprz, nast : pole;
end;

var p1,p2,p3,p : pole;

type wiersz=^elemwiersz;
elemwiersz=record  {struktura odzwierciedlaj¹ca wiersze planszy}
   y : longInt;
   pola : pole;
   poprz, nast : wiersz;
end;

var atrapa, plansza,pom,w1,w2,w3 : wiersz;


procedure nowe_pole(var aktualny : pole; x : longInt; var zywy : boolean);
var poprzedni, nastepny : pole;
begin
	if aktualny<> nil then begin
		poprzedni:=aktualny;
		nastepny:=aktualny^.nast;
	end
	else begin
		poprzedni:=nil;
		nastepny:=nil;
	end;
	new(aktualny);
	with aktualny^ do begin
		poprz:=poprzedni;
		x:=x;
		w:=0;
		nast:=nastepny;
	end;
	if poprzedni <> nil then poprzedni^.nast:=aktualny;
	if nastepny <> nil then nastepny^.poprz:=aktualny;
end;

procedure znajdz_punkt(var pion : pole;  gdzie : longint;  zywyw : boolean);
begin
	while (pion^.nast <> nil) and (pion^.x < gdzie) do pion:=pion^.nast;
	if pion^.x <> gdzie then nowe_pole(pion, gdzie, zywy);
	
	if zywy then begin
		if pion^.w < 0 then pion^.w:= -(pion^.w)+1
		else Inc(pion^.w);
	end
	else begin
		if pion^.w<0 then Dec(pion^.w)
		else Inc(pion^.w);
	end;
end;

procedure nowy_wiersz(numer : longInt; var aktualny,pom : wiersz);
var poprzedni, nastepny : wiersz;
begin
	if aktualny<>nil then begin
		poprzedni:=aktualny;
		nastepny:=aktualny^.nast;
	end
	else begin
		poprzedni:=nil;
		nastepny:=nil
	end;
	new(aktualny);
	with aktualny^ do begin
		poprz:=poprzedni;
		y:=numer;
		new(p);
		pola:=p;
		pola^.x:=-MAXLONGINT;
		pola^.nast:=nil;
		pola^.poprz:=nil;
		nast:=nastepny;
	end;	
	if poprzedni <> nil then poprzedni^.nast:=aktualny
	else 	pom:=aktualny;
	if nastepny <> nil then nastepny^.poprz:=aktualny;
end;


procedure znajdz_wiersz(var plansza : wiersz;  indeks : longInt);
begin
	while (plansza^.nast <> nil) and (plansza^.nast^.y < indeks+1) do plansza:=plansza^.nast;
	if plansza^.y <> indeks then nowy_wiersz(indeks, plansza, pom);	
end;

procedure ustaw_punkt(var pion : pole; var gdzie : longint;  zywyw : boolean);
begin
		znajdz_punkt(pion,gdzie-1,false);		
		znajdz_punkt(pion,gdzie,true);
		znajdz_punkt(pion,gdzie+1,false);
end;


procedure wczytaj_plansze(var plansza : wiersz; var w,k: longInt);
var i, j : longInt;
var znak : char;
var pierwszy : boolean;
begin
	i:=0;
	while not eoln do begin
		Inc(i);
		j:=0;
		pierwszy:=true;
		while not eoln do begin
			Inc(j);
			read(znak);
			if znak = '0' then begin
				if pierwszy then begin
					pierwszy:=false;
					znajdz_wiersz(plansza,i);
					p1:=plansza^.pola;
					znajdz_wiersz(plansza,i+1);
					p2:=plansza^.pola;
					znajdz_wiersz(plansza,i+2);
					p3:=plansza^.pola;
				end;
				ustaw_punkt(p1,j,false);
				ustaw_punkt(p2,j,true);
				ustaw_punkt(p3,j,false);
			end;
		end;
		readln();
	end;
	w:=i;
	k:=j;
end;

begin
	wiersz_pocz:=1;
	kol_pocz:=1;
	wiersz_kon:=0;
	kol_kon:=0;
	is:=false;
	{zrob atrape}
	new(plansza);
	new(atrapa);
	
	atrapa^.y:=-MAXLONGINT;
	atrapa^.nast:=nil;
	plansza:=atrapa;
	pom:=plansza;
	wczytaj_plansze(plansza, kol_kon, wiersz_kon);
	plansza:=pom;
	while plansza <>nil do begin
					p:=plansza^.pola;
					write(plansza^.y,': ');
					while p<>nil do begin
						write(p^.w,' ');
						p:=p^.nast;
					end;
					writeln();
					plansza:=plansza^.nast;
				end;
end.