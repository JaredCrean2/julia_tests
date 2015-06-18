@everywhere using DataStructures
@everywhere include("funcs2.jl")


a = 1

rref1 = RemoteRef(1)		# create local remoteref
put!(rref1, a)

rref2 = remotecall(2, outerFunc)


println("adding element to q2 from process 1")
@spawnat 2 enqueue!(q2, rref1)
println("finished addint element to q2 from process 1")

q2_length_local = fetch(rref2)
println("q2_length_local = ", q2_length_local)
