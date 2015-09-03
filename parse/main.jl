function read_args()
	arg_array = open(readdlm, "new_file.txt")

	(m,n) = size(arg_array)



	arg_dict = Dict{Any, Any}()

	for i=1:m
	  key = arg_array[i, 1]
	  value = arg_array[i, 2]
	  arg_dict[key] = value
	end

        println("var4 = ", arg_dict["var4"])
        println("typeof var4 value = ", typeof(arg_dict["var4"]))
        ex = parse(arg_dict["var4"])
        println("ex = ", ex)
        println("typeof(ex) = ", typeof(ex))
        val = eval(ex)
        println("val = ", val)
        println("typeof(val) = ", typeof(val))
   

	# take action based on the dictionary

	if haskey(arg_dict, "var1")
	  global DB_LEVEL =  arg_dict["var1"]
	else
	  global DB_LEVEL = 0
	end

	return nothing

end



#=
macro do_both (expr1, expr2)
  println("expr1 = ", expr1)
  println("expr2 = ", expr2)
  if DB_LEVEL < 2
    expr3 = :($expr1 $expr2)
    return expr3
  else
    return expr2
  end

end
=#







read_args()

# all the variables used in the macro must be defined *in the text* before they can be used in the macro
macro do_db(expr1)
  println("entered macro do_db")
#  println("expr1 = ", expr1)
#  println("typeof(expr1) = ", typeof(expr1))
  if DB_LEVEL < 2
    println("at compile time, in DB_Level < 2")
    return :(println("runtime expression"))
 #   return expr1
  else
    return nothing
  end
end


function runtest()
@do_db(println("I am a print statement"))

#@do_both(@time, println("I am another print statement"))
return nothing

end



println("running first test")
runtest()
println("\nrunning second test")
runtest()
    
 
