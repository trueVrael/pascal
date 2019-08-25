program t;
var z : Char;

begin
while not eof() do begin
	read(z);
	while (ord(z)<>10) do begin
		read(z);
		writeln(z);
		if eof then write('fgaga');
	end;
end;
end.