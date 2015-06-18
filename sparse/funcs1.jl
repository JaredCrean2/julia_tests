
function makeSparse(n)
# generate sparse symmetric matrix
# (the ugly way)

entry= 1
f = zeros(n,n)
for i=1:n  # row number
  for j=(i-3):i
    if (j < 1)
      continue
    end
    f[i,j] = entry
    f[j,i] = entry
    entry += 1
  end
end

return sparse(f)

end


