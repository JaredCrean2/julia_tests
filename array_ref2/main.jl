type mytype
  arr::Array{Float64,2}
end

b = rand(200,200)


obj = mytype(b)
@time obj2 = mytype(b)

println("sizeof(obj2) = ", sizeof(obj2))
println("sizeof(b) = ", sizeof(b))
