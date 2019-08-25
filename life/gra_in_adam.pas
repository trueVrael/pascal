program Gra;
type pole=record
			x : LongInt;
			w : integer;
end;

type wiersz=^elemwiersz;
elemwiersz=record	{struktura zawieraj¹ca potrzebne komorki w danym wierszu}
			komorka : pole;
			poprz, nast : wiersz;
end;


type kolumna=^elemkolumna;
elemkolumna=record		{struktura odzwierciedlaj¹ca wiersze planszy}
			nr : longInt;
			poprz, nast : kolumna;
			stan : wiersz;
end;

var kw,p : wiersz;
procedure stworz (war : integer; poz : integer; pop : wiersz; na : wiersz);
begin
	new (kw);
	if na <> nil then begin na^.poprz := kw; end;
	if pop <> nil then begin pop^.nast := kw; end;
	kw^.komorka.x := poz;
	kw^.komorka.w := war;
end;

(* wstawia element na liste albo dodaje 1 do starego *)
procedure wstaw (p : wiersz;  poz : integer);
begin
	if (p^.komorka.x < poz) then 
	begin
		stworz (11, poz, p, nil);
	end
	else if (p^.poprz = nil)  or (p^.poprz^.komorka.x < poz) then
	begin
        stworz (11, poz, p^.poprz, p);
	end else
	begin
		Inc(p^.poprz^.komorka.w);
	end;
end;

procedure zaznacz (p : wiersz; poz : integer);
begin
	wstaw (p, poz - 1);
	wstaw (p, poz);
	wstaw (p, poz + 1);
end;

function przewin (var p : wiersz; poz : integer): wiersz;
begin
	while (p^.nast <> nil) and (p^.komorka.x < poz) do
	begin
		p := p^.nast;
	end;
	przewin := p;
end;

var kCur, k: kolumna;
var pozX, pozY : integer;
var pU, pD, cur : wiersz;
var koniec : boolean;

var a : char;

begin

read(a);
pozY := 1;
(* stworzenie pustej kolumny nad obecna *)
(* kCur to kolumna w ktora obecnie wstawiamy *)
new (kCur); kCur^.nr := 1;
new (kCur^.stan); kCur^.stan^.komorka.w := 10; kCur^.stan^.komorka.x := 0;
new (k); k^.nr := 0;
k^.poprz:= kCur;
kCur^.nast:=k;
new (k^.stan); k^.stan^.komorka.w := 10; k^.stan^.komorka.x := 0;

(* tu trzeba zrobic warunek zeby skonczyl wczytywac dane *)
koniec:= false;
while not(koniec) do
begin
	Inc (pozY);

	(* nowa kolumna *)
	(* przejscie do nowej *)
    kCur := kCur^.nast;
	cur := kCur^.stan;
    new (k);
	k^.nr := pozY;
    k^.poprz:= kCur;
    kCur^.nast:=k;
	kCur^.stan := cur;
	
	

    new (k^.stan); k^.stan^.komorka.w := 10; k^.stan^.komorka.x := 0;
	pU := kCur^.poprz^.stan;
	pD := k^.stan;
	pozX := 0;
	while (not eoln) do
	begin
		Inc (pozX);
		if a = '0' then
		begin
			pU := przewin (pU, pozX);
			pD := przewin (pD, pozX);
            new(cur^.nast);
            cur:=cur^.nast;
			wstaw (cur, pozX + 1);
			wstaw (cur, pozX);
			wstaw (cur, pozX - 1);
			zaznacz (pU, pozX);
			zaznacz (pD, pozX);
		end;
		read(a);
	end;
	readln();
	if eoln then begin koniec:= true; end;
end;
while k <>nil do begin
					p:=k^.stan;
					write(k^.nr,': ');
					while p<>nil do begin
						write(p^.komorka.w,' ');
						p:=p^.nast;
					end;
					writeln();
					k:=k^.poprz;
				end;
end.
