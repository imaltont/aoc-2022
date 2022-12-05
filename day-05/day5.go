package main

import (
	"bufio"
	"container/list"
	"log"
	"os"
	"strconv"
	"strings"
	"math"
)
func main() {
	log.Println("Part 1:", part1(readFile("./resources/input")))
	log.Println("Part 2:", part2(readFile("./resources/input")))
}

type Action struct {
	fromPile int
	toPile int
	amount int
}

func part1(data []list.List, actions []Action) string {
	for i := 0; i < len(actions); i++ {
		for j := 0; j < actions[i].amount;j++ {
			val := data[actions[i].fromPile-1].Front()
			data[actions[i].toPile-1].PushFront(val.Value)
			data[actions[i].fromPile-1].Remove(val)
		}
	}
	answer := ""

	for i := 0; i < len(data); i++ {
		answer = answer + data[i].Front().Value.(string)
	}
	return answer
}
func part2(data []list.List, actions []Action) string {
	for i := 0; i < len(actions); i++ {
		dummyList := list.New()
		for j := 0; j < actions[i].amount;j++ {
			val := data[actions[i].fromPile-1].Front()
			dummyList.PushFront(val.Value)
			data[actions[i].fromPile-1].Remove(val)
		}
		for l := dummyList.Front();l != nil; l = l.Next() {
			if l.Value != nil {
				data[actions[i].toPile-1].PushFront(l.Value.(string))
			}
		}
	}
	answer := ""

	for i := 0; i < len(data); i++ {
		answer = answer + data[i].Front().Value.(string)
	}
	return answer
}
func readFile(path string) ([]list.List, []Action){
	f, err := os.Open(path)
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)
	var dummyBoard []list.List
	var board []list.List
	var moves []Action

	//set up board
	for scanner.Scan() {
		scannedText := scanner.Text()
		if !strings.Contains(scannedText, "[") {
			break
		}
		numElements := int(math.Floor(float64(len(scannedText)) / 4.0)) + 1
		if len(board) == 0 {
			dummyBoard = make([]list.List, numElements)
			board = make([]list.List, numElements)
			for i:=0; i < numElements; i++ {
				dummyBoard[i] = *list.New().Init()
				board[i] = *list.New().Init()
			}
		}
		index := 0
		for i := 0; i < numElements; i++ {
			if string(scannedText[index * 4 + 2]) != " " {
				dummyBoard[i].PushFront(string(scannedText[index * 4 + 1]))
			}
			index++
		}
		for i := 0; i < numElements; i++ {
			for l := dummyBoard[i].Front(); l != nil; l = l.Next(){
				if l.Value == nil {
					break
				}
				board[i].PushFront(string(l.Value.(string)))
			}
		}
		//do something
	}
	for scanner.Scan() {
		scannedText := scanner.Text()
		var splitString []string = strings.Split(scannedText, " ")
		if len(splitString) != 1{
			amount,_ := strconv.ParseInt(splitString[1], 10, 32)
			from,_ := strconv.ParseInt(splitString[3], 10, 32)
			to,_ := strconv.ParseInt(splitString[5], 10, 32)
			moves = append(moves, Action{
				fromPile: int(from),
				toPile: int(to),
				amount: int(amount),
			})
		}
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	return board, moves
}

