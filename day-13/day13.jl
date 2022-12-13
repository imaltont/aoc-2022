#!/usr/bin/julia
compare(arr1::Int64,arr2::Int64) =
    if arr1 == arr2
        -1
    else
        arr1 < arr2
    end
compare(arr1::Vector,arr2::Int64) =
    compare(arr1,[arr2])
compare(arr1::Int64,arr2::Vector) =
    compare([arr1],arr2)
function compare(arr1::Vector,arr2::Vector)
    retval = -1
    for v in zip(arr1,arr2)
        c = compare(v[1],v[2])
        if c != -1
            retval = c
            break
        end
    end
    if retval != -1
        retval
    else
        if length(arr1) == length(arr2)
            -1
        else
            length(arr1) < length(arr2)
        end
    end
end
function part1(path)
    input = readlines(path)
    pair1 = []::Vector{Any}
    pair2 = []::Vector{Any}
    index = 1
    for line in input
        if index % 3 == 1
            push!(pair1, eval(Meta.parse(line)))
        elseif index % 3 == 2
            push!(pair2, eval(Meta.parse(line)))
        end
        index = index + 1
    end
    index = 1
    results = []
    for p in zip(pair1,pair2)
        if compare(p[1],p[2])
            push!(results, index)
        end
        index = index + 1
    end
    sum(results)
end
function part2(path)
    input = readlines(path)
    signals = []::Vector{Any}
    index = 1
    for line in input
        if index % 3 != 0
            push!(signals, eval(Meta.parse(line)))
        end
        index = index + 1
    end
    push!(signals, [[2]])
    divider1 = length(signals)
    push!(signals, [[6]])
    divider2 = length(signals)
    indices = sortperm(signals, lt=compare)
    divider1_res = 0
    divider2_res = 0
    index = 1
    for ind in indices
        if divider1 == ind
            divider1_res = index
        end
        if divider2 == ind
            divider2_res = index
        end
        index = index + 1
    end
    divider1_res * divider2_res
end

print("Part 1: ")
print(part1("./resources/input"))
print("\n")
print("Part 2: ")
print(part2("./resources/input"))
print("\n")
