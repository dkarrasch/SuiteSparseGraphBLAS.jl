function suffix(T::DataType)
    if T == Bool
        return "BOOL"
    elseif T == Int8
        return "INT8"
    elseif T == UInt8
        return "UINT8"
    elseif T == Int16
        return "INT16"
    elseif T == UInt16
        return "UINT16"
    elseif T == Int32
        return "INT32"
    elseif T == UInt32
        return "UINT32"
    elseif T == Int64
        return "INT64"
    elseif T == UInt64
        return "UINT64"
    elseif  T == Float32
        return "FP32"
    end
    return "FP64"
end

function get_GrB_Type(T::DataType)
    if T == Bool
        return GrB_BOOL
    elseif T == Int8
        return GrB_INT8
    elseif T == UInt8
        return GrB_UINT8
    elseif T == Int16
        return GrB_INT16
    elseif T == UInt16
        return GrB_UINT16
    elseif T == Int32
        return GrB_INT32
    elseif T == UInt32
        return GrB_UINT32
    elseif T == Int64
        return GrB_INT64
    elseif T == UInt64
        return GrB_UINT64
    elseif  T == Float32
        return GrB_FP32
    end
    return GrB_FP64
end

function default_dup(T::DataType)
    if T == Bool
        return GrB_FIRST_BOOL
    elseif T == Int8
        return GrB_FIRST_INT8
    elseif T == UInt8
        return GrB_FIRST_UINT8
    elseif T == Int16
        return GrB_FIRST_INT16
    elseif T == UInt16
        return GrB_FIRST_UINT16
    elseif T == Int32
        return GrB_FIRST_INT32
    elseif T == UInt32
        return GrB_FIRST_UINT32
    elseif T == Int64
        return GrB_FIRST_INT64
    elseif T == UInt64
        return GrB_FIRST_UINT64
    elseif  T == Float32
        return GrB_FIRST_FP32
    end
    return GrB_FIRST_FP64
end

function equal_op(T::DataType)
    if T == Bool
        return GrB_EQ_BOOL
    elseif T == Int8
        return GrB_EQ_INT8
    elseif T == UInt8
        return GrB_EQ_UINT8
    elseif T == Int16
        return GrB_EQ_INT16
    elseif T == UInt16
        return GrB_EQ_UINT16
    elseif T == Int32
        return GrB_EQ_INT32
    elseif T == UInt32
        return GrB_EQ_UINT32
    elseif T == Int64
        return GrB_EQ_INT64
    elseif T == UInt64
        return GrB_EQ_UINT64
    elseif  T == Float32
        return GrB_EQ_FP32
    end
    return GrB_EQ_FP64
end

function get_struct_name(object::GrB_Struct)
    T = typeof(object)
    if T <: GrB_UnaryOp
        return "UnaryOp"
    elseif T <: GrB_BinaryOp
        return "BinaryOp"
    elseif T <: GrB_Monoid
        return "Monoid"
    elseif T <: GrB_Semiring
        return "Semiring"
    elseif T <: GrB_Vector
        return "Vector"
    elseif T <: GrB_Matrix
        return "Matrix"
    end
    return "Descriptor"
end

function _GrB_Index(x::T) where T <: GrB_Index
    x > typemax(Int64) && return x
    return Int64(x)
end
