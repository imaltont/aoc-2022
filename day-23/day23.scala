#!/usr/bin/scala
!#
import scala.language.postfixOps
import scala.collection.mutable.Map
import scala.util.control.Breaks._
import scala.io.Source

object Day23 {
  def main(args: Array[String]) : Unit = {
    val inputFile = "./resources/input"
    var board = getMap(inputFile)
    part1(board)
    var board2 = getMap(inputFile)
    part2(board2)
  }
  def getMap(path : String) : Map[(Int,Int), Boolean] = {
    var y = 0;
    var board : Map[(Int,Int), Boolean] = Map()
    for (line <- Source.fromFile(path).getLines()) {
      var x = 0;
      y += 1
      for (ch <- line) {
        x += 1
        if (ch == '#')
          board += ((x,y) -> true)
      }
    }
    return board
  }
  def part1(board: Map[(Int,Int), Boolean]) : Unit = {
    var numElves = board.keys.size
    var funcs = Array(checkEast _, checkNorth _, checkSouth _, checkWest _)
    for (i <- 1 to 10) {
      var movement : Map[(Int,Int),(Int,Int)] = Map()
      var destinationCounts : Map[(Int,Int), Int] = Map()
      for (elf <- board.keys) {
        var foundMove : Boolean = false
        var suggestion : (Int,Int) = elf
        if (shouldMove(board, elf)) {
          for (j <- 0 to funcs.size - 1) {
            if (!foundMove) {
              var res = funcs((i+j) % 4)(board,elf)
              foundMove = res._1
              suggestion = res._2
            }
          }
        }
        movement += (elf -> suggestion)
        if (!destinationCounts.keySet.contains(suggestion))
          destinationCounts += (suggestion -> 1)
        else
          destinationCounts(suggestion) += 1
      }
      for (elf <- movement.keys) {
        if (destinationCounts(movement(elf)) == 1) {
          board -= elf
          board += (movement(elf) -> true)
        }
      }
    }
    var maxX, maxY = Int.MinValue
    var minX, minY = Int.MaxValue
    for (elf <- board.keys) {
      var (x, y) = elf
      if (x > maxX)
        maxX = x
      if (x < minX)
        minX = x
      if (y > maxY)
        maxY = y
      if (y < minY)
        minY = y
    }
    println("Part 1: " + (((maxX-minX+1) * (maxY-minY+1)) - numElves))
  }
  def part2(board: Map[(Int,Int), Boolean]) : Unit = {
    var numElves = board.keys.size
    var funcs = Array(checkEast _, checkNorth _, checkSouth _, checkWest _)
    var numRounds = 0
    var hasMoved = true
    var i = 0
      while (hasMoved) {
        i += 1
        var movement : Map[(Int,Int),(Int,Int)] = Map()
        var destinationCounts : Map[(Int,Int), Int] = Map()
        for (elf <- board.keys) {
          var foundMove : Boolean = false
          var suggestion : (Int,Int) = elf
          if (shouldMove(board, elf)) {
            for (j <- 0 to funcs.size - 1) {
              if (!foundMove) {
                var res = funcs((i+j) % 4)(board,elf)
                foundMove = res._1
                suggestion = res._2
              }
            }
          }
          movement += (elf -> suggestion)
          if (!destinationCounts.keySet.contains(suggestion))
            destinationCounts += (suggestion -> 1)
          else
            destinationCounts(suggestion) += 1
        }
        for (elf <- movement.keys) {
          if (destinationCounts(movement(elf)) == 1) {
            board -= elf
            board += (movement(elf) -> true)
          }
        }
        if (!checkAll(board)) {
          hasMoved = false
          numRounds = i
        }
      }
    println("Part 2: " + (numRounds + 1))
  }
  def checkAll (elves: Map[(Int,Int),Boolean]) : Boolean = {
    var shouldMoveAll = false
    for (elf <- elves.keys) {
      if (!shouldMoveAll)
        shouldMoveAll = shouldMove(elves, elf)
    }
    return shouldMoveAll
  }
  def shouldMove (elves: Map[(Int,Int),Boolean], elf: (Int, Int)) : Boolean = {
    var (x, y) = elf
    if (!elves.keySet.contains((x,y-1))
      && !elves.keySet.contains((x-1,y-1))
      && !elves.keySet.contains((x,y+1))
      && !elves.keySet.contains((x+1,y+1))
      && !elves.keySet.contains((x-1,y))
      && !elves.keySet.contains((x-1,y+1))
      && !elves.keySet.contains((x+1,y))
      && !elves.keySet.contains((x+1,y-1)))
      return false
    return true
  }
  def checkNorth (elves: Map[(Int,Int),Boolean], elf: (Int, Int)) : (Boolean, (Int, Int)) = {
    var (x, y) = elf
    if (!elves.keySet.contains((x,y-1))
      && !elves.keySet.contains((x-1,y-1))
      && !elves.keySet.contains((x+1,y-1)))
      return (true, (x, y-1))
    return (false, elf)
  }
  def checkSouth (elves: Map[(Int,Int),Boolean], elf: (Int, Int)) : (Boolean, (Int, Int)) = {
    var (x, y) = elf
    if (!elves.keySet.contains((x,y+1))
      && !elves.keySet.contains((x-1,y+1))
      && !elves.keySet.contains((x+1,y+1)))
      return (true, (x, y+1))
    return (false, elf)
  }
  def checkWest (elves: Map[(Int,Int),Boolean], elf: (Int, Int)) : (Boolean, (Int, Int)) = {
    var (x, y) = elf
    if (!elves.keySet.contains((x-1,y))
      && !elves.keySet.contains((x-1,y + 1))
      && !elves.keySet.contains((x-1,y - 1)))
      return (true, (x-1, y))
    return (false, elf)
  }
  def checkEast (elves: Map[(Int,Int),Boolean], elf: (Int, Int)) : (Boolean, (Int, Int)) = {
    var (x, y) = elf
    if (!elves.keySet.contains((x+1,y))
      && !elves.keySet.contains((x+1,y + 1))
      && !elves.keySet.contains((x+1,y - 1)))
      return (true, (x+1, y))
    return (false, elf)
  }
}
