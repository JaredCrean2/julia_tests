using ArrayViews

type mytype{T}
  arr::Array{T, 4}
end

function func1(q::AbstractArray)
# do some work
  tmp = q.*q
  return nothing
end



function runtest(obj)
(tmp, tmp, nnodes, numel) = size(obj.arr)

for i=1:numel
  for j=1:nnodes
    for k=1:2
      q_vals = unsafe_view(obj.arr, k, :, j, i)
      func1(q_vals)
     end
  end
end

end

function runtest2(obj)
(tmp, tmp, nnodes, numel) = size(obj.arr)

q_vals = zeros(2)
for i=1:numel
  for j=1:nnodes
    for k=1:2
      q_vals[1] = obj.arr[k, 1, j, i]
      q_vals[2] = obj.arr[k, 2, j, i]
      func1(q_vals)
     end
  end
end

end

# run the test
big_array = rand(2,2, 3, 50000)
obj = mytype{Float64}(big_array)

runtest(obj)
@time runtest(obj)

runtest2(obj)
@time runtest2(obj)




