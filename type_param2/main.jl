type mytype{T, T2}
  x::T
  y::T

  function mytype(x_)
  return new(x_, x_)
  end

end

function func1{T}(obj::mytype{T, 2})
  println("2D version of func1")
  println("typeof(obj) = ", typeof(obj))
end

function func1{T}(obj::mytype{T,3})
  println("3D version of func1")
  println("typeof(obj) = ", typeof(obj))
end
