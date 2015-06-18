arg_array = open(readdlm, "new_file.txt")

(m,n) = size(arg_array)

if n != 2
  println("Error: format of argument array is incorrect")
end

arg_dict = Dict{Any, Any}()

for i=1:m
  key = arg_array[i, 1]
  value = arg_array[i, 2]
  arg_dict[key] = value
end
 

# take action based on the dictionary

if haskey(arg_dict, "var1")
  global const DB_LEVEL =  arg_dict["var1"]
end


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


macro do_db(expr1)
  println("expr1 = ", expr1)
  println("typeof(expr1) = ", typeof(expr1))
  if DB_LEVEL < 2
    return expr1
  else
    return nothing
  end
end

@do_db(println("I am a print statement"))

@do_both(@time, println("I am another print statement"))

    
 
