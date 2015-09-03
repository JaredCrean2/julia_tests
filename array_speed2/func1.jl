# different ways to calculate the Euler flux

abstract BCTypes
type eulerFluxObj <: BCTypes
end

function call(obj::eulerFluxObj, q, F_xi)
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

function func6{T <: BCTypes}(obj::T, q, F_xi)
    
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






function func1(q, F_xi)
    getEulerFlux(q, F_xi)
  return nothing
end


function func2(q, F_xi)

   (ncomp, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
         q_j = unsafe_view(q, :, j, i)
         F_j = unsafe_view(q, :, j, i)
         getEulerFlux(q_j, F_j)
      end
   end

   return nothing

end

function func2a(q, F_xi, func_name::Function)

   (ncomp, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
         q_j = unsafe_view(q, :, j, i)
         F_j = unsafe_view(q, :, j, i)
         func_name(q_j, F_j::UnsafeContiguousView{Float64,1})::Void
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

function func4(q, F_xi)
     (ncomp, nnodes,  nel) = size(q)

   q_j = zeros(4)
   F_j = zeros(4)
   for i=1:nel
      for j=1:nnodes
        for k=1:4
          q_j[k] = q[ k, j, i]
          F_j[k] = 0.0
        end
         getEulerFlux(q_j, F_j)
        for k=1:4
          F_xi[k, j, i] = F_j[k]
        end
      end
   end

  return nothing
end

function func5{T}(q::AbstractArray{T, 2}, F_xi::AbstractArray{T,2})

    ( nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
         q_j = q[j,i]
         F_j = F_xi[j,i]
         getEulerFlux(q_j, F_j)

#         if ( i == 1 && j == 1)
#           println("F_j 1,1 = ", F_j)
#         end
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
 
