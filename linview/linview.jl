import Base.setindex!, Base.getindex
immutable LinView{T, N1,  N2} <: AbstractArray{T, N1}
  arr::Array{T, N2}
  offset::Int
end

function Linview{T}(arr::Array{T, 3}, arg1::Colon, idx1::Integer, idx2::Integer)
  (s1, s2, s3) = size(arr)
  offset = (idx2-1)*s1*s2 + (idx1-1)*s1
  return LinView{T,1, 3}(arr, offset)
end


#function Base.setindex!{ T2 <: Real}(linview::LinView, idx1::Integer, v::T2)
#  linview.arr[idx1 + linview.offset] = v
#end

function getindex(linview::LinView, idx1::Integer)
  return linview.arr[idx1 + linview.offset]
end

function setindex!(linview::LinView, v, idx1::Real)
  linview.arr[idx1 + linview.offset] = v
end


function Base.size(linview::LinView)
  return (size(linview.arr, 1), )
end

#=
# test
println("testing linview:")
a = rand(2, 3, 4)
av = Linview(a, :, 1, 1)

println("a = ", a)
println("av = ", av)
println("av[1] = ", av[1])
setindex!(av, 1.1, 1)
println("av[1] = ", av[1])

av[1] = 1.2
println("av[1] = ", av[1])
=#


