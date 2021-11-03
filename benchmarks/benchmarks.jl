using Pkg
Pkg.activate(".")
Pkg.instantiate()
using SuiteSparseMatrixCollection
using MatrixMarket
using SuiteSparseGraphBLAS
using BenchmarkTools
using DelimitedFiles
using SparseArrays
using LinearAlgebra
function benchmark(minsize, maxsize)
    println("Using SuiteSparse:GraphBLAS shared library at: $(SuiteSparseGraphBLAS.artifact_or_path)")
    println("SuiteSparseGraphBLAS Threads: $(SuiteSparseGraphBLAS.gbget(SuiteSparseGraphBLAS.NTHREADS))")
    ssmc = ssmc_db()
    matrices = filter(row ->  (minsize <= row.nnz <= maxsize) && row.real==true, ssmc)
    # THIS WILL DOWNLOAD THESE MATRICES. BE WARNED.
    paths = fetch_ssmc(matrices, format="MM")
    for i ∈ 1:length(paths)
        name = matrices[i, :name]
        println("$i/$(length(paths)) Matrix $name: ")
        singlebench(joinpath(paths[i], "$name.mtx"))
    end
end

function singlebench(file)
    GC.gc() #GC to be absolutely sure nothing is hanging around from last loop
    S = convert(SparseMatrixCSC{Float64}, MatrixMarket.mmread(file))
    G = GBMatrix(S)
    # Set to row, this will likely be default in the future, and is the most performant.
    SuiteSparseGraphBLAS.gbset(G, SuiteSparseGraphBLAS.FORMAT, SuiteSparseGraphBLAS.BYROW)
    # Not sure if gbset is FORMAT is lazy, so to be sure.
    diag(G)
    # Fairly wide dense matrix for rhs.
    m = rand(size(S, 2), 1000)
    m2 = GBMatrix(m)
    SuiteSparseGraphBLAS.gbset(SuiteSparseGraphBLAS.BURBLE, true)
    #println("--------------")
    #println("A * A':")
    #println("-------")
    #selfmultimes1 = @belapsed $S * ($S)' samples=1 evals=3
    #selfmultimes2 = @belapsed $G * ($G)' samples=1 evals=3
    #selfmultimesspeedup = selfmultimes1/selfmultimes2
    println("\nSparseArrays=$selfmultimes1\t GraphBLAS=$selfmultimes2\t SA/GB=$selfmultimesspeedup\n")
    println("A * Full:")
    println("---------")
    densemattimessparse = @belapsed $S * $m samples=1 evals=3
    densemattimesgb = @belapsed $G * $m2 samples=1 evals=3
    println("\nSparseArrays=$densemattimessparse\t GraphBLAS=$densemattimesgb\t SA/GB=$(densemattimessparse/densemattimesgb)\n")
    SuiteSparseGraphBLAS.gbset(SuiteSparseGraphBLAS.BURBLE, false)
end

if length(ARGS) != 0
    x = tryparse(Int64, ARGS[1])
    if x === nothing #assume it's a path if not an integer
        singlebench(ARGS[1])
    else
        (ARGS[1] isa Integer && ARGS[2] isa Integer && benchmark(ARGS[1], ARGS[2])) || benchmark(1000, 100000)
    end
end