# script to be executed on processor 2


proc_num = myid()		# get process number of this thread

r2 = RemoteRef(proc_num)
println("r2 = ", r2)

for i =1:1:5		# really long for loop
	println("i = ", i)
	put!(r2,i)		# put value a into remote ref r2
	println("finished putting i into r2")
end


