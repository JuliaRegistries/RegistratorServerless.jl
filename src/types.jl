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

@enum RegistrationType NewPackage NewVersion

Base.@kwdef struct RegistrationRequest
    git_reference::String
    package_name::String
    registration_type::RegistrationType
    repo::String
    subdir::String = ""
    user::String
    version::VersionNumber
end

struct AlwaysAssertionError <: Exception
    msg::String
end

struct UserNotAuthorizedError <: Exception
    msg::String
    user::String
    repo::String
end
