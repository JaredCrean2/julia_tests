import Base.setindex!, Base.getindex
immutable UnsafeLinView{T, N1,  N2} <: AbstractArray{T, N1}
  arr::Ptr{T}
  len::Int
end

function unsafe_Linview{T}(arr::Array{T, 3}, arg1::Colon, idx1::Integer, idx2::Integer)
  (s1, s2, s3) = size(arr)
  offset = (idx2-1)*s1*s2 + (idx1-1)*s1
  return UnsafeLinView{T,1, 3}(pointer(arr) + offset*sizeof(T), s1)
end


#function Base.setindex!{ T2 <: Real}(linview::LinView, idx1::Integer, v::T2)
#  linview.arr[idx1 + linview.offset] = v
#end

function getindex(linview::UnsafeLinView, idx1::Integer)
  return unsafe_load(linview.arr, idx1)
end

function setindex!(linview::UnsafeLinView, v, idx1::Real)
#  println("typeof(linview) = ", typeof(linview))
  unsafe_store!(linview.arr, v, idx1)
end


function Base.size(linview::UnsafeLinView)
  return (linview.len, )
end

#=
# test
println("testing unsafe Linview:")
a = rand(2, 3, 4)
av = unsafe_Linview(a, :, 1, 1)

println("a = ", a)
println("av = ", av)
println("av[1] = ", av[1])
setindex!(av, 1.1, 1)
println("av[1] = ", av[1])

av[1] = 1.2
println("av[1] = ", av[1])
=#


