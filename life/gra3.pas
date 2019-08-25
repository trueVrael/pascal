program Gra;

var N,wiersz_pocz,wiersz_kon,kol_pocz,kol_kon,x,i : longInt;
var znak,a : char;
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

var kw : wiersz;
procedure stworz (war : integer; poz : integer; var pop : wiersz; var na : wiersz);
begin
	new (kw);
	na^.poprz := kw;
	pop^.nast := kw;
	kw^.komorka.x := poz;
	kw^.komorka.w := war;
end;

(* wstawia element na liste albo dodaje 1 do starego *)
procedure wstaw (var p : wiersz;  poz : integer);
begin
	if (p^.poprz = nil)  or (p^.poprz^.komorka.x < poz) then
	begin
		stworz (11, poz-1,p^.poprz, p);
	end else
	begin
		Inc(p^.poprz^.komorka.w);
	end;
end;

procedure zaznacz (var p : wiersz; var poz : integer);
begin
	wstaw (p, poz - 1);
	wstaw (p, poz);
	wstaw (p, poz + 1);
end;

function przewin (var p : wiersz; var poz : integer): wiersz;
begin
	while (p <> nil) and (p^.komorka.x < poz) do
	begin
		p := p^.nast;
	end;
	przewin := p;
end;

var kCur, k: kolumna;
var pozX, pozY : integer;
var pU, pD, cur : wiersz;
(* stworzenie pustej kolumny nad obecna *)

begin
	read(a);
	while (a = '.' or a = '0') 
new (k);
new (kCur);
kCur^.poprz = k;
	pozY := 0;
	Inc (pozY);
	read(a);
	(* nowa kolumna *)
	new(k);
	k^.nr = pozY;
	k^.poprz = kCur;
	kCur.nast = k;
	
	pU := kCur^.poprz^.stan;
	pD := kCur^.nast^.stan;
	poz = 0;
	while a <> eoln
	begin
		Inc (pozX);
		if a = 0 then 
		begin
			pU = przewin (pU, pozX);
			pD = przewin (pD, pozX);
			wstaw (cur, pozX);
			wstaw (cur, pozX - 1);
			zaznacz (pU, pozX);
			zaznacz (pD, pozX);
		end
		a = read();
	end
	a = read();
end
			
			
