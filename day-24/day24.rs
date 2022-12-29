use std::{fmt, fs::File, io::{Result,BufRead,BufReader}};

#[derive(Debug,PartialEq,Clone)]
struct Entity {
    x : i32,
    y : i32,
}
#[derive(Debug)]
struct State {
    player: Entity,
    blizzards: Vec<Blizzard>,
    f: f32,
    g: f32,
}
#[derive(Debug,PartialEq,Clone)]
enum Blizzard {
    North(Entity),
    South(Entity),
    East(Entity),
    West(Entity),
}
#[derive(Debug,PartialEq)]
enum Tile {
    Open,
    Wall,
    Blizzard(Blizzard),
}
#[derive(Debug)]
struct Board {
    start : (i32, i32),
    goal : (i32, i32),
    board : Vec<Vec<Tile>>
}

impl Board {
    pub fn empty(dimensions: (i32,i32)) -> Board {
	let start: (i32,i32) = (1,0);
	let goal: (i32,i32) = (dimensions.0-2, dimensions.1-1);
	let mut board = Vec::<Vec<Tile>>::new();
	for row in 0..dimensions.1 {
	    board.push(Vec::<Tile>::new());
	    for col in 0..dimensions.0 {
		let index = board.len() - 1;
		if (col == 0 || col == dimensions.0-1)
		    || (row == 0 || row == dimensions.1-1) {
			board[index].push(Tile::Wall);
		    } else {
			board[index].push(Tile::Open);
		    }
	    }
	}
	board[start.1 as usize][start.0 as usize] = Tile::Open;
	board[goal.1 as usize][goal.0 as usize] = Tile::Open;
	Board {
	    start: start,
	    goal: goal,
	    board: board,
	}
    }
    pub fn gather_blizzards(&self) -> Vec<Blizzard> {
	let mut blizzards = Vec::<Blizzard>::new();
	for y in 0..self.board.len() as i32 {
	    for x in 0..self.board[y as usize].len() as i32 {
		match &self.board[y as usize][x as usize] {
		    Tile::Blizzard(b) => match b {
			Blizzard::North(_) => blizzards.push(Blizzard::North(Entity{ x: x, y: y})),
			Blizzard::South(_) => blizzards.push(Blizzard::South(Entity{ x: x, y: y})),
			Blizzard::East(_) => blizzards.push(Blizzard::East(Entity{ x: x, y: y})),
			Blizzard::West(_) => blizzards.push(Blizzard::West(Entity{ x: x, y: y})),
		    },
		    _ => {}
		}
	    }
	}
	blizzards
    }
    pub fn insert_blizzards(&mut self, blizzards: &Vec<Blizzard>) {
	for blizzard in blizzards {
	    match blizzard {
		Blizzard::North(b) => self.board[b.y as usize][b.x as usize] = Tile::Blizzard(Blizzard::North(Entity{x: b.x, y: b.y})),
		Blizzard::South(b) => self.board[b.y as usize][b.x as usize] = Tile::Blizzard(Blizzard::South(Entity{x: b.x, y: b.y})),
		Blizzard::East(b) => self.board[b.y as usize][b.x as usize] = Tile::Blizzard(Blizzard::East(Entity{x: b.x, y: b.y})),
		Blizzard::West(b) => self.board[b.y as usize][b.x as usize] = Tile::Blizzard(Blizzard::West(Entity{x: b.x, y: b.y})),
	    }
	}
    }
}
impl fmt::Display for Board {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
	for row in &self.board {
	    for col in row {
		let _ = match col {
		    Tile::Open => write!(f, "."),
		    Tile::Wall => write!(f, "#"),
		    Tile::Blizzard(b) => match b {
			Blizzard::North(_) => write!(f,"^"),
			Blizzard::South(_) => write!(f,"v"),
			Blizzard::East(_) => write!(f,">"),
			Blizzard::West(_) => write!(f,"<"),
		    }
,
		};
	    }
	    let _ = write!(f, "\n");
	}
	write!(f, "Start location: {},{}\nGoal location: {},{}\n"
	       , &self.start.0
	       , &self.start.1
	       , &self.goal.0
	       , &self.goal.1)
    }
}
fn read_input(inp: &str) -> Result<Board> {
    let mut board = Vec::<Vec<Tile>>::new();
    let file = File::open(inp)?;
    let reader = BufReader::new(file);
    let mut y = 0;
    for line in reader.lines().map(|x| x.unwrap()) {
	board.push(Vec::<Tile>::new());
	let mut x = 0;
	for ch in line.chars() {
	    let tile: Tile = match ch {
		'#' => Tile::Wall,
		'<' => Tile::Blizzard(Blizzard::West(Entity { x: x, y: y})),
		'>' => Tile::Blizzard(Blizzard::East(Entity { x: x, y: y})),
		'^' => Tile::Blizzard(Blizzard::North(Entity { x: x, y: y})),
		'v' => Tile::Blizzard(Blizzard::South(Entity { x: x, y: y})),
		_ => Tile::Open,
	    };
	    let num = board.len() - 1;
	    board[num as usize].push(tile);
	    x += 1;
	}
	y += 1;
    }
    let start = (1,0);
    let goal = ((board[0].len()-2) as i32, (board.len()-1) as i32);
    Ok (Board { start: start
	    , goal: goal
	    , board: board })
}

fn pass_minute(blizzards: &Vec<Blizzard>, height: i32, width: i32) -> Vec<Blizzard> {
    let mut ret_blizzards = Vec::<Blizzard>::new();
    for blizzard in blizzards {
	match blizzard {
	    Blizzard::North(b) => {
		if b.y <= 1 {
		    ret_blizzards.push(Blizzard::North(Entity {
			x: b.x,
			y: height - 2,
		    }));
		} else {
		    ret_blizzards.push(Blizzard::North(Entity {
			x: b.x,
			y: b.y - 1,
		    }));
		}
	    },
	    Blizzard::South(b) => {
		if b.y >= height - 2 {
		    ret_blizzards.push(Blizzard::South(Entity {
			x: b.x,
			y: 1,
		    }));
		} else {
		    ret_blizzards.push(Blizzard::South(Entity {
			x: b.x,
			y: b.y + 1,
		    }));
		}
	    },
	    Blizzard::East(b) => {
		if b.x >= width - 2 {
		    ret_blizzards.push(Blizzard::East(Entity {
			x: 1,
			y: b.y,
		    }));
		} else {
		    ret_blizzards.push(Blizzard::East(Entity {
			x: b.x + 1,
			y: b.y,
		    }));
		}
	    },
	    Blizzard::West(b) => {
		if b.x <= 1 {
		    ret_blizzards.push(Blizzard::West(Entity {
			x: width - 2,
			y: b.y,
		    }));
		} else {
		    ret_blizzards.push(Blizzard::West(Entity {
			x: b.x - 1,
			y: b.y,
		    }));
		}
	    },
	};
    }
    return ret_blizzards;
}

fn manhattan_distance (current: (i32,i32), goal: (i32,i32)) -> f32 {
    f32::abs((current.0-goal.0) as f32) + f32::abs((current.1-goal.1) as f32)
}

fn a_star_step(goal: (i32,i32), initial_state: State, height: i32, width: i32) -> Option<State> {
    let mut open_list = Vec::<State>::new();
    let mut closed_list = Vec::<State>::new();
    let state = initial_state;
    let mut ret_state = None;
    open_list.push(state);
    while open_list.len() > 0 {
	open_list.sort_by(|x, y| y.f.partial_cmp(&x.f).unwrap());
	let current = open_list.pop()?;
	if current.player.x == goal.0 && current.player.y == goal.1 {
	    ret_state = Some(current);
	    break;
	}
	open_list.append(&mut generate_neighbors(&current, &height, &width, goal, &closed_list, &open_list));
	closed_list.push(current);
    }
    ret_state
}

fn a_star(start: (i32,i32), goal: (i32,i32), initial_storm: Vec<Blizzard>, height: i32, width: i32) -> Option<i32> {
    let state = State {
	player: Entity { x: start.0, y: start.1},
	blizzards: initial_storm,
	f: manhattan_distance(start, goal),
	g: 0.0,
    };
    let goal_cost: i32 = a_star_step(goal, state, height, width)?.g as i32;
    Some(goal_cost)
}

fn a_star2(start: (i32,i32), goal: (i32,i32), initial_storm: Vec<Blizzard>, height: i32, width: i32) -> Option<i32> {
    let state = State {
	player: Entity { x: start.0, y: start.1},
	blizzards: initial_storm,
	f: manhattan_distance(start, goal),
	g: 0.0,
    };
    let g1 = a_star_step(goal, state, height, width)?;
    let s2 = a_star_step(start, g1, height, width)?;
    let goal_cost = a_star_step(goal, s2, height, width)?.g as i32;
    Some(goal_cost)
}

fn generate_neighbors(initial_state: &State, height: &i32, width: &i32, goal: (i32,i32), closed_list: &Vec<State>, open_list: &Vec<State>) -> Vec<State> {
    let mut neighbors = Vec::new();
    let new_blizzards = pass_minute(&initial_state.blizzards, *height, *width);
    let mut new_board = Board::empty((*width, *height));
    let current_x = initial_state.player.x as usize;
    let current_y = initial_state.player.y as usize;
    new_board.insert_blizzards(&new_blizzards);
    if initial_state.player.y-1 >= 0 && new_board.board[current_y-1][current_x] == Tile::Open{
	let new_state = State {
	    player: Entity { x: current_x as i32, y: current_y as i32 - 1},
	    blizzards: new_blizzards.clone(),
	    f: initial_state.g + 1.0 + manhattan_distance((current_x as i32, current_y as i32 - 1), goal),
	    g : initial_state.g + 1.0,
	};
	if !has_seen(&new_state, &closed_list, &open_list) {
	    neighbors.push(new_state);
	}
    }
    if initial_state.player.y+1 < *height && new_board.board[current_y+1][current_x] == Tile::Open{
	let new_state = State {
	    player: Entity { x: current_x as i32, y: current_y as i32 + 1},
	    blizzards: new_blizzards.clone(),
	    f: initial_state.g + 1.0 + manhattan_distance((current_x as i32, current_y as i32 + 1), goal),
	    g : initial_state.g + 1.0,
	};
	if !has_seen(&new_state, &closed_list, &open_list) {
	    neighbors.push(new_state);
	}
    }
    if new_board.board[current_y][current_x+1] == Tile::Open{
	let new_state = State {
	    player: Entity { x: current_x as i32 + 1, y: current_y as i32},
	    blizzards: new_blizzards.clone(),
	    f: initial_state.g + 1.0 + manhattan_distance((current_x as i32 + 1, current_y as i32), goal),
	    g : initial_state.g + 1.0,
	};
	if !has_seen(&new_state, &closed_list, &open_list) {
	    neighbors.push(new_state);
	}
    }
    if new_board.board[current_y][current_x-1] == Tile::Open{
	let new_state = State {
	    player: Entity { x: current_x as i32 - 1, y: current_y as i32},
	    blizzards: new_blizzards.clone(),
	    f: initial_state.g + 1.0 + manhattan_distance((current_x as i32 - 1, current_y as i32), goal),
	    g : initial_state.g + 1.0,
	};
	if !has_seen(&new_state, &closed_list, &open_list) {
	    neighbors.push(new_state);
	}
    }
    if new_board.board[current_y][current_x] == Tile::Open{
	let new_state = State {
	    player: Entity { x: current_x as i32, y: current_y as i32},
	    blizzards: new_blizzards.clone(),
	    f: initial_state.g + 1.0 + manhattan_distance((current_x as i32, current_y as i32), goal),
	    g : initial_state.g + 1.0,
	};
	if !has_seen(&new_state, &closed_list, &open_list) {
	    neighbors.push(new_state);
	}
    }
    neighbors
}

fn has_seen(current: &State, closed_list: &Vec<State>, open_list: &Vec<State>) -> bool {
    for s in closed_list {
	if s.player == current.player && s.blizzards == current.blizzards {
	    return true;
	}
    }
    for s in open_list {
	if s.player == current.player && s.blizzards == current.blizzards {
	    return true;
	}
    }
    false
}
    
fn main() -> Result<()>{
    let board = read_input("./resources/input")?;
    let blizzards = board.gather_blizzards();
    let part1_score = a_star(board.start, board.goal, blizzards, board.board.len() as i32, board.board[0].len() as i32);
    let blizzards = board.gather_blizzards();
    let part2_score = a_star2(board.start, board.goal, blizzards, board.board.len() as i32, board.board[0].len() as i32);
    println!("Part 1: {}", part1_score.unwrap());
    println!("Part 2: {}", part2_score.unwrap());
    Ok(())
}
