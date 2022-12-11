functor
import
   System
   Browse
   Application
   Open
define
   local
      Handle = {New Open.file init(name: "./resources/input")}
      Content = {Handle read(size:all list:$)}
      Monkeys
      MonkeyBusiness
      Monkeys2
      MonkeyBusiness2
      class Monkey
	 attr items receiverT receiverF operation operationVal test amount divider
	 meth init(Items Operation Test Tr Fa Div)
	    items := {List.map
		      {String.tokens
		       {List.nth
			{String.tokens Items &:}
			2}
		       &,}
		      String.toInt}
	    case {List.nth {String.tokens Operation &=} 2} of
	       (&o|&l|&d|O|M) then
	       operation := O
	       operationVal := M
	    else skip end
	    test := {String.toInt {List.nth {String.tokens Test &y} 2}}
	    receiverT := {String.toInt {List.nth {String.tokens Tr &y} 2}} + 1
	    receiverF := {String.toInt {List.nth {String.tokens Fa &y} 2}} + 1
	    amount := 0
	    divider := Div
	 end
	 meth getam(?X)
	    X = @amount
	 end
	 meth getdiv(?X)
	    X = @test
	 end
	 meth setdiv(Div)
	    divider := Div
	 end
	 meth check(Item ?Worry ?Res)
	    Middle
	    WorryVal
	 in
	    WorryVal = case @operationVal of
			  &o|&l|&d|T then Item
		       else {String.toInt @operationVal} end
	    amount := @amount + 1
	    Middle = case @operation of
			&* then Item * WorryVal
		     [] &+ then Item + WorryVal
		     else 0 end
	    Worry = if @divider == 3 then
		       {Int.'div' Middle @divider}
		    else
		       {Int.'mod' Middle @divider}
		    end
	    Res = if {Int.'mod' Worry @test} == 0 then
		     @receiverT
		  else
		     @receiverF
		  end
	 end
	 meth throwItem(Monkeys) 
	    NewWorry
	    Receiver
	 in
	    case @items of
	       (H|T) then
	       {self check(H NewWorry Receiver)}
	       {{List.nth Monkeys Receiver} receive(NewWorry)}
	       items := T 
	       {self throwItem(Monkeys)}
	    else skip end
	 end
	 meth receive(Item)
	    items := {List.append @items Item|nil}
	 end
      end
      fun {CreateMonkeys Data Div}
	 fun {CM Data Div}
	    case {String.tokens {Filter Data IsNotSpace} &\n} of Items|Operation|Test|Tr|Fa|Rest then
	       {New Monkey init(Items Operation Test Tr Fa Div)}
	    else nil end
	 end
      in
	 case (Data) of &M|&o|&n|&k|&e|&y|S|W|N|C|T then {CM T Div}|{CreateMonkeys T Div}
	 [] (H|T) then {CreateMonkeys T Div}
	 else nil end
      end
      fun {GetMonkeyAmount Monk}
	 X
      in
	 {Monk getam(X)}
	 X
      end
      fun {GetMonkeyDiv Monk}
	 X
      in
	 {Monk getdiv(X)}
	 X
      end
      fun {IsNotSpace C}
	 C\=& 
      end
      proc {MonkeyRound Throwers Monkeys}
	 case Throwers of H|T then {H throwItem(Monkeys)} {MonkeyRound T Monkeys}
	 else skip end
      end
      proc {SetDiv Monkeys}
	 fun {GetDiv Monkeys}
	    case Monkeys of (H|T) then {GetMonkeyDiv H} * {GetDiv T}
	    else 1 end
	 end
	 proc {SetDiv2 Monkeys Div}
	    case Monkeys of (H|T) then {H setdiv(Div)} {SetDiv2 T Div}
	    else skip end
	 end
      in
	 {SetDiv2 Monkeys {GetDiv Monkeys}}
      end
      fun {GetMonkeyAmounts Monkeys}
	 case Monkeys of H|T then
	    {GetMonkeyAmount H}|{GetMonkeyAmounts T}
	 else nil end
      end
   in
      Monkeys = {CreateMonkeys Content 3}
      for X in 1..20 do
	 {MonkeyRound Monkeys Monkeys}
      end
      MonkeyBusiness = case {List.sort {GetMonkeyAmounts Monkeys} Value.'>'}
		       of M1|M2|T then M1 * M2
		       else 0 end
      {System.showInfo MonkeyBusiness}
      Monkeys2 = {CreateMonkeys Content 1}
      {SetDiv Monkeys2}
      for X in 1..10000 do
	 {MonkeyRound Monkeys2 Monkeys2}
      end
      MonkeyBusiness2 = case {List.sort {GetMonkeyAmounts Monkeys2} Value.'>'}
			of M1|M2|T then M1 * M2
			else 0 end
      {System.showInfo MonkeyBusiness2}
      {Application.exit 0}
   end
end