include("funcs1.jl")

s = makeSparse(10000)
gc()
#println("s = ", full(s))
println("finished creating matrix", sizeof(s))
sleep(10)
s = cholfact(s)
gc()
println("finished factorization, size = ", sizeof(s))
sleep(10)
println("exiting")

