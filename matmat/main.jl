using PDESolverCommon
#OPENBLAS_NUM_THREADS=1
ENV["OPENBLAS_NUM_THREADS"] = 1
# warm up
function testmatvec(max_size)
  A_ = rand(3,3)
  x_ = rand(3)
  b_ = zeros(3)
  smallmatvec!(A_, x_, b_)
  b__ = A_*x_

  println("b = ", b_)
  println("b2 = ", b__)

#  max_size = 128
  num_trials = 3
  times = zeros(max_size, 2)

  for trial=1:num_trials

    for i=1:max_size  # sizes of matrices to test
      A = rand(i, i)
      x = rand(i)
      b = zeros(i)

      println("trial $trial size $i results:")
      elapsed_time = @elapsed smallmatvec!(A, x, b)
      println("  elapsed time = ", elapsed_time)
      times[i,1] += elapsed_time

      elapsed_time = @elapsed A*x
      times[i,2] += elapsed_time
      gc()
    end

  end

  times = times./num_trials

  return times
end

function testmatmat(max_size)
  A_ = rand(3,3)
  x_ = rand(3, 3)
  b_ = zeros(3, 3)
  smallmatmat!(A_, x_, b_)
  b__ = A_*x_

  println("b = ", b_)
  println("b2 = ", b__)

#  max_size = 255
  num_trials = 3
  times = zeros(max_size, 2)

  for trial=1:num_trials

    for i=1:max_size  # sizes of matrices to test
      A = rand(i, i)
      x = rand(i, i)
      b = zeros(i, i)

      println("trial $trial size $i results:")
      elapsed_time = @elapsed smallmatmat!(A, x, b)
      println("elapsed_time = ", elapsed_time)
      times[i,1] += elapsed_time

      elapsed_time = @elapsed A*x
      times[i,2] += elapsed_time
      gc()
    end

  end

  times = times./num_trials

  return times
end



function testmatmatT(max_size)
  A_ = rand(3,3)
  x_ = rand(3, 3)
  b_ = zeros(3, 3)
  smallmatmatT!(A_, x_, b_)
  b__ = A_*(x_.')

  println("b = ", b_)
  println("b2 = ", b__)

#  max_size = 255
  num_trials = 3
  times = zeros(max_size, 2)

  for trial=1:num_trials

    for i=1:max_size  # sizes of matrices to test
      A = rand(i, i)
      x = rand(i, i)
      b = zeros(i, i)

      println("trial $trial size $i results:")
      elapsed_time = @elapsed smallmatmatT!(A, x, b)
      println("  elapsed time = ", elapsed_time)
      times[i,1] += elapsed_time

      elapsed_time = @elapsed A*(x.')
      times[i,2] += elapsed_time
      gc()
    end

  end

  times = times./num_trials

  return times
end



function print_results(times, data, col)

  m, n = size(times)
  for i=1:m
    small_t = times[i, 1]
    large_t = times[i, 2]
    ratio = small_t/large_t
    data[i, col] = ratio
    println("trial $i results ", times[i, :], ", small/large = ", ratio)
   end

end

nump =128
data = zeros(nump, 3)
for i=1:nump
  data[i] = i
end

times = testmatvec(nump)
println("printing matvec results")
print_results(times, data, 2)


writedlm("matvec_compare.dat", data)


# now do mat-mat multiplication

nump =96 
data = zeros(nump, 3)
for i=1:nump
  data[i] = i
end



times = testmatmat(nump)
println("printing matmat results")
print_results(times, data, 2)

#=
times = testmatmatT(nump)
println("printing matmatT results")
print_results(times, data, 3)
=#
writedlm("matmat_compare.dat", data)

