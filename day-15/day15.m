#!/usr/bin/octave
inputData = regexprep(strsplit(fileread("./resources/input"), '\n'),  '^.*x=(-?\d+), y=(-?\d+).*x=(-?\d+), y=(-?\d+).*$', '$1 $2; $3 $4');

global parsedData = {};

function retval = calc_manhattan(p1, p2)
  retval = (sum(abs(p1-p2)));
endfunction

for i=1:length(inputData)
  parsedData(i) = str2num(inputData{i});
end

global manhattans = {}
small_widths = []
big_widths = []
for i=1:length(parsedData);
  manhattans(i) = sum(abs(parsedData{i}(1,:)-parsedData{i}(2,:)));
  small_widths(i) = parsedData{i}(1,1) - manhattans{i};
  big_widths(i) = parsedData{i}(2,1) + manhattans{i};
end
## global y = 10
global y = 2000000;
global min_width = min(small_widths);
global max_width = max(big_widths);

function retval = calc_slice_start(x, dist)
  global min_width;
  retval = x-dist+abs(min_width);
endfunction
function retval = calc_slice_stop(x, dist)
  global min_width;
  global y;
  retval = x+dist+abs(min_width);
endfunction


answer_row = []
for j=1:length(parsedData);
  distance = manhattans{j} - calc_manhattan([parsedData{j}(1,1), y], parsedData{j}(1,:));
  answer_row(distance >= 0, calc_slice_start(parsedData{j}(1,1), distance):calc_slice_stop(parsedData{j}(1,1), distance)) = 1;
end
for j=1:length(parsedData);
  if (parsedData{j}(2,2) == y)
    col = parsedData{j}(2,1) + abs(min_width);
    answer_row(col) = 0;
  endif
end
disp("Task 1:")
disp(sum(answer_row))

function retval = calc_point(edge, i)
  global y;
  global manhattans;
  global parsedData;
  retval = 0;
  numContains = 0;
  if (sum([edge < 0, edge > y * 2]) != 0)
    retval = 0;
    return;
  endif
  for j=1:length(parsedData)
    if (manhattans{j} - calc_manhattan(parsedData{j}(1,:), edge) <= -1)
      numContains += 1;
    endif
  end
  if (numContains == length(parsedData))
    retval = edge;
    return;
  endif
endfunction

function retval = findEdge(center, man, signal)
  global y;
  retval = 0;
  for i=1:man
    edges = [];
    if (mod(i, 1000) == 0)
      disp(i)
    endif
    edges(end+1,:) = [center(1,1) + man - i, center(1,2) + i];
    edges(end+1,:) = [center(1,1) + man - i, center(1,2) - i];
    edges(end+1,:) = [center(1,1) - man + i, center(1,2) - i];
    edges(end+1,:) = [center(1,1) - man + i, center(1,2) + i];
    for e=1:4
      ineedaname = calc_point(edges(e,:), signal);
      if (ineedaname != 0)
	retval = ineedaname;
	return;
      endif
    end
  end
  ## retval = edges;
endfunction

finalEdge = [];
for i=1:length(parsedData)
  disp("Signal: "), disp(i)
  disp(4 * (manhattans{i} + 1))
  edges = findEdge(parsedData{i}, manhattans{i} + 1, i);
  if (edges != 0)
    finalEdge = edges
    break
  endif
end

disp("Task 2:")
printf("%d\n", finalEdge(1) * 4000000 + finalEdge(2))
