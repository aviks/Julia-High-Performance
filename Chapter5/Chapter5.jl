# # Chapter 5

WORD_SIZE

bitstring(3)

bitstring(-3)

isbitstype(Int64)

isbitstype(String)


myadd(x, y) = x + y
@code_native myadd(1,2)


julia> typemax(Int64)


julia> bitstring(typemax(Int32))


julia> typemin(Int64)

julia> bitstring(typemin(Int32))


julia> 9223372036854775806 + 1

julia> 9223372036854775806 + 1 + 1

2^64

2^65

# ##BigInt

julia> big(9223372036854775806) + 1 + 1

julia> big(2)^64

# ## Floating Point

julia> bitstring(2.5)
julia> bitstring(-2.5)

# ##Unchecked conversions

UInt64(1)
UInt32(4294967297)
4294967297 % UInt32
@btime UInt32(1)
@btime 1 % UInt32


# ## FastMath

function sum_diff(x)
    n = length(x); d = 1/(n-1)
    s = zero(eltype(x))
    s = s +  (x[2] - x[1]) / d
    for i = 2:length(x)-1
        s =  s + (x[i+1] - x[i+1]) / (2*d)
    end
    s = s + (x[n] - x[n-1])/d
end

function sum_diff_fast(x)
    n=length(x); d = 1/(n-1)
    s = zero(eltype(x))
    @fastmath s = s +  (x[2] - x[1]) / d
    @fastmath for i = 2:n-1
        s =  s + (x[i+1] - x[i+1]) / (2*d)
    end
    @fastmath s = s + (x[n] - x[n-1])/d
end

t=rand(2000);
@btime sum_diff($t)
@btime sum_diff_fast($t)

macroexpand(Main, :(@fastmath a + b / c))

# ## KBN Summation
