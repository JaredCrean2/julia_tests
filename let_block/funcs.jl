function initfunc()
# supply initial value for x
  println("entered initfunc()")
  return ones(100000)
end

global getfunc
global setfunc
let
  x = initfunc()

  function getfunc()
     println("x = ", x[1])
  end

  function setfunc(y)
    println("setting x[1] = ", y)
    x[1] = y
  end
end
#=
function initfunc()
# supply initial value for x

  return 4
end
=#
