program Conn;

const ROZ=19;

type obszar = array[1..ROZ,1..ROZ] of char;
var plansza : obszar;
var gracz: char;
var pierwszy,koniec: boolean;
var i,j,z,w1,w2,licz : Integer;
var polecenie : string;

//wypisuje planszei aktualnego gracza
procedure wypisz(planza: obszar);
var n,m,t: Integer;
begin
	writeln('--------------------------------------+');
	for n:=1 to ROZ do begin
		write(chr(ord('s')-n+1),plansza[n,1]);
		for m:=2 to ROZ do begin
			write(' ',plansza[n,m])
		end;
		writeln('|');
	end;
	write(' A');
	for t:=1 to ROZ-1 do write(' ',chr(ord('A')+t));
	writeln('|');
end;

//czy dana litera jest mala z zakresu a..s
function maly(znak : integer): boolean;
begin
	if (znak <= ord('s')) and (znak >= ord('a')) then maly:=true
	else maly:=false;
end;

//czy dana litera jest duza z zakresu A..S
function duzy(znak : integer): boolean;
begin
	if (znak <= ord('S')) and (znak >= ord('A')) then duzy:=true
	else duzy:=false;
end;

//polecenie 1=poprawne,2=niepoprawne,3=puste 
function wczytaj(pierwszy: boolean; polecenie : string): Integer;
var tmp,z1,z2,z3,z4,x1,y1,x2,y2: Integer;
begin	
	if pierwszy=true then begin
		if length(polecenie) = 0 then tmp:=3
		else begin
			if length(polecenie) <> 2 then tmp:=2
			else begin
				z1:=ord(polecenie[1]);
				z2:=ord(polecenie[2]);
				if (duzy(z1)=true) and (maly(z2)=true) then begin 
				   x1:=z1-ord('A')+1;
				   y1:=ord('s')-z2+1;
				   if(plansza[y1,x1]='.')	then begin
						tmp:=1;
						plansza[y1,x1]:=gracz;
				   end
				   else tmp:=2;
				end
				else tmp:=2;
			end;
		end;
	end
	// ruch inny niz pierwszy
	else begin
		if length(polecenie) = 0 then tmp:=3
		else begin
			if (length(polecenie) <> 4) then tmp:=2
			else begin
				z1:=ord(polecenie[1]);
				z2:=ord(polecenie[2]);
				z3:=ord(polecenie[3]);
				z4:=ord(polecenie[4]);
				if (duzy(z1)=true) and (duzy(z3)=true) and              
				   (maly(z2)=true) and (maly(z4)=true) and
				   ((z1<>z3) or (z2<>z4))       then begin //rozne wspolrzedne
						x1:=z1-ord('A')+1;
						y1:=ord('s')-z2+1;
						x2:=z3-ord('A')+1;
						y2:=ord('s')-z4+1;
				        if(plansza[y1,x1]='.') and (plansza[y2,x2]='.') then begin
							tmp:=1;
							plansza[y1,x1]:=gracz;
							plansza[y2,x2]:=gracz;
						end
						else tmp:=2;
				end
				else tmp:=2;
			end;
		end;
	end;
	wczytaj:=tmp;
end;

 //1 = wygral 2 = remis 3 = gramy dalej
function check(plansza: obszar; z1,z2,gracz: char): Integer;
var g,d,l,p,gp,gl,dp,dl,it,x,y: Integer;
begin
	x:=ord(z1)-ord('A')+1;
	y:=ord('s')-ord(z2)+1;
	check:=3; //normalnie gramy dalej
	//chyba ze ktos wygra...
	//sprawdzam pion
	it:=0;
	g:=-1;
	while(g<5) and (plansza[y-it,x]=gracz) and (y-it>1) do begin
		Inc(it);
		Inc(g);
	end;
	if(plansza[y-it,x]=gracz) then Inc(g);
		
	it:=0;
	d:=-1;
	while(d<5) and (plansza[y+it,x]=gracz) and (y+it<ROZ) do begin
		Inc(it);
		Inc(d);
	end;
	if(plansza[y+it,x]=gracz) then Inc(d);
	if (d+g>=5) then check:=1;
	//sprawdzam poziom
	it:=0;
	l:=-1;
	while(l<5) and (plansza[y,x-it]=gracz) and (x-it>1) do begin
		Inc(it);
		Inc(l);
	end;
	if(plansza[y,x-it]=gracz) then Inc(l);
	
	it:=0;
	p:=-1;
	while(p<5) and (plansza[y,x+it]=gracz) and (x+it<ROZ) do begin
		Inc(it);
		Inc(p);
	end;
	if(plansza[y,x+it]=gracz) then Inc(p);
	if(l+p>=5) then check:=1;
	//sprawdzam jedna przekatna (gl,dp)
	it:=0;
	gl:=-1;
	while(gl<5) and(plansza[y-it,x-it]=gracz) and (y-it>1) and (x-it>1) do begin
		Inc(it);
		Inc(gl);
	end;
	if(plansza[y-it,x-it]=gracz) then Inc(gl);
	
	it:=0;
	dp:=-1;
	while(dp<5) and(plansza[y+it,x+it]=gracz) and (y+it<ROZ) and (x+it<ROZ) do begin
		Inc(it);
		Inc(dp);
	end;
	if(plansza[y+it,x+it]=gracz) then Inc(dp);
	if(gl+dp>=5) then check:=1;
	//sprawdzam druga przekatna (dl,gp)
	it:=0;
	dl:=-1;
	while(dl<5) and(plansza[y+it,x-it]=gracz) and (y+it<ROZ) and (x-it>1) do begin
		Inc(it);
		Inc(dl);
	end;
	if(plansza[y+it,x-it]=gracz) then Inc(dl);
	
	it:=0;
	gp:=-1;
	while(gp<5) and(plansza[y-it,x+it]=gracz) and (y-it>1) and (x+it<ROZ) do begin
		Inc(it);
		Inc(gp);
	end;
	if(plansza[y-it,x+it]=gracz) then Inc(gp);
	if(dl+gp>=5) then check:=1;
end;

begin
	gracz:='X';
	licz:=1;
	pierwszy:=true;
	koniec:=false;
	for i:=1 to 19 do
		for j:=1 to 19 do
			plansza[i,j]:='.';
	wypisz(plansza);
	writeln('gracz X');
	while(koniec=false) do begin
		readln(polecenie);
		z:=wczytaj(pierwszy,polecenie);
		
		if z=1 then begin  //poprawne dane
			if pierwszy=false then	licz:=licz+2;
			if licz=ROZ*ROZ then begin
				w1:=2;
				w2:=2;
			end
			else begin
				w1:=check(plansza,polecenie[1],polecenie[2],gracz);
				if (pierwszy=false) then w2:=check(plansza,polecenie[3],polecenie[4],gracz)
				else begin
					w1:=3;
					w2:=3;
				end;
			end;
			wypisz(plansza);
			pierwszy:=false;
			if (w1=1) or (w2=1) then begin
				writeln('wygral ',gracz);
				koniec:=true; //koniec gry
			end;
			
			if (w1=2) then begin //remis
				writeln('remis');
				koniec:=true; //koniec gry
			end;
			
			if gracz='X' then gracz:='O'   //zmiana gracza
			else gracz:='X';
			
			if (w1=3) and (w2=3) then writeln('gracz ',gracz); //gramy dalej
			
		end;
		
		if z=2 then begin //niepoprawne
			wypisz(plansza);
			writeln('gracz ',gracz);
		end;
		
		if z=3 then koniec:=true; //zakonczenie gry bez wyniku
	end;
end.