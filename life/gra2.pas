program Gra;

var N,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon,x,i : longInt;
var znak : char;
var is,byl,szukaj: boolean;

type pole=record
			x : LongInt;
			w : integer;
end;

type wiersz=^elemwiersz;
elemwiersz=record	{struktura zawieraj¹ca potrzebne komorki w danym wierszu}
			komorka : pole;
			poprz, nast : wiersz;
end;

var punkt, punkt2, punkt3,p : wiersz;

type kolumna=^elemkolumna;
elemkolumna=record		{struktura odzwierciedlaj¹ca wiersze planszy}
			nr : longInt;
			poprz, nast : kolumna;
			stan : wiersz;
end;			

var plansza, pom :kolumna;

{wydluzenie kolumny (dodanie wiersza}
procedure nowy_wiersz(numer : longInt; var aktualny,pom : kolumna);
var poprzedni, nastepny : kolumna;
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
		nr:=numer;
		new(p);
		stan:=p;
		stan^.komorka.x:=-MAXLONGINT;
		stan^.nast:=nil;
		stan^.poprz:=nil;
		nast:=nastepny;
	end;	
	if poprzedni <> nil then poprzedni^.nast:=aktualny
	else 	pom:=aktualny;
	if nastepny <> nil then nastepny^.poprz:=aktualny;
end;

procedure nowe_pole(var aktualny : wiersz; il : longInt; var kol : kolumna);
var poprzedni, nastepny : wiersz;
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
		komorka.x:=il;
		komorka.w:=0;
		nast:=nastepny;
	end;
	if poprzedni <> nil then poprzedni^.nast:=aktualny
	else begin
		kol^.stan:=aktualny;
	end;
	if nastepny <> nil then nastepny^.poprz:=aktualny;
end;
{procedure wykonaj_ruch(var k : kolumna);
var wynik, pom,k1,k2,k3,czytanie : kolumna
var czyt_punkt : wiersz;
var pierwszy : boolean'
begin
	wynik^.poprz:=nil;
	wynik^.nast:=nil;
	wynik^.nr= -MAXLONGINT;
	czytanie:=k^nast;
	while czytanie <> nil do begin
		czyt_punkt:= czytanie^.stan^.nast;
		pierwszy:=true;
		while czyt_punkt <> nil do begin
			if (czyt_punkt^.komorka^.w = 3) or (czyt_punkt^.komorka^.w = 4) or (czyt_punkt^.komorka^.w = -3) then begin
				if pierwszy then begin
					pierwszy:=false;
					k2:=wynik;
					while (k2^.nr <czytanie^.nr) and (k2^.nast<>nil) do k2:=k2^.nast;
					if k2^.stan <> czytanie^.stan then begin
						nowy_wiersz(czytanie^.poprz,pom);
end;}

{wypisuje plansze. NIE RUSZAC BO NOGI Z D POWYRYWAM !!!!!!!!!DZIALA!!!!!!!!!!!!!}
procedure wypisz_plansze(var pom,plansza : kolumna; var wiersz_pocz,wiersz_kon,kol_pocz,kol_kon : longInt);
var znajdz : boolean;
var s : wiersz;
var j : longInt;
begin
	plansza:=pom;
	for i:=wiersz_pocz to wiersz_kon do begin
		znajdz:=true;
		if plansza = nil then znajdz:=false	
		else while (plansza<>nil) and (znajdz) do begin
			if plansza^.nr>=i then znajdz:=false
			else plansza:=plansza^.nast;
		end;
		if plansza = nil then begin
			for j:=kol_pocz to kol_kon do write('.');
		end
		else if plansza^.nr <> i then begin
			for j:=kol_pocz to kol_kon do write('.');
		end
		else begin
			s:=plansza^.stan;
			for j:=kol_pocz to kol_kon do begin
				znajdz:=true;
				while (s<>nil) and (znajdz) do begin
					if s^.komorka.x>=j then znajdz:=false
					else s:=s^.nast;
				end;
				if s = nil then write('.')
				else if s^.komorka.x>j then write('.')
				else begin
					if	s^.komorka.w>0 then begin 
						write('0');
					end
					else write('.');
					s:=s^.nast;
				end;
			end;
		end;
		if plansza <> nil then if plansza^.nr < i then plansza:=plansza^.nast;
		writeln();
	end;
	writeln();
	plansza:=pom;
end;
procedure przetworz_wiersz(var plansza : kolumna; var gdzie : longInt; var start : wiersz; zywy : boolean);
begin
	while(start^.nast <> nil) and (start^.komorka.x < gdzie) do start:=start^.nast; {lewo}
	writeln(start^.komorka.x, ' vdfffffffaddddddddddddddddddd');
	if start^.komorka.x = gdzie then begin
		if zywy then begin
			if start^.komorka.w < 0 then start^.komorka.w:=((start^.komorka.w)*-1)+1
			else Inc(start^.komorka.w);
			writeln('bylem', start^.komorka.w);
		end
		else begin
			if start^.komorka.w > 0 then Inc(start^.komorka.w)
		    else Dec(start^.komorka.w);
		end;
		if (start^.poprz=nil) then begin
			nowe_pole(start^.poprz,gdzie-1,plansza);
			Dec(start^.komorka.x);
			start:=start^.nast;
		end
		else if start^.poprz^.komorka.x<> gdzie-1 then begin
			nowe_pole(start^.poprz,gdzie-1,plansza);
			Dec(start^.komorka.x);
			start:=start^.nast;
		end
		else begin
			Dec(start^.poprz^.komorka.x);
		end;
		
		
		if (start^.nast=nil) then begin
			nowe_pole(start^.nast,gdzie+1,plansza);
			Dec(start^.komorka.x);
		end
		else if start^.nast^.komorka.x<> gdzie+1 then begin
			nowe_pole(start^.nast,gdzie-1,plansza);
			Dec(start^.komorka.x);
		end
		else begin
			Dec(start^.nast^.komorka.x);
		end
	end
	else begin
		nowe_pole(start,gdzie,plansza);
		if zywy then Inc(start^.komorka.w)
		else Dec(start^.komorka.w);
	end;
	
end;

begin
	wiersz_pocz:=1;
	kol_pocz:=1;
	wiersz_kon:=0;
	kol_kon:=0;
	is:=false;
	{zrob atrape}
	new(plansza);
	new(pom);
	new(p);
	pom^.nr:=-MAXLONGINT;
	pom^.nast:=nil;
	pom^.poprz:=nil;
	pom^.stan:=p;
	pom^.stan^.komorka.x:=-MAXLONGINT;
	plansza:=pom;
	while not eof do begin
		if not is then begin
			Inc(wiersz_kon);
			kol_kon:=0;
			byl:=false;
			while not eoln do begin
				Inc(kol_kon);
				read(znak);
				if znak='0' then begin
					writeln('cos',wiersz_kon);
					if not byl then begin
						szukaj:=true;
						byl:=true;
						while szukaj do begin
							if plansza^.nast = nil then	szukaj:=false
							else if plansza^.nr>=wiersz_kon-1 then szukaj := false
							else plansza:=plansza^.nast;
						end;
						writeln(wiersz_kon,plansza^.nr);
						if plansza^.nr < wiersz_kon-1 then	begin
							nowy_wiersz(wiersz_kon-1,plansza,pom);
						end;
						punkt:=plansza^.stan;
						
						if plansza^.nr < wiersz_kon then nowy_wiersz(wiersz_kon,plansza,pom);
						{else if plansza^.nast^.nr = wiersz_kon then plansza:=plansza^.nast
						else nowy_wiersz(wiersz_kon,plansza,pom);}
						punkt2:=plansza^.stan;
						
						if plansza^.nr <wiersz_kon+1 then nowy_wiersz(wiersz_kon+1,plansza,pom);
						{else if plansza^.nast^.nr = wiersz_kon+1 then plansza:=plansza^.nast
						else nowy_wiersz(wiersz_kon+1,plansza,pom);}
						punkt3:=plansza^.stan;
					end;
					przetworz_wiersz(plansza^.poprz^.poprz,kol_kon,punkt,false);
					writeln(' tyutaj');
					przetworz_wiersz(plansza^.poprz,kol_kon,punkt2,true);
					writeln('dsfds');
					przetworz_wiersz(plansza,kol_kon,punkt3,false);
				end;
				
			end;
			readln();
			if eoln then begin
				is:=true;
				plansza:=pom;
				plansza:=plansza^.nast;
				while plansza <>nil do begin
					p:=plansza^.stan;
					write(plansza^.nr,': ');
					while p<>nil do begin
						write(p^.komorka.w,' ');
						p:=p^.nast;
					end;
					writeln();
					plansza:=plansza^.nast;
				end;
				plansza:=pom;
				wypisz_plansze(pom,plansza,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon);
			end;
			
		end
		else begin {wczytuje polecenia}
			if eoln then begin
			{	wykonaj_ruch();}
				wypisz_plansze(pom,plansza,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon);
			end
			else begin
				read(wiersz_pocz);
				if eoln then begin
					writeln('nie umiem');
					{for i:=1 to N do wykonaj_ruch();}
				end
				else begin
					read(wiersz_kon);read(kol_pocz);read(kol_kon);
					wypisz_plansze(pom,plansza,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon)
				end;
			end;
			readln();
		end;
	end;
end.