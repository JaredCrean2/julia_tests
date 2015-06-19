module Mod1
using NumericFuns
#import NumericFuns.evaluate
#using Mod2
export func1

function func1(f::Functor, a, b)

  for i=1:1000
    evaluate(f, a[i], b[i])
  end
end

end
