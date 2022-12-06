#!/usr/bin/runhaskell
module Main where
import Prelude

main = 
  parseInput "./resources/input" 4 1 >> parseInput "./resources/input" 14 2

parseInput path n d = do
  content <- readFile path
  putStr $ "Part " ++ show d ++ ": "
  print $ n + findFirstUniqueSubstring content n 0
  return content

findFirstUniqueSubstring string n count =
  case hasUniqueSubstring $ take n string of
    True -> count
    _ -> case string of
               (_:tail) -> findFirstUniqueSubstring tail n $ 1 + count
               _ -> count

hasUniqueSubstring string =
  case string of
    (head:tail) -> case Prelude.elem head tail of
                      True -> False
                      False -> hasUniqueSubstring tail
    _ -> True
