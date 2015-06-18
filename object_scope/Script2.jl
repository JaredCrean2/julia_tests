# script to be executed on process 2

include("create_object.jl")

proc_num = myid()		# get process number of this thread

r2 = RemoteRef(proc_num)

a = 2

put!(r2,a)		# put value a into remote ref r2

println("r2 = ", r2)

obj3_local = fetch(RemoteRef(3,3,2))
println("obj3_local = ", obj3_local)
