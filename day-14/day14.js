#!/usr/bin/node
var fs = require("fs");
function readFile(path) {
    return fs.readFileSync(path);
}
function range(start, stop) {
    if (start === stop) {
	return []
    }
    numbers = []
    if (start <= stop) {
	for (let i = start; i <= stop; i++) {
	    numbers.push(i)
	}
    } else {
	for (let i = start; i >= stop; i--) {
	    numbers.push(i)
	}
    }
    return numbers
}
function checkNext(currentPoint, board){
    if (currentPoint[0]+1 >= board.length) {
	return false
    }
    let mid = board[currentPoint[0] + 1][currentPoint[1]]
    let left = board[currentPoint[0] + 1][currentPoint[1] - 1]
    let right = board[currentPoint[0] + 1][currentPoint[1] + 1]
    if (mid !== undefined && mid === 0) {
	return [currentPoint[0] + 1, currentPoint[1]]
    } else if (left !== undefined && left === 0) {
	return [currentPoint[0] + 1, currentPoint[1] - 1]
    } else if (right !== undefined && right === 0) {
	return [currentPoint[0] + 1, currentPoint[1] + 1]
    } else if (mid && right && left) {
	return currentPoint
    }
    return false
}
function fall(sand, board) {
    let old = false
    let current = sand
    while (current && (current[0] !== old[0] || current[1] !== old[1])) {
	old = current
	current = checkNext(current,board)
    }
    return current
}
function parseInput(start,part2) {
    let board = [...Array(1000).keys()].map(x => [...Array(1000).keys()].map(y => 0))
    let inputLines = readFile("./resources/input").toString()
    let lowestPoint = 0
    inputLines.split(/\r?\n/).forEach(line => {
	let old = false
	line.replace(/\s/g, "").split(/->/).forEach(destination => {
	    destination = destination.split(/,/)
	    if (!old) {
		old = [Number(destination[1]),Number(destination[0])]
		board[old[0]][old[1]] = 1
	    }
	    let newDest = [Number(destination[1]),Number(destination[0])]
	    if (newDest[0] > lowestPoint) {
		lowestPoint = newDest[0]
	    } 
	    for (let height of range(old[0], newDest[0])) {
		board[height][old[1]] = 1
	    }
	    for (let width of range(old[1], newDest[1])) {
		board[old[0]][width] = 1
	    }
	    old = newDest
	})
    })
    if (part2) {
	for (let x of range(0,999)) {
	    board[lowestPoint+2][x] = 1
	}
    }
    return board
}
function simulation(part2) {
    let start = [0,500]
    let sandCounter = 0
    let board = parseInput(start, part2)
    board[start[0]][start[1]] = 1
    while (true) {
	newSand = fall(start, board)
	if (!newSand || (newSand[0] === start[0] && newSand[1] === start[1])) {
	    return sandCounter
	}
	board[newSand[0]][newSand[1]] = 3
	sandCounter = sandCounter + 1
    }
}
console.log(`Part 1: ${simulation(false)}`)
console.log(`Part 2: ${1+simulation(true)}`)
