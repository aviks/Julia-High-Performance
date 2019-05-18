using BenchmarkTools


# ## Starting a Cluster

procs()

# change to 2 if started julia with -p2
addprocs(4)

procs()

# addprocs(["10.0.2.1", "10.0.2.2"]) ;

# ## Communication between Julia processes

a = remotecall(sqrt, 2, 4.0)

wait(a)

fetch(a)

remotecall_fetch(sqrt, 2, 4.0)


# # Programming parallel tasks

using Pkg
Pkg.add("Distributions")
using Distributions  # precompile

@everywhere using Distributions

@everywhere println(rand(Normal()))

# ## @spawn macro

a=@spawn randn(5,5)^2

fetch(a)

b=rand(5,5)

a=@spawn b^2

fetch(a)


@time begin
   A = rand(1000,1000)
   Bref = @spawn A^2
   fetch(Bref)
end;

@time begin
   Bref = @spawn rand(1000,1000)^2
   fetch(Bref)
end;

# ## @spawnat

r = remotecall(rand, 2, 2, 2)

s = @spawnat 3 1 .+ fetch(r)

fetch(s)



# ## @parallel for

function serial_add()
    s=0.0
    for i = 1:1000000
         s=s+randn()
    end
    return s
end

function parallel_add()
    return @distributed (+) for i=1:1000000
       randn()
    end
end

@btime serial_add()

@btime parallel_add()

# ## Parallel map

x=[rand(100,100) for i in 1:10];

@everywhere using LinearAlgebra

@btime map(svd, x);

@btime pmap(svd, x);


# ## Distributed Monte Carlo

@everywhere function darts_in_circle(N)
    n = 0
    for i in 1:N
        if rand()^2 + rand()^2 < 1
            n += 1
        end
    end
    return n
end

function distributed_pi(N, loops)
    n = sum(pmap((x)->darts_in_circle(N), 1:loops))
    4 * n / (loops * N)
end


@btime distributed_pi(1_000_000, 50)

julia> @btime serial_pi(50_000_000)

# ## Distributed Arrays

using Pkg
Pkg.add("DistributedArrays")
using DistributedArrays
@everywhere using DistributedArrays
d=dzeros(12, 12)
x=rand(10,10);
dx = distribute(x)
