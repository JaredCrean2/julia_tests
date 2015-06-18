using ArrayViews

#=
type mytype{T1}
  x::AbstractArray{T1, 2}
  y::AbstractArray

  function mytype(T2::DataType, n::Int)
    obj = new()  # incomplete initialization
    obj.x = rand(T1, n, n)
    obj.y = rand(T2, n, n)
    return obj
  end
end
=#

type mytype{T1}
  x::AbstractArray{T1, 2}
  y::AbstractArray{T1, 2}
  c::Float64

  function mytype(n::Int)
    obj = new()  # incomplete initialization
    obj.x = Array(T1, n, n)
    obj.y = Array(T1, n, n)
    c = 3.5
    return obj
  end
end




function addMembers{T1}(obj::mytype{T1})


    result = zero(T1)
    result= (obj.x[1] + obj.y[1]) + obj.c

  return result

end
 

function addArrays(x::AbstractArray, y::AbstractArray)

  result = x[1] + y[1]

  return result

end

 
function addMembers2{T1}(obj::mytype{T1})
  (n,n) = size(obj.x)
  result = zero(T1)
  for  i=1:n*n
     x_i = unsafe_view(obj.x, i)
     y_i = unsafe_view(obj.y, i)
     addJC(x_i, y_i, result)
#    result += obj.x[i] + obj.y[i]
  end

  return result

end

function getC(obj::mytype)

  return obj.c
end

function addJC(x, y, res)

  return res = x + y
end
      

n = 20000

#new_obj = mytype{Float64}(Float64, n)
new_obj = mytype{Float64}(n)
@code_warntype addMembers(new_obj)
@code_warntype addArrays(new_obj.x, new_obj.y)

println("printing code for getC()")
@code_warntype getC(new_obj)
println("typeof(obj.x) = ", typeof(new_obj.x))

#@time addMembers2(new_obj)
#@time addMembers2(new_obj)
