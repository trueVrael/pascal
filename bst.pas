program bst;

type
	drzewo = ^wezel;
	wezel = record
	w : integer;
	v : boolean;
	lsyn, psyn : drzewo
	end;

procedure insert(x: Integer; var t: drzewo);
var s: drzewo;
begin
	s:=t;
	if t<>nil then begin
		if t^.v=false then begin
			t^.v:=true;
			t^.w:=x;
		end
		else if t^.w < x then begin
			if t^.psyn=nil then begin
				new(t^.psyn);
				t^.psyn^.v:=false;
				t^.psyn^.psyn:=nil;
				t^.psyn^.lsyn:=nil;
			end;
			insert(x,t^.psyn);
		end
		else if t^.w > x then begin
			if t^.lsyn=nil then begin
				new(t^.lsyn);
				t^.lsyn^.v:=false;
				t^.lsyn^.psyn:=nil;
				t^.lsyn^.lsyn:=nil;
			end;
			insert(x,t^.lsyn);
		end
	end;
	t:=s;
end;

procedure printAll(t:drzewo);
begin
 if t<>nil then begin
      printAll(t^.lsyn);
      Writeln(t^.w);
      printAll(t^.psyn)
 end
end;

procedure removeAll(t:drzewo);
begin
	if t<>nil then begin
		removeAll(t^.lsyn);
		removeAll(t^.psyn);
		dispose(t);
	end;
end;

var x: Integer;
var t: drzewo;

begin
	new(t);
	t^.lsyn:=nil;
	t^.psyn:=nil;
	t^.v:=false;
	while(not eof) do begin
		read(x);
		insert(x,t);
	end;
	printAll(t);
	removeAll(t);
end.
