struct ClonedRegistry <: AbstractString
    path::String
end

struct ClonedPackage <: AbstractString
    path::String
end

struct Credential
    buf::Base.SecretBuffer
end

Base.@kwdef struct Config
    gh_hostname_for_api::String
    gh_hostname_for_clone::String
    github_token::Credential
    registry::String
    serverless_repo::String
end

struct User
    username::String
end

Base.@kwdef struct RegistrationRequest
    branch::String = ""
    repo::String
    subdir::String = ""
end

struct AlwaysAssertionError <: Exception
    msg::String
end

struct UserNotProvidedError <: Exception
    msg::String
end

struct UserNotAuthorizedError <: Exception
    msg::String
    user::String
    repo::String
end

struct IssueTitleError <: Exception
    msg::String
    issue_title::String
end
