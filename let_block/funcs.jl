function initfunc()
# supply initial value for x
  println("entered initfunc()")
  return 4
end

let
  x = initfunc()  # initilization required

  function getfunc()
     println("x = ", x)
  end

  function setfunc(y)
    println("setting x = ", y)
    x = y
  end

end

function initfunc()
# supply initial value for x

  return 4
end
