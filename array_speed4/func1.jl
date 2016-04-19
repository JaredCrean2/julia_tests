# different ways to calculate the Euler flux

be_safe = 1
# if boundchecking is enabled, be_safe gets incremented twice
# if no boundschecking, be_safe only gets incremented once
using ArrayViews

if be_safe == 1
  println("using safe ArrayView")
  global const sview = ArrayViews.view
else
  println("using unsafe ArrayView")
  global const sview = ArrayViews.unsafe_view
end



# double for loop
function func1(q, F_xi)
    getEulerFlux(q, F_xi)
  return nothing
end

# unsafe view
function func2(q, F_xi)

   (ncomp, ndir, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
#         q_j = unsafe_view(q, :, j, i)
#         F_j = unsafe_view(q, :, j, i)
         q_j = unsafe_view(q, :, k, j, i)
         F_j = unsafe_view(q, :, k, j, i)

         getEulerFlux(q_j, F_j)
       end
      end
   end

   return nothing

end

# safe view
function func2a(q, F_xi)

   (ncomp, ndir, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
#         q_j = unsafe_view(q, :, j, i)
#         F_j = unsafe_view(q, :, j, i)
         q_j = view(q, :,k, j, i)
         F_j = view(q, :,k, j, i)

         getEulerFlux(q_j, F_j)
       end
      end
   end

   return nothing

end

function func2b(q, F_xi)

   (ncomp, ndir, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
#         q_j = unsafe_view(q, :, j, i)
#         F_j = unsafe_view(q, :, j, i)
         q_j = sview(q, :,k, j, i)
         F_j = sview(q, :,k, j, i)

         getEulerFlux(q_j, F_j)
       end
      end
   end

   return nothing

end



# slice
function func3(q, F_xi)

    (ncomp, ndir, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
         q_j = slice(q, :, k, j, i)
         F_j = slice(q, :, k, j, i)
         getEulerFlux(q_j, F_j)
       end
      end
   end

  return nothing
end

# unsafe slice
function func4(q, F_xi)

    (ncomp, ndir, nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
         q_j = Base._slice_unsafe(q, (:, k, j, i))
         F_j = Base._slice_unsafe(q, (:, k, j, i))
         getEulerFlux(q_j, F_j)
       end
      end
   end

  return nothing
end



function func6(obj, q, F_xi)
    
   (ncomp, ndir,  nnodes,  nel) = size(q)
   for i=1:nel
      for j=1:nnodes
        for k=1:ndir
         q_j = unsafe_view(q, :,k,  j, i)
         F_j = unsafe_view(q, :,k,  j, i)
         obj(q_j, F_j)  # function call
       end
      end
   end

   return nothing
end




function getEulerFlux{T}( q::AbstractArray{T,4},  F_xi::AbstractArray{T,4})
# loop over big arrays to calculate euler flux

(ncomp, ndir, nnodes, nel) = size(q)  # get sizes of things

  for i=1:nel  # loop over elements
    for j=1:nnodes  # loop over nodes within element
      for k=1:ndir
      # get direction vector components (xi direction)
      nx = 1
      ny = 0
      # calculate pressure 
      press = (1.4-1)*(q[4,k, j, i] - 0.5*(q[2,k, j, i]^2 + q[3,k, j, i]^2)/q[1,k, j, i])

      # calculate flux in xi direction
      # hopefully elements of q get stored in a register for reuse in eta direction
      U = (q[2,k, j, i]*nx + q[3,k, j, i]*ny)/q[1,k, j, i]
      F_xi[1, k, j, i] = q[1, k,  j, i]*U
      F_xi[2, k, j, i] = q[2, k, j, i]*U + nx*press
      F_xi[3, k, j, i] = q[3, k, j, i]*U + ny*press
      F_xi[4, k, j, i] = (q[4,k,  j, i] + press)*U
    end
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


