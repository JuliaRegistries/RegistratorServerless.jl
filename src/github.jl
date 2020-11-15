@inline function GitHub.authenticate(config::Config)
    return GitHub.authenticate(config.github_token)
end

@inline function GitHub.authenticate(github_token::Credential)
    return GitHub.authenticate(github_token[])
end
