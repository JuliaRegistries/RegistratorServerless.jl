@inline function always_assert(condition::Bool, message::String)
    if !condition
        throw(AlwaysAssertionError(message))
    end
    return nothing
end
