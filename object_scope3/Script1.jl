# master script

@everywhere include("create_object.jl")

rref2 = @spawnat 2 obj2 = object1(1,2)

println("fetch(rref2) = ", fetch(rref2))

#print on remote processes
@spawnat 2 println("obj2 = ", fetch(rref2), "\n")
@spawnat 3 println("obj2 = ", fetch(rref2), "\n")

# this script works if typed into command line (need to exit each println after
# it is finished)
