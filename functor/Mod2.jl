
module Mod2
using NumericFuns
#import NumericFuns.Functor
import NumericFuns.evaluate
#using Mod1
export mymult

  type mymult <: Functor{2} end
#  global evaluate
function  evaluate(::mymult, x::Number, y::Number)
  z = x*y  # define evaluate function
  println("x*y = ", z)
end

#=
function func1(f::Functor, a, b)

  for i=1:1000
    evaluate(f, a[i], b[i])
  end
end
=#

end # end module
    
