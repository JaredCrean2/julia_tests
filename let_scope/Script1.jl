# script to be executed on process 1

@everywhere include("funcs2.jl")


rref2 = remotecall(2, testFunc, 3)

b_local = fetch(rref2)

println("b_fetched = ", b_local)

#@spawnat 2 println("b = ", b)
