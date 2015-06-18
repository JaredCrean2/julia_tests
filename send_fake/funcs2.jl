# functions to be executed on process 2

function outerFunc()
# module DataStructures must be available

q2 = Queue(Int)		# create a queue

# call other function to do work
for i=1:100
	yield			# allows other tasks to run
	println("i = ", i, "length(q2) = ", length(q2))
	test_matrix = rand(300,300)
	(U,S,V) = svd(test_matrix)
end


return length(q2)

end


