using ArrayViews
import ArrayViews.unsafe_view
import Base: length, size, getindex, setindex!

type FakeArray{T, N} <: AbstractArray{T,N}
  a::Array{T, N}  # in reality, a would be a functor
  buf::Array{T, 1} # buffer to hold output (temporarily)
end



  
function FakeArray(a::Array)

  T = eltype(a)
  N = length(size(a))

  return FakeArray{T, N}(a, zeros(T, size(a, 1)))
end

function getindex(arr::FakeArray, i::Integer)
  return arr.a[i]
end

function setindex(arr::FakeArray, i::Integer, v)
  return arr.a[i] = v
end


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

# define our own ArrayViews type to go along with FakeArray
# here we only support the case where we have a large array and
# we are interested in taking a view of the first dimension.
# For the more general case, just use the SubArray function in Base
# this approach is similar in performance to using a regular ArrayView

# We need the creation of a view to be nearly a no-op, ie. not copying or calculating anything
# this is important because values are sometimes passed to functions but not
# used, and we don't want there to be a performance penalty associated with that

#=
immutable FakeArrayUnsafeView{T, N} <: AbstractArray{T, N}
  a::FakeArray{T, N}
#  shp::NTuple{N, Int}
end

function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer, j::Integer)
  # calculate the quantity here, put it in the buffer
  for k=1:size(arr, 1)
    arr.buf[k] = arr.a[k, i, j]
  end
#  arr.buf[:] = arr.a[:, i, j]
  return FakeArrayUnsafeView{T, N}(arr)  # the 1 is arbitary, unused
end

function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer)
  # calculate the quantity here, put it in the buffer
  for k=1:size(arr, 1)
    arr.buf[k] = arr.a[k, i]
  end

  return FakeArrayUnsafeView{T, N}(arr)  # the 1 is arbitary, unused
end
=#

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

else
function unsafe_view{T, N}(arr::FakeArray{T, N}, arg1::Colon, i::Integer)
  tpl = (i, 1)
  av = FakeArrayView{T, N}(arr.a, tpl)  # the 1 is arbitrary, unused

  return av
 end

function getindex(arr::FakeArrayView, i::Integer)
  return arr.a[i, arr.dims[1]]
end

end



#=
function getindex(arr_view::FakeArrayUnsafeView, i::Integer)
  return arr_view.a.buf[i]
end

function length(arr_view::FakeArrayUnsafeView)
   return length(arr_view.a.buf)
end
=#

#=
function getindex(arr::FakeArray, args...)
  return getindex(arr.a, args)
end

function setindex(arr::FakeArray, args...)
  return setindex!(arr.a, args)
end
=#

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
function sum3{T}(arr::AbstractArray{T})

  val = zero(T)
  for i=1:size(arr, 2)
    arr_view = unsafe_view(arr, :, i)
    val += sum_inner(arr_view)
  end

  return val
end

function sum4{T}(arr::AbstractArray{T})

  val = zero(T)
  for i=1:size(arr, 2)
    arr_view = view(arr, :, i)
    val += sum_inner(arr_view)
  end

  return val
end

a = rand(3, 1000000)
println("sizeof(a) = ", sizeof(a)/1024, "KiB")
obj = FakeArray(a)
#printArr(obj)

println("-----Warming Up-----")
@time sum2(obj)
@time sum2(a)
@time sum3(obj)
@time sum3(a)
@time sum4(a)

println("-----Direct Sum Final Results-----")
@time sum2(obj)
println("FakeArray @time printed above")
@time sum2(a)
println("Array @time printed above")

println("\n-----Dimensional Sum Final Results-----")
@time sum3(obj)
println("FakeArray @time printed above")
@time sum3(a)
println("Array @time printed above")
@time sum4(a)
println("view Array @time printed above")

