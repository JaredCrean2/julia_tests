using PDESolverCommon

# warm up
function testmatvec()
  A_ = rand(3,3)
  x_ = rand(3)
  b_ = zeros(3)
  smallmatvec!(A_, x_, b_)
  b__ = A_*x_

  println("b = ", b_)
  println("b2 = ", b__)

  max_size = 128
  num_trials = 3
  times = zeros(max_size, 2)

  for trial=1:num_trials

    for i=1:128  # sizes of matrices to test
      A = rand(i, i)
      x = rand(i)
      b = zeros(i)

      println("size $i results:")
      elapsed_time = @elapsed smallmatvec!(A, x, b)
      times[i,1] += elapsed_time

      elapsed_time = @elapsed A*x
      times[i,2] += elapsed_time
      gc()
    end

  end

  times = times./num_trials

  return times
end

function testmatmat()
  A_ = rand(3,3)
  x_ = rand(3, 3)
  b_ = zeros(3, 3)
  smallmatmat!(A_, x_, b_)
  b__ = A_*x_

  println("b = ", b_)
  println("b2 = ", b__)

  max_size = 128
  num_trials = 3
  times = zeros(max_size, 2)

  for trial=1:num_trials

    for i=1:128  # sizes of matrices to test
      A = rand(i, i)
      x = rand(i, i)
      b = zeros(i, i)

      println("size $i results:")
      elapsed_time = @elapsed smallmatmat!(A, x, b)
      times[i,1] += elapsed_time

      elapsed_time = @elapsed A*x
      times[i,2] += elapsed_time
      gc()
    end

  end

  times = times./num_trials

  return times
end


function print_results(times)

  m, n = size(times)
  for i=1:m
    small_t = times[i, 1]
    large_t = times[i, 2]
    println("trial $i results ", times[i, :], ", small/large = ", small_t/large_t)
   end

end


times = testmatvec()
println("printing matvec results")
print_results(times)

times = testmatmat()
println("printing matmat results")
print_results(times)

