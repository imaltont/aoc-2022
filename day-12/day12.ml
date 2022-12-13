#!/usr/bin/ocaml
open Bigarray
open Bigarray.Array2
type position =
  { x: int;
    y: int;
    height: int;
  }
type board =
  { start: position;
    goal : position;
    board: (int, Bigarray.int_elt, Bigarray.c_layout) Bigarray.Array2.t;
  }
type parent =
  | Par of position * parent
  | None

type point = 
  {
    pos: position;
    parent: parent;
    g: float;
    h: float;
  }

let comparePoint p1 p2 =
  int_of_float @@ (p1.g +. p1.h) -. (p2.g +. p2.h)
let existPoint p =
  (fun x -> p.pos.x == x.pos.x && p.pos.y == x.pos.y)

let readInput path =
  let lines = ref [] in
  let ic = open_in path in
  try
    while true; do
      lines := input_line ic :: !lines
    done; []
  with End_of_file ->
        close_in ic;
        List.rev !lines

let rec findPoint input v =
  {x = 0; y = 0; height = v}

let checkStartGoal c =
  match c with
    'E' -> 'z'
  | 'S' -> 'a'
  | _ -> c

let fillBoard input board =
  let _ =
    let rec iterRow rows ind1 =
      let rec iterCol cols ind2 =
        match cols with
          h::t -> Bigarray.Array2.set board ind1 ind2 (int_of_char (checkStartGoal h)); iterCol t (ind2+1)
        | _ -> () in
      match rows with
        h::t -> iterCol (List.init (String.length h) (String.get h)) 0; iterRow t (ind1+1)
      | _ -> () in
    iterRow input 0 in
  board
    
let recGoal input =
  let rec iterRow rows ind1 =
      let rec iterCol cols ind2 =
        match cols with
          h::t -> if h == 'E' then
                    {x = ind1; y = ind2; height = (int_of_char 'z')}
                  else
                    iterCol t (ind2+1)
        | _ -> {x = -1; y = -1; height = (int_of_char 'z')} in
      match rows with
        h::t -> let it = iterCol (List.init (String.length h) (String.get h)) 0
                in
                if it.x == -1 && it.y == -1 then
                  iterRow t (ind1+1)
                else
                  it
      | _ -> {x = 0; y = 0; height = (int_of_char 'z')} in
    iterRow input 0
let recStart input =
  let rec iterRow rows ind1 =
      let rec iterCol cols ind2 =
        match cols with
          h::t -> if h == 'S' then
                    {x = ind1; y = ind2; height = (int_of_char 'a')}
                  else
                    iterCol t (ind2+1)
        | _ -> {x = -1; y = -1; height = (int_of_char 'a')} in
      match rows with
        h::t -> let it = iterCol (List.init (String.length h) (String.get h)) 0
                in
                if it.x == -1 && it.y == -1 then
                  iterRow t (ind1+1)
                else
                  it
      | _ -> {x = 0; y = 0; height = (int_of_char 'a')} in
    iterRow input 0
let allStarting input = 
  let rec iterRow rows ind1 =
    let rec iterCol cols ind2 =
     match cols with
        h::t -> if h == 'S' || h == 'a' then
                  {x = ind1; y = ind2; height = (int_of_char 'a')}::iterCol t (ind2+1)
                else
                  iterCol t (ind2+1)
      | _ -> [] in
    match rows with
      h::t -> (iterCol (List.init (String.length h) (String.get h)) 0)::iterRow t (ind1+1)
     | _ -> [] in
  iterRow input 0

let createBoard input =
  let height = List.length input in
  let width = String.length @@ List.nth input 1 in
  let start = recStart input in
  let goal = recGoal input in
  let board = Bigarray.Array2.create Bigarray.int Bigarray.c_layout height width in
  {start = start; goal = goal; board = fillBoard input board}

let arc parent = parent +. 1.
let euclid current goal = 0. (* sqrt @@ (float_of_int (current.x - goal.x))**2. +. (float_of_int (current.y - goal.y))**2. Leaving for documentation purposes. Maybe I'll ifnd out what was wrong eventually*)

let createNeighbor xOff yOff parent pos g board = 
  let newX = pos.x + xOff in
  let newY = pos.y + yOff in
  let newHeight = Bigarray.Array2.get board.board newX newY in
  {pos = {x = newX; y = newY; height = newHeight}; parent = parent; g = arc g; h = euclid {x = newX; y = newY; height = newHeight} board.goal}

let rec filterNeighbors l neighbors =
  match neighbors with
    h::t -> if List.exists (existPoint h) l then filterNeighbors l t else h::filterNeighbors l t
  | _  -> []
let rec filterHeights max neighbors =
  match neighbors with
    h::t -> if h.pos.height - max > 1 then
             filterHeights max t
           else h::filterHeights max t
  | _ -> []

let getNeighbors current board openlist closedlist =
  let north = if current.pos.x == 0 then
                []
              else
                [createNeighbor (-1) 0 (Par(current.pos, current.parent)) current.pos current.g board] in
  let south = if current.pos.x == (-1) + Bigarray.Array2.dim1 board.board then
                []
              else
                [createNeighbor 1 0 (Par(current.pos, current.parent)) current.pos current.g board] in
  let east = if current.pos.y == (-1) + Bigarray.Array2.dim2 board.board then
                []
              else
                [createNeighbor 0 1 (Par(current.pos, current.parent)) current.pos current.g board] in
  let west = if current.pos.y == 0 then
                []
              else
                [createNeighbor 0 (-1) (Par(current.pos, current.parent)) current.pos current.g board] in
  filterHeights current.pos.height @@ filterNeighbors (openlist@closedlist) (north@south@east@west)

let rec astar current board openlist closedlist =
  if current.pos.x == board.goal.x && current.pos.y == board.goal.y then
    current.parent
  else
    let neighbors = getNeighbors current board openlist closedlist in
    let newopen = neighbors@openlist in
    (match (List.sort comparePoint newopen) with
       h::t -> astar h board t ([h]@closedlist)
     | _ -> None)

let rec countPath path sum =
  match path with
    Par(_, p) -> countPath p (sum+1)
  | _ -> sum

let rec countAllStarts starts board =
  match starts with
    h::t -> let start = {pos = h; parent = None; g = 0.; h = euclid h board.goal}
            in (countPath (astar start board [] []) 0)::(countAllStarts t board)
  | _ -> []
let rec filterAllStarts starts min =
  match starts with
    h::t -> if h <= 0 || h > min then filterAllStarts t min
            else filterAllStarts t h
  | _ -> min


let playing_board = createBoard @@ readInput "./resources/input";;
let sta = {pos = playing_board.start; parent = None; g = 0. ; h = euclid playing_board.start playing_board.goal};;
let allStarts = List.flatten (allStarting @@ readInput "./resources/input");;
let allPaths = countAllStarts allStarts playing_board;;

print_string "Part 1: ";
print_int @@ countPath (astar sta playing_board [] [sta]) 0;
print_string "\n";


print_string "Part 2: ";
print_int @@ filterAllStarts (countAllStarts allStarts playing_board) 1000;;
print_string "\n"
