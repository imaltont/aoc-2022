#!/bin/Rscript 

split.vec <- function(vec, char = "") {
    is.sep <- vec == char
    t(split(vec[!is.sep], cumsum(is.sep)[!is.sep]))
}

day1_data <- readLines("./resources/input-01")

sums <- split.vec(day1_data)
sums <- lapply(sums, function(x) read.table(textConnection(paste(x, collapse = '\n'))))
sums <- lapply(sums, function(x) sum(x))

day1 <- max(unlist(sums))
day2 <- sum(unlist(sums[order(as.numeric(sums), decreasing = TRUE)[1:3]]))

print(paste("Day1 answer: ", day1))
print(paste("Day2 answer: ", day2))
