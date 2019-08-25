program Gra;

type pole=^elempole;
elempole=record	{struktura zawieraj¹ca potrzebne komorki w danym wierszu}
			x: longInt;
			w: integer;
			poprz, nast : pole;
end;

type wiersz=^elemwiersz;
elemwiersz=record		{struktura odzwierciedlaj¹ca wiersze planszy}
			y : longInt;
			pola : pole;
			poprz, nast : wiersz;
end;

var xx, yy : longInt;
var biezW, temp : wiersz;
var k : wiersz;
var biezP, dolneP, gorneP: pole;
var cos:boolean;
var a :char;


procedure polaczW (a : wiersz; b : wiersz);
begin
	if a<>nil then 
	begin
		a^.nast := b; 
	end;
	if b<>nil then 
	begin
		b^.poprz := a; 
	end;
end;

function wstaw_wiersz (y : longInt) : wiersz;
var atrapa : pole;
begin
	new (temp);
	new (atrapa);
	temp^.pola:=atrapa;
	temp^.y := y;
	atrapa^.x :=-MAXLONGINT;
	k := biezW^.nast;
	polaczW (biezW, temp);
	polaczW (temp, k);
	wstaw_wiersz :=temp;
end;

procedure wstaw_pole (x : longInt; w: integer; a: pole; b: pole);
var tmp: pole;
begin
	new (tmp);
	tmp^.x := x;
	tmp^.w := w;
	a^.nast := tmp;
	if b <> nil then b^.poprz := tmp;
end;


procedure pola_start ();
begin
	gorneP := biezW^.poprz^.pola;
	biezP := biezW^.pola;
	dolneP := biezW^.nast^.pola;
end;
	
procedure uzupelnij ();
begin
	if (biezW^.y < yy) then
	begin
		if (biezW^.y < yy - 1) then
		begin
			biezW := wstaw_wiersz (yy - 1);
		end;
		biezW := wstaw_wiersz (yy);
		wstaw_wiersz (yy+1);
		pola_start();
	end
	else if (biezW^.nast = nil) then
	begin
		wstaw_wiersz (yy+1);
		pola_start();
	end;
end;

function dostaw (var pP: pole) : pole;
begin
	while (pP^.nast <> nil) or (pP^.nast^.x > xx) do
	begin
		pP := pP^.nast;
	end;
	
	if (pP^.nast = nil) or (pP^.nast^.x > xx + 1) then
	begin
		wstaw_pole (xx + 1, 10, pP, pP^.nast);
	end;
	Inc(pP^.nast^.w);
	
	(* mam juz zagwarantowane, ze pp.nast to pole dla x+1 *)
	if pP^.x < xx then
	begin
		if pP^.x < xx - 1 then
		begin
			wstaw_pole (xx - 1, 10, pP, pP^.nast);
		end;
		Inc(pP^.w);
		wstaw_pole (xx, 0, pP, pP^.nast);
		Inc(pP^.nast^.w);
	end else
	begin
		pP^.w := pP^.w - 10;
		wstaw_pole (xx - 1, 10, pP^.poprz, pP);
	end;
	dostaw := pP;
end;

begin

new(biezW);
biezW^.y := -1;
new (biezW^.pola);
biezW^.pola^.x := -MAXLONGINT;
cos:=false;
yy := 0;
xx := 0;
while not eof do
begin
	Inc (yy);
	xx := 0;
	while not eoln do
	begin
		if not cos then begin 
			read(a);
			Inc (xx);
			if a = '0' then 
			begin
				uzupelnij();
				gorneP:= (dostaw(gorneP))^.nast; 
				biezP:=(dostaw(biezP))^.nast;
				dolneP:=(dostaw(dolneP))^.nast;
			end;
		end
		else readln();
	end;
	readln();
	if eoln then cos:=true;
	
	(*while biezW <>nil do begin {wypisz plansze}
		biezP:=biezW^.pola;
		write(biezW^.y,': ');
		while biezP<>nil do begin
			write(biezP^.w,' ');
			biezP:=biezP^.nast;
		end;
		writeln();
		biezW:=biezW^.nast;*)
	end;
end.