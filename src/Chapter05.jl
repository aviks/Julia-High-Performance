# ## Chapter 5

using BenchmarkTools

Sys.WORD_SIZE

bitstring(3)

bitstring(-3)

isbitstype(Int64)

isbitstype(String)


myadd(x, y) = x + y
@code_native myadd(1,2)


typemax(Int64)


bitstring(typemax(Int32))


typemin(Int64)

bitstring(typemin(Int32))

9223372036854775806 + 1

9223372036854775806 + 1 + 1

2^62

2^63

2^64

2^65

# ###BigInt

big(9223372036854775806) + 1 + 1

big(2)^64

x = rand(Int32)

y = rand(Int32)

@btime $(BigInt(y)) * $(BigInt(x)) ;

@btime $(Int64(y)) * $(Int64(x)) ;

@btime $(Int128(y)) * $(Int128(x)) ;

@btime $(Int32(y)) * $(Int32(x)) ;

# ### Floating Point

bitstring(2.5)
bitstring(-2.5)

function floatbits(x::Float64)
   b = bitstring(x)
   b[1:1]*"|"*b[2:12]*"|"*b[13:end]
end

floatbits(2.5)

floatbits(-2.5)

# ### Floating point accuracy

0.1 > 1//10


Rational(0.1)

float(big(Rational(0.1)))

bitstring(0.10000000000000001) == bitstring(0.1)

eps(0.1)

nextfloat(0.1)

floatbits(0.1)

floatbits(nextfloat(0.1))

# ### Unsigned Integers

UInt64(1)

UInt32(4294967297)   # throws InexactError

4294967297 % UInt32

@btime UInt32(1)

@btime 1 % UInt32


# ### FastMath

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

half_fast(x) = @fastmath 0.5*x

double_fast(x) = @fastmath 2.0*x

const c_fast = (half_fast ∘ double_fast)

@code_llvm c_fast(0.0)

half(x) = 0.5*x
double(x) = 2*x
c(x) = half(double(x))

@code_llvm c(0.0)



# ### KBN Summation

t=[1, -1, 1e-100];

sum(t)

using Pkg
Pkg.add("KahanSummation")
using KahanSummation

sum_kbn(t)


@btime sum($t)


@btime sum_kbn($t)

# ### Subnormal numbers

issubnormal(1.0)

issubnormal(1.0e-308)

3e-308 - 3.001e-308

issubnormal(3e-308 - 3.001e-308)

set_zero_subnormals(true)


3e-308 - 3.001e-308

3e-308 == 3.001e-308

get_zero_subnormals()

function timestep( b, a, dt )
    n = length(b)
    b[1] = 1
    two = eltype(b)(2)
    for i=2:n-1
        b[i] = a[i] + (a[i-1] - two*a[i] + a[i+1]) * dt
    end
    b[n] = 0
end

function heatflow( a, nstep )
    b = similar(a)
    o = eltype(a)(0.1)
    for t=1:div(nstep,2)
        timestep(b,a,o)
        timestep(a,b,o)
    end
end

set_zero_subnormals(false)

t=rand(1000);

@btime heatflow($t, 1000)

set_zero_subnormals(true)

@btime heatflow($t, 1000)
