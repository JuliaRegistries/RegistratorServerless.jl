@inline function User!(kwargs_dict::Dict)
    if haskey(kwargs_dict, :user)
        user = User(kwargs_dict[:user])
        delete!(kwargs_dict, :user)
        return user
    end
    throw(UserNotProvidedError("Username of registering user not provided"))
end
