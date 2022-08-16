function cat!(C::GBVecOrMat, tiles::AbstractArray{T}) where {T<:GBVecOrMat}
    tiles = permutedims(tiles)
    @wraperror LibGraphBLAS.GxB_Matrix_concat(gbpointer(C), gbpointer.(tiles), size(tiles,2), size(tiles,1), C_NULL)
    return C
end

"""
    cat(tiles::Array{<:GBArray})

Create a new array formed from the contents of `tiles` in the sense of a block matrix
This doesn't exactly match the Julia notion of `cat`.
"""
function Base.cat(tiles::VecOrMat{<:Union{AbstractGBMatrix{T, F}, AbstractGBVector{T, F}}}) where {T, F}
    fills = getproperty.(tiles, :fill)
    if F <: Union{Nothing, Missing}
        fill = F()
    elseif all(y->y==fills[1], fills)
        fill = fills[1]
    else
        fill = zero(F)
    end
    ncols = sum(size.(tiles[1,:], 2))
    nrows = sum(size.(tiles[:, 1], 1))
    types = eltype.(tiles)
    t = types[1]
    for type ∈ types[2:end]
        t = promote_type(t, type)
    end
    sz = (tiles isa AbstractArray && ncols == 1) ? (nrows,) : (nrows, ncols)

    C = similar(tiles[1], t, sz; fill)
    return cat!(C, tiles)
end

vcat!(C, A::GBArrayOrTranspose...) = cat!(C, collect(A))
Base.vcat(A::GBArrayOrTranspose...) = cat(collect(A))

hcat!(C, A::GBArrayOrTranspose...) = cat!(C, permutedims(collect(A)))
Base.hcat(A::GBArrayOrTranspose...) = cat(permutedims(collect(A)))

# TODO split. I don't necessarily see a great need for split though. We have indexing/slicing.