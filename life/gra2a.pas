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

procedure nowe_pole(var aktualny : wiersz; x : longInt; var kol : kolumna);
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
		komorka.x:=x;
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
procedure przetworz_wiersz(var plansza : kolumna; var gdzie : longInt; start : wiersz; zywy : boolean);
begin
    while(start^.nast <> nil) and (start^.komorka.x < gdzie) do start:=start^.nast; {lewo}
		{writeln(start^.komorka.w,' cos ', start^.komorka.x);}
	if start^.komorka.x = gdzie-1 then begin
		if start^.komorka.w > 0 then Inc(start^.komorka.w)
		else Dec(start^.komorka.w);
		if start^.nast=nil then nowe_pole(start,gdzie-1,plansza)
		else start:=start^.nast;
	end
	else begin
		nowe_pole(start,gdzie-1,plansza);
		Dec(start^.komorka.w);
	end;
		{writeln(start^.komorka.w,' cos ', start^.komorka.x);}
    writeln(plansza^.nr,': ', start^.komorka.x,'= ',start^.komorka.w);
		
	if start^.komorka.x = gdzie then begin								{srodek}
		if zywy then begin
			if start^.komorka.w < 0 then start^.komorka.w:=((start^.komorka.w)*-1)+1
			else Inc(start^.komorka.w);
		end
		else begin
			if start^.komorka.w > 0 then Inc(start^.komorka.w)
		    else Dec(start^.komorka.w);
            if (start^.komorka.w < 0) and zywy then start^.komorka.w := -start^.komorka.w;
		end;
		if start^.nast=nil then nowe_pole(start,gdzie,plansza)
		else start:=start^.nast;
	end
	else begin
		nowe_pole(start,gdzie,plansza);
		if zywy then Inc(start^.komorka.w)
		else Dec(start^.komorka.w);
	end;
    writeln(plansza^.nr,': ', start^.komorka.x,'= ',start^.komorka.w);
	
			{writeln(start^.komorka.w,' cos ', start^.komorka.x);}
			
	if start^.komorka.x = gdzie+1 then begin
		if start^.komorka.w > 0 then Inc(start^.komorka.w)
		else Dec(start^.komorka.w);
		if start^.nast=nil then nowe_pole(start,gdzie+1,plansza)
		else start:=start^.nast;
	end
	else begin
		nowe_pole(start,gdzie+1,plansza);
		Dec(start^.komorka.w);
	end;
    writeln(plansza^.nr,': ', start^.komorka.x,'= ',start^.komorka.w);
end;

procedure policznastepna(var k : kolumna);
var wynik, pom : kolumna;
    k1,k2,k3,czytanie: kolumna;
    czytpunkt : wiersz;
    pierwszy : boolean;
begin
    new(wynik);
    wynik^.poprz:=nil;
    wynik^.nast := nil;
    wynik^.nr := -MAXLONGINT;
    czytanie := k^.nast;
    while (czytanie <> nil) do begin
        czytpunkt := czytanie^.stan^.nast;
        pierwszy := true;
        while (czytpunkt <> nil) do begin
            if (czytpunkt^.komorka.w = 3) or
               (czytpunkt^.komorka.w = 4) or
               (czytpunkt^.komorka.w =-3) then begin
                if pierwszy then begin
                    pierwszy := false;
                    k2 := wynik;
                    while (k2^.nr<czytanie^.nr) and (k2^.nast<>nil) do k2:=k2^.nast;
                    if k2^.nr <> czytanie^.nr then begin
                        nowy_wiersz(k2^.nr,czytanie^.poprz,pom);
                        k2 := czytanie^.poprz;
                        k2^.nr := czytanie^.nr;
                    end;
                    if (k2^.poprz^.nr <> k2^.nr-1) then begin
                        nowy_wiersz(k2^.nr-1,k2^.poprz,pom);
                        k2^.poprz^.nr := k2^.nr-1;
                    end;
					
                    k1 := k2^.poprz;
                    if (k2^.nast^.nr <> k2^.nr+1) or (k2^.nast=nil) then begin
                        nowy_wiersz(k2^.nr+1,k2,pom);
                        k2^.nast^.nr:=k2^.nr+1;
                    end;
                    k3:=k2^.nast;
                end;
                przetworz_wiersz (k1,czytpunkt^.komorka.x,k1^.stan,false);
                przetworz_wiersz (k2,czytpunkt^.komorka.x,k2^.stan,true);
                przetworz_wiersz (k3,czytpunkt^.komorka.x,k3^.stan,false);
            end;
            czytpunkt:=czytpunkt^.nast;
        end;
        czytanie:=czytanie^.nast;
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
					if not byl then begin
						byl:=true;						
						while (plansza^.nr<kol_kon) and (plansza^.nast<>nil) do plansza:=plansza^.nast;
						if plansza^.nr <> kol_kon then nowy_wiersz(kol_kon,plansza,pom);
						punkt2:=plansza^.stan;
						if plansza^.poprz^.nr <> kol_kon-1 then	begin
							nowy_wiersz(kol_kon-1,plansza^.poprz,pom);
							punkt:=plansza^.stan;
						end;

						nowy_wiersz(kol_kon+1,plansza^.poprz,pom);
						punkt3:=plansza^.stan;
						plansza:=plansza^.poprz;

					end;
					przetworz_wiersz(plansza^.poprz^.poprz,kol_kon,punkt,false);
					przetworz_wiersz(plansza^.poprz,kol_kon,punkt2,true);
					przetworz_wiersz(plansza,kol_kon,punkt3,false);
				end;
			end;
			readln();
			
			if eoln then begin
				is:=true;
				wypisz_plansze(pom,plansza,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon);
				plansza:=pom;
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
			end;
		end
		else begin {wczytuje polecenia}
			if eoln then begin
			{	policznastepna;}
				wypisz_plansze(pom,plansza,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon);
			end
			else begin
				read(wiersz_pocz);
				if eoln then begin
					{for i:=1 to N do policznastepna;}
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