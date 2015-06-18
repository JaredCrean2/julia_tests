# master file

@everywhere include("Slave.jl")
# init section

n_domains = 4		# number of sub-domains
n_points = 30		# number of points per side of each sub-domain

# initial values for each sub-domain
u1 = ones(n_points,n_points)
u2 = 2*ones(n_points,n_points)
u3 = 3*ones(n_points,n_points)
u4 = 4*ones(n_points,n_points)

# get initial interface values
i1 = u1[n_points,:]
i2_l = u1[:,n_points]
i3_b = u1[1,:]
i4 = u1[:,1]

i5 = u2[n_points,:]
i6 = u2[:,n_points]
i7_b = u2[1,:]
i2_r = u2[:,1]

i3_u = u3[n_points,:]
i8_l = u3[:,n_points]
i9 = u3[1,:]
i10 = u3[:,1]

i7_u = u4[n_points,:]
i11 = u4[:,n_points]
i12 = u4[1,:]
i8_r = u4[:,1]

# create remote references
u1_ref = RemoteRef(2)
u2_ref = RemoteRef(3)
u3_ref = RemoteRef(4)
u4_ref = RemoteRef(5)

put!(u1_ref, u1)
put!(u2_ref, u2)
put!(u3_ref, u3)
put!(u4_ref, u4)

i1_ref = RemoteRef(2)
i2_l_ref = RemoteRef(2)
i3_b_ref = RemoteRef(2)
i4_ref = RemoteRef(2)

put!(i1_ref, i1)
put!(i2_l_ref, i2_l)
put!(i3_b_ref, i3_b)
put!(i4_ref, i4)

i5_ref = RemoteRef(3)
i6_ref = RemoteRef(3)
i7_b_ref = RemoteRef(3)
i2_r_ref = RemoteRef(3)

put!(i5_ref, i5)
put!(i6_ref, i6)
put!(i7_b_ref, i7_b)
put!(i2_r_ref, i2_r)

i3_u_ref = RemoteRef(4)
i8_l_ref = RemoteRef(4)
i9_ref = RemoteRef(4)
i10_ref = RemoteRef(4)

put!(i3_u_ref, i3_u)
put!(i8_l_ref, i8_l)
put!(i9_ref, i9)
put!(i10_ref, i10)

i7_u_ref = RemoteRef(5)
i11_ref = RemoteRef(5)
i12_ref = RemoteRef(5)
i8_r_ref = RemoteRef(5)

put!(i7_u_ref, i7_u)
put!(i11_ref, i11)
put!(i12_ref, i12)
put!(i8_r_ref, i8_r)


# timestep
for i=1:1000
	p2_return = remotecall(2, evalRHS, u1_ref, i1_ref, i2_r_ref, i3_u_ref, i4_ref)
	p3_return = remotecall(3, evalRHS, u2_ref, i5_ref, i6_ref, i7_u_ref, i2_l_ref)
	p4_return = remotecall(4, evalRHS, u3_ref, i3_b_ref, i8_r_ref, i9_ref, i10_ref)
	p5_return = remotecall(5, evalRHS, u4_ref, i7_b_ref, i11_ref, i12_ref, i8_l_ref)
#	p2_fetch = fetch(p2_return)		# get all returned values

#	println("p2_return = ", p2_return)
#	println("typeof(p2_return) = ", typeof(p2_return))

#	println("typeof(p2_fetch) = ", typeof(p2_fetch))
#	u1_ret = remotecall_fetch(2, getindex, p2_return, 1)
#	u2_ret = remotecall_fetch(3, getindex, p3_return, 1)
#	u3_ret = remotecall_fetch(4, getindex, p4_return, 1)
#	u4_ret = remotecall_fetch(5, getindex, p5_return, 1)
	
	# get RemoteRef of each interface
	i1_ref = remotecall(2, getindex, p2_return, 2)
	i2_l_ref = remotecall(2, getindex, p2_return, 3)
	i3_b_ref = remotecall(2, getindex, p2_return, 4)
	i4_ref = remotecall(2, getindex, p2_return, 5)

	i5_ref = remotecall(3, getindex, p3_return, 2)
	i6_ref = remotecall(3, getindex, p3_return, 3)
	i7_b_ref = remotecall(3, getindex, p3_return, 4)
	i2_r_ref = remotecall(3, getindex, p3_return, 5)

	i3_u_ref = remotecall(4, getindex, p4_return, 2)
	i8_l_ref = remotecall(4, getindex, p4_return, 3)
	i9_ref = remotecall(4, getindex, p4_return, 4)
	i10_ref = remotecall(4, getindex, p4_return, 5)

	i7_u_ref = remotecall(5, getindex, p5_return, 2)
	i11_ref = remotecall(5, getindex, p5_return, 3)
	i12_ref = remotecall(5, getindex, p5_return, 4)
	i8_r_ref = remotecall(5, getindex, p5_return, 5)

#	println("typeof(i1_ref) = ", i1_ref)
	println("i = ", i)
#	println("u1_ret = ", u1_ret)
#	println("u2_ret = ", u2_ret)
#	println("u3_ret = ", u3_ret)
#	println("u4_ret = ", u4_ret)
#	println("\n")


end


