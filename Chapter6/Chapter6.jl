# Chapter 6

function col_iter(x)
    s=zero(eltype(x))
    for i = 1:size(x, 2)
       for j = 1:size(x, 1)
          s = s + x[j, i] ^ 2
          x[j, i] = s
       end
    end
end

function row_iter(x)
   s=zero(eltype(x))
   for i = 1:size(x, 1)
      for j = 1:size(x, 2)
       s = s + x[i, j] ^ 2
         x[i, j] = s
      end
   end
end

a = rand(1000, 1000);

@btime col_iter($a)

@btime row_iter($a)



 ## Bounds Checking

 function prefix_bounds(x, y)
   for i = 2:size(x, 1)
     x[i] = y[i-1] + y[i]
   end
end

function prefix_inbounds(x, y)
   @inbounds for i = 2:size(x, 1)
     x[i] = y[i-1] + y[i]
   end
end

a=zeros(Float64, 1000);

b=rand(1000);

@btime prefix_bounds($a, $b)

@btime prefix_inbounds($a, $b)
