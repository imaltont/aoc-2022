#include<iostream>
#include<fstream>
#include <ostream>
#include<string>
#include<vector>
#include<array>

using namespace std;

struct shape {
  std::vector<long> x;
  std::vector<long> y;
};

struct state {
  int next_shape;
  int next_jet;
  std::array<long, 7> floor;
  long height;
};

enum direction {
  down,
  left,
  right
};

//this assumes it gets the spawn-height, not the board height
shape create_shape(int8_t type, long height) {
  shape sh;
  switch (type) {
  case 0:
    sh.x = { 2, 3, 4, 5 };
    sh.y = { height, height, height, height };
    break;
  case 1:
    sh.x = { 3, 2, 3, 4, 3 };
    sh.y = { height, height+1, height+1, height+1, height+2 };
    break;
  case 2:
    sh.x = { 2, 3, 4, 4, 4 };
    sh.y = { height, height, height, height+1, height+2 };
    break;
  case 3:
    sh.x = { 2, 2, 2, 2 };
    sh.y = { height, height+1, height+2, height+3 };
    break;
  case 4:
    sh.x = { 2, 3, 2, 3 };
    sh.y = { height, height, height+1, height+1 };
    break;
  }
  return sh;
}

long find_height(std::vector<std::array<long, 7>> board) {
  for(long i = board.size() - 1; i >= 0; --i) {
    for (long j = 0; j < board[i].size(); ++j) {
      if (board[i][j] != 0) {
	return i+1;
      }
    }
  }
  return 0;
}

bool check_collision(shape rock, direction dir, std::vector<std::array<long, 7>> board) {
  if (dir == down) {
    for (long i = 0; i < rock.y.size(); ++i) {
      if (rock.y[i] == 0 || board[rock.y[i] - 1][rock.x[i]] != 0)
        return false;
    }
  } else if (dir == direction::left) {
    for (long i = 0; i < rock.y.size(); ++i) {
      if (rock.x[i] == 0 || board[rock.y[i]][rock.x[i] - 1] != 0)
        return false;
    }
  } else if (dir == direction::right) {
    for (long i = 0; i < rock.y.size(); ++i) {
      if (rock.x[i] == 6 || board[rock.y[i]][rock.x[i] + 1] != 0)
        return false;
    }
  }
  return true;
}

void print_board(std::vector<std::array<long, 7>> board) {
  for(long i = board.size() - 1; i >= 0; --i) {
    cout << "|";
    for (long j = 0; j < board[i].size(); ++j) {
      if (board[i][j] == 0)
	cout << ".";
      else
	cout << "#";
    }
    cout << "|" << endl;
  }
  cout << "+-------+";
}

long simulation(std::string jets, long num_rocks) {
  std::vector<std::array<long, 7>> board;
  long jet_counter = 0;
  ulong max_jets = jets.length();
  for (long i = 0; i < num_rocks; ++i) {
    if (i % 100000 == 0) {
      cout << "Progress: " << i << " of " << num_rocks << endl;
    }
      
    long cur_height = find_height(board) + 3;
    shape rock = create_shape(i % 5, cur_height);
    if (5 + cur_height - board.size() > 0){
      for (long n = 0; n <= 5 + cur_height - board.size(); ++n) {
        board.push_back({0, 0, 0, 0, 0, 0, 0});
      }
    }
    while (true) {
      // Jet logic
      if (jets[jet_counter] == '<') {
        if (check_collision(rock, direction::left, board)) {
          for (long x = 0; x < rock.x.size(); ++x) {
            rock.x[x] -= 1;
          }
        }
      } else if (jets[jet_counter] == '>') {
        if (check_collision(rock, direction::right, board)) {
          for (long x = 0; x < rock.x.size(); ++x) {
            rock.x[x] += 1;
          }
        }
      }
      jet_counter = (jet_counter + 1) % max_jets;
      // Fall logic
      if (check_collision(rock, down, board)) {
        for (long y = 0; y < rock.y.size(); ++y) {
          rock.y[y] -= 1;
        }
      } else {
        break;
      }
    }
    for (long x = 0; x < rock.x.size(); ++x) {
      board[rock.y[x]][rock.x[x]] = 1;
    }
  }
  return find_height(board);
}

long repeat_rocks(vector<state> prev_states, state new_state, long num_jets) {
  long repeat_index = -1;
  if (prev_states.size() > 0) {
    for (int i = 0; i < prev_states.size(); ++i) {
      if (i % num_jets * 5 != 0)
	continue;
      if (prev_states[i].next_jet != new_state.next_jet)
	continue;
      if (prev_states[i].next_shape != new_state.next_shape)
	continue;
      bool isEqual = true;
      for (int n = 0; n < 7; ++n) {
	if (prev_states[i].floor[n] != new_state.floor[n]) {
	  isEqual = false;
	  break;
	}
      }
      if (isEqual) {
        repeat_index = i;
        break;
      }
    }
  }
  return repeat_index;
}
//ufly repeat of code because tired and easiest
long simulation2(std::string jets, long num_rocks) {
  std::vector<std::array<long, 7>> board;
  vector<state> prev_states;
  ulong jet_counter = 0;
  ulong max_jets = jets.length();
  long repeat_index = 0;
  long repeat_found = 0;
  long repeat_height = 0;
  for (long i = 0; i < num_rocks; ++i) {
    if (i % 100000 == 0) {
      cout << "Progress: " << i << " of " << num_rocks << endl;
    }

    long cur_height = find_height(board) + 3;
    shape rock = create_shape(i % 5, cur_height);
    if (5 + cur_height - board.size() > 0){
      for (long n = 0; n <= 5 + cur_height - board.size(); ++n) {
        board.push_back({0, 0, 0, 0, 0, 0, 0});
      }
    }
    state new_state;
    new_state.next_jet = jet_counter;
    new_state.next_shape = i % 5;
    new_state.height = find_height(board);
    if (find_height(board) == 0)
      new_state.floor = board[0];
    else
      new_state.floor = board[find_height(board) - 1];
    long rep = repeat_rocks(prev_states, new_state, max_jets);
    if (rep != -1) {
      repeat_index = rep;
      repeat_found = i;
      repeat_height = new_state.height - prev_states[rep].height;
      break;
    }
    prev_states.push_back(new_state);
    while (true) {
      // Jet logic
      if (jets[jet_counter] == '<') {
        if (check_collision(rock, direction::left, board)) {
          for (long x = 0; x < rock.x.size(); ++x) {
            rock.x[x] -= 1;
          }
        }
      } else if (jets[jet_counter] == '>') {
        if (check_collision(rock, direction::right, board)) {
          for (long x = 0; x < rock.x.size(); ++x) {
            rock.x[x] += 1;
          }
        }
      }
      jet_counter = (jet_counter + 1) % max_jets;
      // Fall logic
      if (check_collision(rock, down, board)) {
        for (long y = 0; y < rock.y.size(); ++y) {
          rock.y[y] -= 1;
        }
      } else {
        break;
      }
    }
    for (long x = 0; x < rock.x.size(); ++x) {
      board[rock.y[x]][rock.x[x]] = 1;
    }
  }
  long num_repeating_rocks = repeat_found - repeat_index;
  long remaining = num_rocks - repeat_found;
  long remaining_rest = remaining % num_repeating_rocks;
  long score = find_height(board) + (remaining / num_repeating_rocks) * repeat_height;
  score += prev_states[remaining_rest + repeat_index].height - prev_states[repeat_index].height;

  return score;
}

int main() {
  std::ifstream inputFile;
  inputFile.open("./resources/input");
  std::string jets;
  if (inputFile.is_open()) {
    inputFile >> jets;
  }
  inputFile.close();
  long part1 = simulation(jets, 2022);
  cout << "Part 1: ";
  cout << part1 << endl;
  long part2 = simulation2(jets, 1000000000000);
  cout << "Part 2: ";
  cout << part2 << endl;
  return 0;
}
