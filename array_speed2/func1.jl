# different ways to calculate the Euler flux






function func1(q, F_xi)
    getEulerFlux(q, F_xi)
  return nothing
end


function func2(q, F_xi)

   (ncomp, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
#         q_j = unsafe_view(q, :, j, i)
#         F_j = unsafe_view(q, :, j, i)
         q_j = unsafe_view(q, :, j, i)
         F_j = unsafe_view(q, :, j, i)

         getEulerFlux(q_j, F_j)
      end
   end

   return nothing

end



function func3(q, F_xi)

    (ncomp, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
         q_j = slice(q, :, j, i)
         F_j = slice(q, :, j, i)
         getEulerFlux(q_j, F_j)
      end
   end

  return nothing
end

function func6(obj, q, F_xi)
    
   (ncomp, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
         q_j = unsafe_view(q, :, j, i)
         F_j = unsafe_view(q, :, j, i)
         obj(q_j, F_j)  # function call
      end
   end

   return nothing
end




function getEulerFlux{T}( q::AbstractArray{T,3},  F_xi::AbstractArray{T,3})
# loop over big arrays to calculate euler flux

(ncomp, nnodes, nel) = size(q)  # get sizes of things

  for i=1:nel  # loop over elements
    for j=1:nnodes  # loop over nodes within element
      # get direction vector components (xi direction)
      nx = 1
      ny = 0
      # calculate pressure 
      press = (1.4-1)*(q[4, j, i] - 0.5*(q[2, j, i]^2 + q[3, j, i]^2)/q[1, j, i])

      # calculate flux in xi direction
      # hopefully elements of q get stored in a register for reuse in eta direction
      U = (q[2, j, i]*nx + q[3, j, i]*ny)/q[1, j, i]
      F_xi[1, j, i] = q[1, j, i]*U
      F_xi[2, j, i] = q[2, j, i]*U + nx*press
      F_xi[3, j, i] = q[3, j, i]*U + ny*press
      F_xi[4, j, i] = (q[4, j, i] + press)*U
    end
  end

  return nothing

end

function getEulerFlux{T}( q::AbstractArray{T,1}, F_xi::AbstractArray{T,1})
# get flux at single node 
      # get direction vector components (xi direction)
      nx = 1
      ny = 0
      # calculate pressure 
      press = (1.4-1)*(q[4] - 0.5*(q[2]^2 + q[3]^2)/q[1])

      # calculate flux in xi direction
      # hopefully elements of q get stored in a register for reuse in eta direction
      U = (q[2]*nx + q[3]*ny)/q[1]
      F_xi[1] = q[1]*U
      F_xi[2] = q[2]*U + nx*press
      F_xi[3] = q[3]*U + ny*press
      F_xi[4] = (q[4] + press)*U

     return nothing
end
 

type eulerFluxObj
end

function call(obj::eulerFluxObj, q, F_xi)
# get flux at single node 
      getEulerFlux(q, F_xi)
end


