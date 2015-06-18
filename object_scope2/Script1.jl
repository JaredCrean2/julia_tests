# master script

@everywhere include("create_object.jl")

rref2 = @spawnat 2 include("Script2.jl")
wait(rref2)

@spawnat 3 include("Script3.jl")


# script3 gives error: r2 not defined

