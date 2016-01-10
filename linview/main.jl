# create a simple prototype of a linear view type
using ArrayViews

include("linview.jl")
include("unsafe_linview.jl")
include("func1.jl")
function runtest()
n = 3000000
nnodes = 3

obj = eulerFluxObj()

q = rand(4, nnodes, n)
F = Array(Float64, 4, nnodes, n)

@time func1(q, F)
println("double loop @time printed above")

gc()


@time func2(q, F)
println("unsafe ArrayView @time printed above")

gc()

@time func2a(q, F)
println("safe ArrayView @time printed above")

gc()



#@time func3(q, F)
#println("slice @time printed above")

gc()


@time func6(obj, q, F)
println("callable object @time printed above")

gc()

@time func7(q, F)
println("safe LinView @time printed above")

@time func8(q, F)
println("unsafe LinView @time printed above")


gc()
return nothing

end

println("warming up")
runtest()
println("\nFinal testing: \n")
gc()
runtest()

