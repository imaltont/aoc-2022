#!/usr/bin/python
#dataset known to be NxN
def north_ones(trees):
    visible = [[0 for x in range(len(trees))] for y in range(len(trees))]
    for i in range(0, len(trees)):
        prev_max = -1
        for j in range(0, len(trees)):
            if trees[j][i] > prev_max:
                prev_max = trees[j][i]
                visible[j][i] = 1
    return visible
def south_ones(trees):
    visible = [[0 for x in range(len(trees))] for y in range(len(trees))]
    for i in range(0, len(trees)):
        prev_max = -1
        for j in range(len(trees)-1, -1, -1):
            if trees[j][i] > prev_max:
                prev_max = trees[j][i]
                visible[j][i] = 1
    return visible
def east_ones(trees):
    visible = [[0 for x in range(len(trees))] for y in range(len(trees))]
    for i in range(0, len(trees)):
        prev_max = -1
        for j in range(0, len(trees)):
            if trees[i][j] > prev_max:
                prev_max = trees[i][j]
                visible[i][j] = 1
    return visible
def west_ones(trees):
    visible = [[0 for x in range(len(trees))] for y in range(len(trees))]
    for i in range(0, len(trees)):
        prev_max = -1
        for j in range(len(trees)-1, -1, -1):
            if trees[i][j] > prev_max:
                prev_max = trees[i][j]
                visible[i][j] = 1
    return visible
def check_overlap(north, east, west, south):
    visible = [[0 for x in range(len(north))] for y in range(len(north))]
    for i in range(len(visible)):
        for j in range(len(visible)):
            if north[i][j] == 1 or east[i][j] == 1 or south[i][j] == 1 or west[i][j] == 1:
                visible[i][j] = 1
    return visible
def count_trees(tree):
    sum = 0
    for line in tree:
        for t in line:
            sum = sum + t
    return sum

def part2(trees):
    max_spot = 0
    for i in range(1, len(trees)-1):
        for j in range (1, len(trees)-1):
            max_height = trees[i][j]
            count_north = 0
            count_east = 0
            count_west = 0
            count_south = 0
            offset_x = 1
            offset_y = 1
            for x in range(i-1, -1, -1):
                count_north = count_north + 1
                if trees[x][j] >= max_height:
                    break
            for x in range(i+1, len(trees)):
                count_south = count_south + 1
                if trees[x][j] >= max_height:
                    break
            for x in range(j-1, -1, -1):
                count_east = count_east + 1
                if trees[i][x] >= max_height:
                    break
            for x in range(j+1, len(trees)):
                count_west = count_west + 1
                if trees[i][x] >= max_height:
                    break
            # print(count_north , count_south , count_east , count_west)
            current_spot = count_north * count_south * count_east * count_west
            if current_spot > max_spot:
                max_spot = current_spot
    return max_spot

f = open("./resources/input", "r")
lines = f.readlines()
trees = []
for l in lines:
    trees.append([])
    for ch in l:
        if ch != '\n':
            trees[-1].append(int(ch))
north = north_ones(trees)
east = east_ones(trees)
west = west_ones(trees)
south = south_ones(trees)
print("".join(["Part 1: ", str(count_trees(check_overlap(north,east,west,south)))]))
print("".join(["Part 2: ", str(part2(trees))]))
