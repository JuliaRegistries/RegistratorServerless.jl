@inline Credential() = Credential(Base.SecretBuffer())

@inline function Credential(value::AbstractString)
    cred = Credential()
    cred[] = value
    return cred
end

@inline function Base.shred!(cred::Credential)
    Base.shred!(cred.buf)
    return nothing
end

@inline function Base.shred!(config::Config)
    Base.shred!(config.github_token)
    return nothing
end

@inline function Base.setindex!(cred::Credential, value::String)
    Base.shred!(cred.buf)
    seekstart(cred.buf)
    write(cred.buf, value)
    return nothing
end

@inline function Base.getindex(cred::Credential)
    seekstart(cred.buf)
    value = read(cred.buf, String)::String
    return value
end
