# script to be executed on master process

using DataStructures

rref2 = RemoteRef(2)		# create remoteref on process 2
q2 = Queue(Int)
enqueue!(q2,1)

println("q2 = ", q2)

#put!(rref2, q2)			# put q2 into rref2





#q2_local = fetch(rref2)
#enqueue!(q2,2)			# add an element to q2_local

# check if q2 is changed

#q2_2_local = fetch(rref2)
#last_el = dequeue!(q2_2_local)

#println("last element of q2_2 = ", last_el)


