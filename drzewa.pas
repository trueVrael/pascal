unit drzewa;

interface
	
	procedure inicjuj;
	function przypisanie(argument, wartosc : LongInt) : LongInt;
	function suma(nr_funkcji, lewy_argument, prawy_argument : LongInt) : LongInt;
	function czysc(nr_funkcji : LongInt) : LongInt;
	
implementation

	const N = 1000000;			//10^6	
	
	type drzewo = ^wezel;
		wezel = record 
		w : LongInt;			// liczba dowi¹zañ
		y : LongInt; 			//wartosc
		suma : LongInt;			//suma w poddrzewie
		x : LongInt;			//klucz
		lsyn, psyn : drzewo;
	end;
	type Tdrzew = array[0..N+1] of drzewo;

	var tab : Tdrzew;
	var ostatnie_drzewo : LongInt;
	var liczba_wezlow : LongInt;
	var odjecie : LongInt;
	
	procedure inicjuj();
		var i : LongInt;
	begin
		for i:=1 to N do tab[i] := nil;
		liczba_wezlow := 0;
		ostatnie_drzewo := 0;
	end;
	
	function wez(d : drzewo; x : LongInt) : Integer;
		var bw : Integer;
	begin
		if (d = nil) then wez := 0
		else begin
			bw := x - d^.x;
			if (bw = 0) then wez := d^.y
			else if (bw < 0) then wez := wez(d^.lsyn, x)
			else wez := wez(d^.psyn, x);
		end;
	end;
	
	procedure kopiuj(d,nw : drzewo);
	begin
		nw^.w := d^.w;
		nw^.y := d^.y;
		nw^.suma := d^.suma; 
		nw^.x := d^.x; 
		nw^.lsyn := d^.lsyn;
		nw^.psyn := d^.psyn;
	end;
	
	function wstaw(d : drzewo; x, y : LongInt) : drzewo;
		var nw : drzewo;
	begin
		New(nw);
		Inc(liczba_wezlow);		
		if (d = nil) then begin
			nw^.w := 0;
			nw^.y := y;
			nw^.x := x;
			nw^.suma := y;
			nw^.psyn := nil;
			nw^.lsyn := nil;
			wstaw :=nw;
		end
		else begin
			kopiuj(d,nw);
			nw^.w := 0;
			nw^.suma := nw^.suma + y;
			if (x > nw^.x) then	begin
				nw^.psyn := wstaw(d^.psyn, x, y);
				if (nw^.lsyn <> nil) then Inc(nw^.lsyn^.w);
				nw^.psyn^.w := 1;
			end
			else begin
				nw^.lsyn := wstaw(d^.lsyn, x, y);
				if (nw^.psyn <> nil) then Inc(nw^.psyn^.w);
				nw^.lsyn^.w := 1;
			end;
			wstaw :=nw;
		end;
	end;
	
	function zmien(d : drzewo; x, y :LongInt) : drzewo;
		var nw : drzewo;
		var roznica : LongInt;
	begin
		New(nw);
		Inc(liczba_wezlow);
		kopiuj(d,nw);
		nw^.w := 0;
		if (nw^.x = x) then begin
			roznica := y - nw^.y;
			nw^.y := y;
			zmien := nw;
		end
		else if (nw^.x < x) then begin
			nw^.psyn := zmien(d^.psyn, x, y);
			if (nw^.lsyn <> nil) then Inc(nw^.lsyn^.w);
			nw^.psyn^.w := 1;
		end
		else begin
			nw^.lsyn := zmien(d^.lsyn, x, y);
			if (nw^.psyn <> nil) then Inc(nw^.psyn^.w);
			nw^.lsyn^.w := 1;
		end;
		nw^.suma := nw^.suma + roznica;
		zmien := nw;
	end;
	
	function usun(d : drzewo; x : LongInt) : drzewo;
		function nast(dd : drzewo) : drzewo;
		begin
			if (dd^.lsyn = nil) then nast :=dd
			else nast := nast(dd^.lsyn);
		end;
		function wyrzuc(stare : drzewo) : drzewo;
			var tw : drzewo;
		begin
			if (stare^.lsyn = nil) then wyrzuc := stare^.psyn
			else begin
				New(tw);
				Inc(liczba_wezlow);
				kopiuj(stare,tw);
				tw^.w := 0;
				tw^.suma := tw^.suma - odjecie;
				tw^.lsyn := wyrzuc(tw^.lsyn);
				if (tw^.psyn <> nil) then Inc(tw^.psyn^.w);
				if (tw^.lsyn <> nil) then Inc(tw^.lsyn^.w);
				wyrzuc := tw;
			end;
		end;
		var nw : drzewo;
	begin
		New(nw);
		Inc(liczba_wezlow);
		kopiuj(d,nw);
		nw^.w := 0;
		if (nw^.x < x) then begin
			nw^.psyn := usun(d^.psyn, x);
			if (nw^.lsyn <> nil) then Inc(nw^.lsyn^.w);
			nw^.suma := nw^.suma - odjecie;
			nw^.psyn^.w := 1;
		end
		else if (nw^.x > x) then begin
			nw^.lsyn := usun(d^.lsyn, x);
			if (nw^.psyn <> nil) then Inc(nw^.psyn^.w);
			nw^.suma := nw^.suma - odjecie;
			nw^.lsyn^.w := 1;
		end
		else if (nw^.x = x) then begin
			odjecie := nw^.y;
			if(nw^.psyn = nil) then begin
				dispose(nw);
				Dec(liczba_wezlow);
				usun := d^.lsyn;
			end
			else begin
				nw^.y := nast(nw^.psyn)^.y;
				nw^.psyn := wyrzuc(nw^.psyn);
				nw^.suma := 0;
				if (nw^.lsyn <> nil) then nw^.suma := nw^.lsyn^.suma;
				if (nw^.psyn <> nil) then nw^.suma := nw^.suma + nw^.psyn^.suma;
			end;
		end;
		usun := nw;
	end;
	
	function przypisanie(argument, wartosc : LongInt) : LongInt; //liczba wezlow
		var opcja : Integer;
	begin
		opcja := wez(tab[ostatnie_drzewo], argument);
		if (opcja = 0) and
			(wartosc > 0) then tab[ostatnie_drzewo + 1] := wstaw(tab[ostatnie_drzewo], argument, wartosc)
			
		else if (opcja > 0) and (wartosc > 0) and (opcja <> wartosc) 
			then tab[ostatnie_drzewo + 1] := zmien(tab[ostatnie_drzewo], argument, wartosc)
			
		else if (opcja > 0) and (wartosc = 0) then
			tab[ostatnie_drzewo + 1]:=usun(tab[ostatnie_drzewo], argument)
		
		else begin
			tab[ostatnie_drzewo + 1] := tab[ostatnie_drzewo];
			if (tab[ostatnie_drzewo] <> nil) then Inc(tab[ostatnie_drzewo]^.w);
		end;
		Inc(ostatnie_drzewo);
		przypisanie := liczba_wezlow;
	end;
	
	function suma(nr_funkcji, lewy_argument, prawy_argument : LongInt) : LongInt;
		var l,p : drzewo;
	begin
		suma := 0;
		l := tab[nr_funkcji];
		p := tab[nr_funkcji];
		//zejdz do takiego wezla s, ze lewy_argument < l^.y < prawy_argument 
		{#B-}
		if (l <> nil) then begin
			while  (l <> nil) and ((l^.x > prawy_argument) or (p^.x < lewy_argument)) do begin
				if (prawy_argument < l^.x) then begin
					l := l^.lsyn;
					p := l;
				end;
				if (lewy_argument > p^.x) then begin
					p := p^.psyn;
					l := p;
				end;
			end;
		end;
		{#B+}
		if (l <> nil) then begin
			suma := suma + l^.y;
			l := l^.lsyn;
			p := p^.psyn;
		end;
		//sumuj lewa strone poddrzewa
		if (l <> nil) then begin
			while (l <> nil) and (l^.x <> lewy_argument) do begin
				if (l^.x < lewy_argument) then l := l^.psyn
				else if (l^.x > lewy_argument) then begin
					suma := suma + l^.y;
					if (l^.psyn <> nil) then suma := suma + l^.psyn^.suma;
					l := l^.lsyn;
				end;
			end;
			if (l <> nil) then begin
					if (l^.x = lewy_argument) then begin
						suma := suma + l^.y;
						if (l^.psyn <> nil) then suma := suma + l^.psyn^.suma;
					end;
			end;
		end;
		//sumuj prawa strone poddrzewa
		if (p <> nil) then begin
			while (p <> nil) and (p^.x <> prawy_argument) do begin
				if (p^.x > prawy_argument) then p := p^.lsyn
				else if (p^.x < prawy_argument) then begin
					suma := suma + p^.y;
					if (p^.lsyn <> nil) then suma := suma + p^.lsyn^.suma;
					p := p^.psyn;
				end;
			end;
			if (p <> nil) then begin
					if (p^.x = prawy_argument) then begin
						suma := suma + p^.y;
						if (p^.lsyn <> nil) then suma := suma + p^.lsyn^.suma;
					end;
			end;
		end;
	end;
	
	function czysc(nr_funkcji : LongInt) : LongInt; //liczba wezlow
		procedure spacer(t: drzewo);
		begin
			if t<>nil then begin
				if(t^.w = 0) then begin
					if(t^.lsyn <> nil) then Dec(t^.lsyn^.w);
					if(t^.psyn <> nil) then Dec(t^.psyn^.w);
					spacer(t^.lsyn);
					spacer(t^.psyn);
					dispose(t);
					Dec(liczba_wezlow);
				end;
			end;
		end;
	begin
		if(tab[nr_funkcji] <> nil) and (tab[nr_funkcji]^.w > 0) then begin
			Dec(tab[nr_funkcji]^.w);
			tab[nr_funkcji] := nil;
		end
		else begin
			spacer(tab[nr_funkcji]);
			tab[nr_funkcji] := nil;
		end;
		czysc:=liczba_wezlow;
	end;	
end.