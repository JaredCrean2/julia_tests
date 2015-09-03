include("funcs1.jl")


function runtest()
n = 5000000  # size of vector
SL = rand(n)

gc()

# create array of indicies to modify
indices = ceil(Int, n*rand(3,n) )
vals = rand(3,n)


@time func1(SL, indices, vals, n)
println("subarray function time printed above")

gc()

@time func2(SL, indices, vals, n)
println("slice notation function printed above")

gc()

@time func3(SL, indices, vals, n)
println("double loop function time printed above")
gc()


@time func4(SL, indices, vals, n)
println("ArrayView function time printed above")
gc()



@time func5(SL, indices, vals, n, +)
println("double operator argument time printed above")
gc()


@time func5a{+}(SL, indices, vals, n, +)
println("operator parameter argument time printed above")
gc()




@time func6(SL, indices, vals, n, true)
println("boolean operator argument time printed above")
gc()

@time func7(SL, indices, vals, n, false)
println("function conditional call  argument time printed above")
gc()

#=
#@time func8(SL, indices, vals, n, true)
#println("macro hardcoded  time printed above")
#gc()

#global symx = :(esc(:(:SL[esc(index_i)] += esc(val_i))))  
symx = :(SL[index_i] += 2)

@time func9(SL, indices, vals, n, symx   )
println("function call  argument time printed above")
gc()
=#



end

#=
macro plusequals(SL, index_i, val_i)
   return :($SL[$index_i] += $val_i)
end
=#

function fplusequals(SL::AbstractArray{Float64, 1}, index_i::Integer, val_i::Float64)
  SL[index_i] += val_i
end

function fminusequals(SL, index_i, val_i)
  SL[index_i] -= val_i
end
runtest()
