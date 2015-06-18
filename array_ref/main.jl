module newmodule
type new_type
  x::Array{Float64,1}
end

end

import newmodule

vals = rand(50)
obj1 = new_type(vals)  # use default constructor

@time x2 = obj1.x
@time obj2 = obj1
global const obj3 = obj1

obj3 = 1

#obj3.x[2] = -1

println("obj3.x = ", obj3.x)
println("obj1.x = ", obj1.x)
