@inline function Config!(kwargs_dict::Dict)
    config_kwargs_dict = Dict{Symbol, Any}()
    params = [
        (:gh_hostname_for_api,   "REGISTRATOR_GH_HOSTNAME_FOR_API",   "https://api.github.com"),
        (:gh_hostname_for_clone, "REGISTRATOR_GH_HOSTNAME_FOR_CLONE", "github.com"),
        (:registry,              "REGISTRATOR_REGISTRY"),
        (:serverless_repo,       "REGISTRATOR_SERVERLESS_REPO"),
    ]
    for param in params
        key = param[1]
        env_var = param[2]
        if haskey(kwargs_dict, key)
            config_kwargs_dict[key] = kwargs_dict[:registry]
            delete!(kwargs_dict, :registry)
        else
            if length(param) == 3
                default_value = param[3]
                config_kwargs_dict[key] = get(ENV, env_var, default_value)
            else
                config_kwargs_dict[key] = ENV[env_var]
            end
        end
    end
    github_token = Credential()
    if haskey(kwargs_dict, :github_token)
        github_token[] = kwargs_dict[:github_token]
        delete!(kwargs_dict, :github_token)
    else
        github_token[] = ENV["REGISTRATOR_GITHUB_TOKEN"]
    end
    config = Config(;
        github_token,
        config_kwargs_dict...
    )
    return config



    if haskey(kwargs_dict, :registry)
        registry = kwargs_dict[:registry]
        delete!(kwargs_dict, :registry)
    else
        registry = ENV[""]
    end
    if haskey(kwargs_dict, :serverless_repo)
        serverless_repo = kwargs_dict[:serverless_repo]
        delete!(kwargs_dict, :serverless_repo)
    else
        serverless_repo = ENV["REGISTRATOR_SERVERLESS_REPO"]
    end

end
