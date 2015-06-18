

macro printExp(expr)
   println("expr.head = ", expr.head)
   println("expr.args = ", expr.args)
   println("expr.typ = ", expr.typ)

   global i
   return quote
     for i = 1:10
       expr
     end
   end
end

function func1{T}(q::AbstractArray{T,2})
     i = 0
     ex = @printExp println("i = ", i)
     println("ex = ", ex)
#    @printExp b = q[i,1] + q[i,2]^2 + q[i,3]^2 - q[i,4]
    #b = q[1] + q[2]^2 + q[3]^2 - q[4]


#    return b
end


