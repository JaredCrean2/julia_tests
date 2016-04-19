include("func1.jl")




function runtest()
#n = 300000
n = 300000
nnodes = 3
ndir = 10
obj = eulerFluxObj()

q = rand(4, ndir,  nnodes, n)
F = Array(Float64, 4, ndir, nnodes, n)

@time func1(q, F)
println("double loop @time printed above")

gc()


@time func2(q, F)
println("unsafe ArrayView @time printed above")

gc()

#=
@time func2a(q, F)
println("safe ArrayView @time printed above")

gc()

@time func2b(q, F)
println("switchable ArrayView @time printed above")

gc()



@time func3(q, F)
println("slice @time printed above")

gc()

if VERSION >= v"0.4.3-pre+6"
  @time func4(q, F)
  println("unsafe slice @time printed above")

  gc()

end


@time func6(obj, q, F)
println("callable object @time printed above")


gc()
=#
return nothing

end

println("warming up")
runtest()
println("\nFinal testing: \n")
gc()
runtest()

