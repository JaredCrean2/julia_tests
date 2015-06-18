#=
function setindex!(A::Array{Float64,1}, x::Array{Float64,1}, indices::Array{Int64,1})
# override default methods for A[indices] = x, where x and indices are vectors

println("entered modified setindex")

(m,) = size(x)
for i=1:m
  A[indices[i]] = x[i]
end

return nothing

end
=#

using ArrayViews

macro plusequals(SL, index_i, val_i)
   return :($SL[$index_i] += $val_i)
end

macro minusequals(SL, index_i, val_i)
   return :($SL[$index_i] -= $val_i)
end




function func1(SL, indices, vals,  n)

  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      sub_array = sub(SL, index_i)
      sub_array += val_i
    end
  end

end

function func2(SL, indices, vals, n)

  for i=1:n
    indices_i = indices[:, i]
    vals_i = vals[:,i]
#    println("indices_i = ", indices_i)
#    println("vals_i = ", vals_i)
 
#    println("typeof(indicies_i) = ", typeof(indices_i), " typeof(vals_i) = ", typeof(vals_i), " typeof(SL) = ", typeof(SL))
    SL[indices_i] += vals_i
  end

end

function func3(SL, indices, vals, n)

  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      SL[index_i] += val_i
    end
  end

end

function func4(SL, indices, vals, n)
# using the ArrayViews package

  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      vSL = unsafe_view(SL, index_i)
      vSL += val_i
    end
  end

end





function func5(SL, indices, vals, n, op1)

  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      SL[index_i] = op1(SL[index_i], val_i)
    end
  end

end

function func6(SL, indices, vals, n, isplus::Bool)

  if isplus
    op1 = +
  else
    op1 = -
  end

  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      SL[index_i] = op1(SL[index_i], val_i)
    end
  end

end

function func7(SL, indices, vals, n, isplus::Bool)

#=
  if isplus
    op1 = plusequals
  else
    op1 = minusequals
  end
=#
  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]

      if isplus
        SL[index_i] -= val_i
      else
        SL[index_i] += val_i
      end
#      op1(SL, index_i, val_i)
#      SL[index_i] = op1(SL[index_i], val_i)
    end
  end

end

function func8(SL, indices, vals, n, isplus::Bool)


  for i=1:n
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]

      @plusequals(SL, index_i, val_i)
#      op1(SL, index_i, val_i)
#      SL[index_i] = op1(SL[index_i], val_i)
    end
  end

end


function func9(SL, indices, vals, n, f)

  println("typeof(f) = ", typeof(f))
  eval(f)

  for i=1:n
    println("i = ", i)
    for j=1:3
      index_i = indices[j, i]
      val_i = vals[j,i]
      eval(f)
#      SL[index_i] += val_i
      
#      @inline f(SL, index_i, val_i)
#      op1(SL, index_i, val_i)
#      SL[index_i] = op1(SL[index_i], val_i)
    end
  end

end








#=
function plusequals(SL, index_i, val_i)
  SL[index_i] += val_i
end

function minusequals(SL, index_i, val_i)
  SL[index_i] -= val_i
end
=#
