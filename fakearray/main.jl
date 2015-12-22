using ArrayViews
import ArrayViews.unsafe_view
import Base: length, size, getindex, setindex!

include("funcs.jl")

type FakeArray{T, N, Tfunc} <: AbstractArray{T,N}
  a::Array{T, N}
  func::Tfunc
  buf::Array{T, 1} # buffer to hold output (temporarily)
end



  
function FakeArray(a::Array, func)

  T = eltype(a)
  N = length(size(a))

  return FakeArray{T, N, typeof(func)}(a, func, zeros(T, size(a, 1)))
end


function getindex(arr::FakeArray, i::Integer)
  idx = ind2sub(arr.a, i)
  q_view = unsafe_view(arr.a, :, idx[2], idx[3])
  arr.func(q_view, arr.buf)
 
  return arr.buf[idx[1]]
end

#=
function getindex(arr::FakeArray, i::Integer, j::Integer)
  return arr.a[i, j]
end
=#
function getindex(arr::FakeArray, i::Integer, j::Integer, k::Integer)
  q_view = unsafe_view(arr.a, :, j, k)
  arr.func(q_view, arr.buf) 
  return arr.buf[i]
end


#=
function setindex(arr::FakeArray, i::Integer, v)
  idx = ind2sub(arr.a, i)
  q_view = unsafe_view(arr.a, :, idx[2], idx[3])
  arr.func(q_view, arr.buf)
  return arr.buf[idx[1]]= v
end
#=
function setindex(arr::FakeArray, i::Integer, j::Integer, v)
  return arr.a[i, j] = v
end
=#
function setindex(arr::FakeArray, i::Integer, j::Integer, k::Integer, v)
  return arr.a[i, j, k] = v
end
=#


function length(arr::FakeArray)
  return length(arr.a)
end

function size(arr::FakeArray, i::Integer)
  return size(arr.a, i)
end

function printArr(arr::FakeArray)
  for i=1:length(arr)
    println("element $i = ", arr[i])
  end
end
#=
immutable FakeArrayView{T, N} <: AbstractArray{T, N}
  a::Array{T,N}  # in reality, a would be a functor
  dims::NTuple{N, Int}
end

function size(arr::FakeArrayView)
  return (size(arr.a, 1),)
end

function length(arr::FakeArrayView)
  return size(arr)[1]
end
=#
# define our own ArrayViews type to go along with FakeArray
# here we only support the case where we have a large array and
# we are interested in taking a view of the first dimension.
# For the more general case, just use the SubArray function in Base
# this approach is similar in performance to using a regular ArrayView

# We need the creation of a view to be nearly a no-op, ie. not copying or calculating anything
# this is important because values are sometimes passed to functions but not
# used, and we don't want there to be a performance penalty associated with that

if false
function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer)
  # calculate the quantity here, put it in the buffer
  for k=1:size(arr, 1)
    arr.buf[k] = arr.a[k, i]
  end

  return arr.buf  # the 1 is arbitary, unused
end

elseif false
function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer)
  # calculate the quantity here, put it in the buffer
#  for k=1:size(arr, 1)
#    arr.buf[k] = arr.a[k, i]
#  end

  return unsafe_view(arr.a, arg1, i)  # the 1 is arbitary, unused
end

elseif false
function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer)
  tpl = (i, 1)
  av = FakeArrayView{T, N}(arr.a, tpl)  # the 1 is arbitrary, unused

  return av
 end

function getindex(arr::FakeArrayView, i::Integer)
  return arr.a[i, arr.dims[1]]
end

else
function unsafe_view(arr::FakeArray, arg1::Colon, i::Integer, j::Integer)
  q_view = unsafe_view(arr.a, :, i, j)
  arr.func(q_view, arr.buf)
  return arr.buf
end

end



function sum_inner{T}(arr::AbstractArray{T})
  val = zero(T)
  for i=1:length(arr)
    val += arr[i]
  end

  return val
end

# direct sum
function sum2{T}(arr::AbstractArray{T})
  val = zero(T)
  for i=1:length(arr)
    val += arr[i]
  end

  return val
end


# sum over dimension
function sum3{T}(arr::FakeArray{T})

  val = zero(T)
  for i=1:size(arr, 3)
    for j=1:size(arr, 2)
      arr_view = unsafe_view(arr, :, j, i)
      val += sum_inner(arr_view)
    end
  end

  return val
end

function sum3{T}(arr::Array{T}, F_arr::Array{T})
# perform sum      
  val = zero(T)
  for i=1:size(arr, 3)
    for j=1:size(arr, 2)
      arr_view = unsafe_view(F_arr, :, j, i)
      val += sum_inner(arr_view)
    end
  end

  return val
end


function getFlux(arr::Array, F_arr::Array)
# calculate Euler flux
  for i=1:size(arr, 3)
    for j=1:size(arr, 2)
      f_view = unsafe_view(F_arr, :, j, i)
      q_view = unsafe_view(arr, :, j, i)
      calcEulerFlux(q_view, f_view)
    end
  end

  return nothing
end
#=
function sum4{T}(arr::AbstractArray{T})

  val = zero(T)
  for i=1:size(arr, 2)
    arr_view = view(arr, :, i)
    val += sum_inner(arr_view)
  end

  return val
end
=#

#####################################################################
n = 5000000
a = zeros(4, 3, n)
for i=1:n
  for j=1:3
    a[1] = 1.0
    a[2] = 2.0
    a[3] = 3.0
    a[4] = 7.0
  end
end
F_arr = zeros(size(a))

println("sizeof(a) = ", sizeof(a)/1024, "KiB")
obj = FakeArray(a, FluxType())
#printArr(obj)

println("-----Warming Up-----")
@time getFlux(a, F_arr)
@time sum2(obj)
@time sum2(a)
@time sum3(obj)
@time sum3(a, F_arr)
#@time sum4(a)

println("-----Direct Sum Final Results-----")
@time sum2(obj)
println("FakeArray @time printed above")
@time getFlux(a, F_arr)
println("  finished getting flux")
@time sum2(F_arr)
println("Array @time printed above")

println("\n-----Dimensional Sum Final Results-----")
@time sum3(obj)
println("FakeArray @time printed above")
@time getFlux(a, F_arr)
println("finished getting flux")
@time sum3(a, F_arr)
println("Array @time printed above")
#@time sum4(a)
#println("view Array @time printed above")

