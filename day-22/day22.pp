{$mode ObjFpc} {$H+}
PROGRAM day22(OUTPUT);
uses Classes, SysUtils;
VAR
   inp		    : TStringList;
   board	    : TStringList;
   instruction_list : TStringList;
   instructions	    : String;
   INPUT_length	    : int64;
   i		    : int64;
   INPUT_mode	    : Boolean;
   code		    : int64;
   direction	    : int64;
   x		    : int64;
   y		    : int64;
   ch		    : Char;
   word		    : String;
   garbage	    : String;
FUNCTION dir(current: int64; turn : String): int64;
VAR
   tmpDir : int64;
BEGIN
   tmpDir := current;
   IF (turn = 'R') THEN
      tmpDir := (tmpDir + 1) MOD 4
   ELSE
      tmpDir := tmpDir - 1;
   IF (tmpDir < 0) THEN
      tmpDir := 3;
   dir := tmpDir;
END;
FUNCTION negativeWrap (pos, maval, mival : int64 ) : int64;
BEGIN
   pos := pos - 1;
   IF (pos < mival) THEN
   BEGIN
      pos := maval;
   END;
   negativeWrap := pos;
END;
PROCEDURE findNext(board: TStringList; direction, steps, height : int64; VAR x, y: int64);
VAR
   tmpX	: int64;
   tmpY	: int64;
   i	: int64;
BEGIN
   tmpX := x;
   tmpY := y;
   IF (direction = 0) THEN
      FOR i := 1 TO steps DO
      BEGIN
	 tmpX := tmpX + 1;
	 IF (tmpX > board[tmpY].length) THEN
	    tmpX := 1;
	 WHILE NOT ((board[tmpY][tmpX] = '.') OR (board[tmpY][tmpX] = '#')) DO
	 BEGIN
	    tmpX := tmpX + 1;
	    IF (tmpX > board[tmpY].length) THEN
	       tmpX := 1;
	 END;
	 IF (board[tmpY][tmpX] = '.') THEN
	 BEGIN
	    x := tmpX;
	    y := tmpY;
	 END
      ELSE
	 Exit;
      END
ELSE IF (direction = 1) THEN
   FOR i := 1 TO steps DO
   BEGIN
      tmpY := (tmpY + 1) MOD (height);
      WHILE (board[tmpY].length < tmpX) OR NOT ((board[tmpY][tmpX] = '.') OR (board[tmpY][tmpX] = '#')) DO
	 tmpY := (tmpY + 1) MOD (height);
      IF (board[tmpY][tmpX] = '.') THEN
      BEGIN
	 x := tmpX;
	 y := tmpY;
      END
   ELSE
      Exit;
   END
ELSE IF (direction = 2) THEN
   FOR i := 1 TO steps DO
   BEGIN
      tmpX := negativeWrap(tmpX, board[tmpY].length, 1);
      WHILE NOT ((board[tmpY][tmpX] = '.') OR (board[tmpY][tmpX] = '#')) DO
	 tmpX := negativeWrap(tmpX, board[tmpY].length, 1);
      IF (board[tmpY][tmpX] = '.') THEN
      BEGIN
	 x := tmpX;
	 y := tmpY;
      END
   ELSE
   BEGIN
      Exit;
   END;
   END
ELSE IF (direction = 3) THEN
   FOR i := 1 TO steps DO
   BEGIN
      tmpY := negativeWrap(tmpY, height-1, 0);
      WHILE (board[tmpY].length < tmpX) OR NOT ((board[tmpY][tmpX] = '.') OR (board[tmpY][tmpX] = '#')) DO
	 tmpY := negativeWrap(tmpY, height-1, 0);
      IF (board[tmpY][tmpX] = '.') THEN
      BEGIN
	 x := tmpX;
	 y := tmpY;
      END
   ELSE
      Exit;
   END;
END;
PROCEDURE findNextCube(board: TStringList; steps, height : int64; VAR direction, x, y: int64);
VAR
   tmpX	  : int64;
   tmpY	  : int64;
   tmpDir : int64;
   i	  : int64;
BEGIN
   tmpX := x;
   tmpY := y;
   tmpDir := direction;
   FOR i := 1 TO steps DO
      IF (direction = 0) THEN
      BEGIN
	 tmpX := tmpX + 1;
	 IF (tmpX > 150) THEN 
	 BEGIN
	    tmpDir := 2;
	    tmpX := 100;
	    tmpY := 149 - tmpY;
	 END
      ELSE IF ((tmpX > 100) AND (tmpY > 49) AND (tmpY < 100)) THEN 
      BEGIN
	 tmpDir := 3;
	 tmpX := 100 + (1 + tmpY - 50); 
	 tmpY := 49;
      END
      ELSE IF ((tmpX > 100) AND (tmpY > 99)) THEN 
      BEGIN
	 tmpDir := 2;
	 tmpX := 150;
	 tmpY := 149 - tmpY;
      END
      ELSE IF ((tmpX > 50) AND (tmpY > 149)) THEN 
      BEGIN
	 tmpDir := 3;
	 tmpX := 50 + (1 + tmpY - 150);
	 tmpY := 149;
      END;
	 IF (board[tmpY][tmpX] = '.') THEN
	 BEGIN
	    x := tmpX;
	    y := tmpY;
	    direction := tmpDir;
	 END
      ELSE
	 Exit;
      END
ELSE IF (direction = 1) THEN
BEGIN
   tmpY := tmpY + 1;
   IF (tmpY > 199) THEN 
   BEGIN
      tmpY := 0;
      tmpX := 100 + tmpX;
   END
ELSE IF ((tmpY > 149) AND (tmpX > 50)) THEN 
BEGIN
   tmpDir := 2;
   tmpY := 150 + tmpX - 1 - 50;
   tmpX := 50;
END
ELSE IF ((tmpY > 49) AND (tmpX > 100)) THEN 
BEGIN
   tmpDir := 2;
   tmpY := 50 + tmpX - 100 - 1;
   tmpX := 100;
END;
   IF (board[tmpY][tmpX] = '.') THEN
   BEGIN
      x := tmpX;
      y := tmpY;
      direction := tmpDir;
   END
ELSE
   Exit;
END
ELSE IF (direction = 2) THEN
BEGIN
   tmpX := tmpX - 1;
   IF ((tmpX < 1) AND (tmpY >= 150)) THEN 
   BEGIN
      tmpDir := 1;
      tmpX := 50 + (1 + tmpY - 150);
      tmpY := 0;
   END
ELSE IF ((tmpX < 1) AND (tmpY < 150) ) THEN 
BEGIN
   tmpDir := 0;
   tmpY := 149 - tmpY;
   tmpX := 51;
END
ELSE IF ((tmpX < 51) AND (tmpY > 49) AND (tmpY < 100)) THEN 
BEGIN
   tmpDir := 1;
   tmpX := (1 + tmpY - 50);
   tmpY := 100;
END
ELSE IF ((tmpX < 51) AND (tmpY < 50)) THEN 
BEGIN
   tmpDir := 0;
   tmpX := 1;
   tmpY := 149 - tmpY;
END;
   IF (board[tmpY][tmpX] = '.') THEN
   BEGIN
      x := tmpX;
      y := tmpY;
      direction := tmpDir;
   END
ELSE
BEGIN
   Exit;
END;
END
ELSE IF (direction = 3) THEN
BEGIN
   tmpY := tmpY - 1;
   IF ((tmpY < 0) AND (tmpX < 101)) THEN
   BEGIN
      tmpDir := 0;
      tmpY := 150 - 50 + tmpX - 1; 
      tmpX := 1;
   END
ELSE IF ((tmpY < 0) AND (tmpX > 100)) THEN
BEGIN
   tmpX := tmpX - 100;
   tmpY := 199;
END
ELSE IF ((tmpY < 100) AND (tmpX < 51)) THEN 
BEGIN
   tmpDir := 0;
   tmpY := tmpX - 1 + 50;
   tmpX := 51;
END;
   IF (board[tmpY][tmpX] = '.') THEN
   BEGIN
      x := tmpX;
      y := tmpY;
      direction := tmpDir;
   END
ELSE
   Exit;
END;
END;
FUNCTION part1Score(x, y, d : int64 ) : int64;
BEGIN
   part1Score := 1000 * x + y * 4 + d;
END;
BEGIN
   inp := TStringList.Create;
   board := TStringList.Create;
   instruction_list := TStringList.Create;
   inp.LoadFromFile('./resources/input');
   INPUT_length := -1;
   INPUT_mode := false;
BEGIN
   FOR garbage IN inp DO INPUT_length := INPUT_length + 1;
   FOR i			      := 0 TO INPUT_length DO
   BEGIN
      IF(INPUT_mode) THEN
      BEGIN
	 instructions := inp[i];
      END
   ELSE IF(inp[i].length = 0) THEN
   BEGIN
      INPUT_mode := true;
   END
   ELSE
   BEGIN
      board.Add(inp[i]);
   END;
   END;
END;
BEGIN
   word := '';
   FOR ch IN instructions DO
   BEGIN
      code := 0;
      Val(ch, i, code);
      IF (code = 0) THEN
	 word += ch
      ELSE
      BEGIN
	 instruction_list.Add(word);
	 word := '';
	 instruction_list.Add(ch);
      END;
   END;
   instruction_list.Add(word);
END;
   INPUT_length := 0;
   FOR garbage IN board DO INPUT_length := INPUT_length + 1;
   x := 1;
   y := 0;
   direction := 0;
   findNext(board, direction, 1, INPUT_length, x, y);
   FOR garbage IN instruction_list DO
   BEGIN
      code := 0;
      Val(garbage, i, code);
      IF (code = 0) THEN
      BEGIN
	 findNext(board, direction, i, INPUT_length, x, y);
      END
   ELSE
      direction := dir(direction, garbage);
   END;
   WRITELN('Part 1: ', part1Score(y+1, x, direction));
   x := 1;
   y := 0;
   direction := 0;
   findNext(board, direction, 1, INPUT_length, x, y);
   FOR garbage IN instruction_list DO
   BEGIN
      code := 0;
      Val(garbage, i, code);
      IF (code = 0) THEN
      BEGIN
	 findNextCube(board, i, INPUT_length, direction, x, y);
      END
   ELSE
      direction := dir(direction, garbage);
   END;
   WRITELN('Part 2: ', part1Score(y+1, x, direction));
END.		  
