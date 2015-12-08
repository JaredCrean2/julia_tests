using ArrayViews

function main()

  ndofPerNode = 4
  nnodesPerElement = 3
  numEl = 4000

  q_arr = Array(Float64, ndofPerNode, nnodesPerElement, numEl)
  flux = similar(q_arr)
  nrm = Array(Float64, 2, nnodesPerElement, numEl)

  for k = 1:numEl
    for j=1:nnodesPerElement
      q_arr[1, j, k] = 1.0
      q_arr[2, j, k] = 2.0
      q_arr[3, j, k] = 3.0
      q_arr[4, j, k] = 7.0

      nrm[1, j, k] = sqrt(2)/2
      nrm[2, j, k] = sqrt(2)/2
    end
  end

  @time getEulerFlux2(q_arr, nrm, flux)

#  println("q_arr = \n", q_arr)
#  println("flux = \n", flux)
end


function getEulerFlux(q_arr, nrm, flux)
# calculate Euler flux for entire mesh
# q is ndofPerNode x nnodesPerElement x numEl

  for k = 1:size(q_arr, 3)  # loop over elements
    for j = 1:size(q_arr, 2)  # loop over nodes on element
      calcEulerFlux(view(q_arr, :, j, k), view(nrm, :, j, k), view(flux, :, j, k))
    end
  end

end  # end function



function getEulerFlux2(q_arr, nrm, flux)
# calculate Euler flux for entire mesh
# q is ndofPerNode x nnodesPerElement x numEl

  for k = 1:size(q_arr, 3)  # loop over elements
    for j = 1:size(q_arr, 2)  # loop over nodes on element
      gamma = 1.4
      gamma_1 = 0.4

      press = gamma_1*(q_arr[4, j, k] - 0.5*(q_arr[2, j, k]*q_arr[2, j, k] + q_arr[3, j, k]*q_arr[3, j, k])/q_arr[1, j, k])
      U = (q_arr[2, j, k]*nrm[1, j, k] + q_arr[3, j, k]*nrm[2, j, k])/q_arr[1, j, k]
      flux[1,j,k] = q_arr[1,j,k]*U
      flux[2,j,k] = q_arr[2,j,k]*U + nrm[1,j,k]*press
      flux[3,j,k] = q_arr[3,j,k]*U + nrm[2,j,k]*press
      flux[4,j,k] = (q_arr[4,j,k] + press)*U

    end
  end

end  # end function


function calcEulerFlux(q, dir, F)

  gamma = 1.4
  gamma_1 = 0.4

  press = gamma_1*(q[4] - 0.5*(q[2]*q[2] + q[3]*q[3])/q[1])
  U = (q[2]*dir[1] + q[3]*dir[2])/q[1]
  F[1] = q[1]*U
  F[2] = q[2]*U + dir[1]*press
  F[3] = q[3]*U + dir[2]*press
  F[4] = (q[4] + press)*U
end


main()  # warm up the JIT
main()
