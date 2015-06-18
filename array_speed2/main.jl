include("func1.jl")
using ArrayViews


#function runtest()
n = 10000000
nnodes = 3

q = rand(4, nnodes, n)
F = Array(Float64, 4, nnodes, n)

@time func1(q, F)
println("double loop @time printed above")

gc()


@time func2(q, F)
println("ArrayView @time printed above")

gc()


#@time func2a(q, F, getEulerFlux)
#println("funcs1 @time printed above")


@time func3(q, F)
println("slice @time printed above")

gc()


#=
@time func4(q, F)
println("temporary variables @time printed above")

gc()


# get rid of q, F
q = zeros(1,1,1)
F = zeros(1,1,1)

gc()

q2 = Array(Array{Float64, 1}, nnodes, n)
F2 = Array(Array{Float64, 1}, nnodes, n)

for i=1:n
  for j=1:nnodes
    q2[j,i] = rand(4)
    F2[j,i] = zeros(4)
  end
end

println("about to start func5")
@time func5(q2, F2)
println("array of arrays @time printed above")

println("First element of F2 = ", F2[1,1])

=#

#return nothing

#end

#=
runtest()
println("Second round of testing: \n")
gc()
runtest()
=#
