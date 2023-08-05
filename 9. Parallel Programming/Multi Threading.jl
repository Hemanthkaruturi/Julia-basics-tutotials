Threads.nthreads()

# You need to change the number of threads for Julia from command line
# set JULIA_NUM_THREADS=4
# $env:JULIA_NUM_THREADS=4 ## In Power Shell
# julia --threads 6
# and then restart the kernel

# This is only working in cmd or power shell
Threads.nthreads()

Threads.threadid() # see the thread

# Example from Julia documentation
mysum = Ref(0)

Threads.@threads for i in 1:1000
    mysum[] += 1
end

println("Normal arrays: ",mysum[])
# if you use multi threading you will get incorrect result
# To avoid this we need to use atomic arrays

mysum_a = Threads.Atomic{Int64}(0)

Threads.@threads for i in 1:1000
    Threads.atomic_add!(mysum_a,1)
end

println("Atomic arrays: ",mysum_a[])

# parallelism
# Install BenchmarkTools
# using Pkg
# Pkg.add("BenchmarkTools")
using Base.Threads
using BenchmarkTools

# Test without Threading
v = [rand(1_000_000) for i ∈ 1:36]

function vecmean(vec)
    s = 0
    count = 0
    for i in eachindex(vec)
        s += vec[i]
        count += 1
    end
    avg = s/count
    return avg
end

vecmean(v[1])

function serial_mean(vect)
    sums = zeros(length(vect))
    for i in eachindex(vect)
        sums[i] = vecmean(vect[i])
    end
    # return sums
end

# 145ms
# @btime println("Time without threads", serial_mean(v))
    
# Test with threads
function threaded_mean(vect)
    sums = zeros(length(vect))
    Threads.@threads for i in eachindex(vect)
        sums[i] = vecmean(vect[i])
    end
    # return sums
end

# 39ms
# @btime println("Time with threads: ",threaded_mean(v))

# using spawn
function spawn_mean(vect)
    tasks = [Threads.@spawn vecmean(vect[i]) for i in 1:length(vect)]
    sums = [fetch(t) for t in tasks]
    # return sums
end

# 42ms
# @btime println("With Spawn: ",spawn_mean(v))
# There is no mush improvement is spawn because all the vectors are of same length

# Lt see if the vectors are of different length
v1 = rand(20_000);
v2 = [rand(1000) for i in 1:143];
v = [v1, v2...];

sum_serial = serial_mean(v);
sum_thread = threaded_mean(v);
sum_spawn = spawn_mean(v);

# check our operation is correct or not.
sum_serial == sum_thread == sum_spawn

@btime serial_mean(v); # 594 μs
@btime threaded_mean(v); # 222 μs
@btime spawn_mean(v); # 197 μs