macro mac1(ex)
    
    var1 = 2
    eval(ex)
   
end

var1 = 3
b = :var1
println("b = ", eval(b))
println("typeof(b) = ", typeof(b))
ex = :(println("var1 = ", b))
 @mac1(ex)

#eval(ex)
  
