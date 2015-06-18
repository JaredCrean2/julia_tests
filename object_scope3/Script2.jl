# script 2

include("create_object.jl")

num = myid()
r2 = RemoteRef(num)

put!(r2, num)
