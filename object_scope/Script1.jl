# script to be executed on thread 1

rref1 = @spawnat 2 include("Script2.jl")
rref2 = @spawnat 3 include("Script3.jl")

wait(rref1)
wait(rref2)

println("rref1 = ", rref1)
println("rref2 = ", rref2)

# everything above this line works

# some non working examples
#		@spawnat 2 include("funcs.jl")		# read in file containing myFunc
#		@spawnat 2 b = myFunc(1,2)			# error, myFuncs not defined 
									#(the include statement went out of scope)



# another non working example
#		@everywhere include("funcs.jl")		# read in file containing myFunc
									# using @everywhere means in won't go out of scope
#		rref2 = @spawnat 2 b = myFunc(1,2)	# works
#		println("fetch(rref2) = ", fetch(rref2))		# works
#		@spawnat 2 println("b = ", b)			# does not work, b is not in scope on process 2


# another non working example
#		@spawnat 2 include("create_object.jl")		# read in file defining type object1
#		rref2_2 = @spawnat 2 obj2 = object1(1,2)	# error: ProcessExitedException
# I think the include statement is not in scope any more, so type object1 is not defined
# but I'm not sure why the worker terminated instead of just returning an error
# as in the previous example


# yet another non working example
@everywhere include("create_object.jl")
rref2_3 = @spawnat obj2 = object1(1,2)
println("fetch(rref2_3) = ", fetch(rref2_3))
@spawnat 2 println("obj2 = ", obj2)		# error, obj2 not defined on process 2
@spawnat 2 println("obj2 = ", fetch(rref2_3))		# works, despite the name rref2_3
													# not being defind on process 2

# create an object on process 2
#		@spawnat 2 include("funcs.jl")
#		rref2_2 = @spawnat 2 b = myFunc(1,2)
#		println("fetch(rref2_2) = ", fetch(rref2_2))		# print fetched result
#		@spawnat 2 println("b = " b)			# this gives error: b not defined
#println("obj4_local = ", obj4_local)
